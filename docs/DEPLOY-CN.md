# 国内访问加速：把 WebGL 静态站放到国内对象存储

`github.io` 服务器在海外，国内用户下载 **一百多 MB** 的 `.data` / `.wasm` 往往会慢或不稳定。常见做法是：**继续用 GitHub 存代码 + Actions 构建**，把构建结果**同步到国内 OSS**，再开 **CDN**（或 OSS 自带静态网站域名）。

下面以 **阿里云 OSS** 为例（腾讯云 COS、华为云 OBS 思路相同：对象存储 + 静态网站 + CDN）。

## 一、在阿里云准备

1. 开通 **对象存储 OSS**，新建 **Bucket**（例如 `my-game-webgl`）。
2. 读写权限按官方文档配置（静态公开读需 **公共读** 或 **仅对 CDN/OSS 策略授权**，勿把主账号 AK 提交到 Git）。
3. 建议单独创建 **RAM 用户**，只授予该 Bucket 的 `oss:PutObject`、`oss:GetObject`、`oss:ListObjects`、`oss:DeleteObject`（若用 `sync` 会删远端多余文件则要有 Delete；若只用 `cp` 可收紧策略）。
4. 记下 **Endpoint**（如华东 2：`oss-cn-shanghai.aliyuncs.com`）、**AccessKey ID / Secret**。
5. （可选）在 Bucket **传输管理 → 静态页面**：索引文档填 `index.html`，错误文档可先填 `index.html`（SPA 式单页游戏常用）。
6. （可选）在 **CDN** 里把源站指向该 OSS，绑定已备案域名，HTTPS 证书在 CDN 控制台申请即可。

## 二、在 GitHub 仓库配置 Secrets

打开：`https://github.com/<你的用户名>/ygwenjianjia/settings/secrets/actions`

新增 **Repository secrets**（名称需与下面一致）：

| Secret 名称 | 含义 |
|-------------|------|
| `ALIYUN_OSS_ACCESS_KEY_ID` | RAM 用户的 AccessKey ID |
| `ALIYUN_OSS_ACCESS_KEY_SECRET` | RAM 用户的 AccessKey Secret |
| `ALIYUN_OSS_ENDPOINT` | 地域 Endpoint，如 `oss-cn-shanghai.aliyuncs.com`（不要带 `https://`） |
| `ALIYUN_OSS_BUCKET` | Bucket 名称 |

对象前缀 **不必** 配在 Secret 里：运行工作流时在 **oss_prefix** 里填（默认 `ygwenjianjia/`；若 Bucket 只给本站用，可填 `-` 表示同步到 **Bucket 根目录**）。

## 三、手动触发同步

配置好 Secrets 后：

1. 打开仓库 **Actions**。
2. 选择 **Sync site to Aliyun OSS (China)**。
3. 点 **Run workflow**（按需修改 **oss_prefix**：默认子目录 `ygwenjianjia/`，或 `-` 表示根目录）。
4. 等待成功。

同步完成后，访问方式取决于你在 OSS/CDN 上的域名配置，例如：

- OSS 静态网站域名：`https://<bucket>.<oss-region>.aliyuncs.com/<PREFIX>index.html`
- 或你绑定的 **CDN 自定义域名**：`https://game.example.com/`（需在 `index.html` 里保证资源路径与部署路径一致；当前模板已按「子路径」处理，把整站挂在域名子目录时一般也适用）。

## 四、与 GitHub Pages 的关系

- **GitHub Pages**：可继续保留，给海外或备用访问。
- **OSS/CDN**：给国内用户主推链接即可。

二者内容一致，靠同一套 Actions 组装的 `_site` 分别上传（Pages 工作流已有；OSS 工作流为**手动触发**，避免在未配密钥时失败）。

## 五、其他可选方案（自行调研计费与备案）

- **腾讯云 COS** + CDN：用 `coscli` 或官方 Action 同步 `_site`。
- **华为云 OBS**、**七牛云 Kodo**、**又拍云**：同样是静态资源 + CDN。
- **Gitee Pages**：可镜像仓库做静态页，但大文件与 LFS 限制需看当前套餐，不一定适合超大 WebGL 包。

---

若你希望 **推送 main 就自动同步 OSS**（而不是手动 Run workflow），把 `.github/workflows/sync-aliyun-oss.yml` 里的触发条件改成与 `pages.yml` 相同即可（注意流量费用与误推风险）。
