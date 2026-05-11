# 部署到腾讯云 EdgeOne Pages

本仓库是 **Unity WebGL 纯静态站点**（无 `package.json`）。已在根目录提供 **`edgeone.json`**，EdgeOne 构建时会执行 **`scripts/edgeone-build.sh`**，把需要上线的文件复制到 **`dist/`** 作为输出目录。

## 在 EdgeOne Pages 控制台要做的事

1. **导入 Git 仓库**（GitHub 上的 `ygwenjianjia`）。
2. 打开 **项目设置 → 构建部署配置**，建议与 `edgeone.json` 保持一致（若控制台留空，也会读取仓库里的 `edgeone.json`）：
   - **根目录**：`/`（仓库根）
   - **安装命令**：`true`（无 npm 依赖）
   - **构建命令**：`bash scripts/edgeone-build.sh`
   - **输出目录**：`dist`
3. 保存后 **重新部署**。成功后用 Pages 分配的域名访问根路径即可打开 `index.html`。

## Git LFS 说明

`Build/ygwenjianjia.data` 等大文件使用 **Git LFS**。请确认 EdgeOne 拉取仓库时会拉取 LFS 对象（若构建日志里 `dist/Build/*.data` 只有几百字节，说明 LFS 未拉取成功，需在平台侧开启/配置 LFS 或使用不含 LFS 的发布分支）。

## `edgeone.json` 做了什么

- 声明 **无 npm 安装**、**构建脚本**、**输出目录 `dist`**。
- 为 **`/Build/*.wasm`** 等路径补充 **Content-Type** 与 **Cache-Control**，减少浏览器对 WebGL 资源的兼容问题。

若你之后把 `data`/`wasm` 放到腾讯云 COS 等外链，只需改 `index.html` 里的 URL；`edgeone.json` 一般无需改动。
