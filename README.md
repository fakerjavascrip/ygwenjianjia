# ygwenjianjia

Unity WebGL 游戏《精卫填海》静态站点，通过 GitHub Actions 部署到 GitHub Pages（大文件 `*.data` 使用 Git LFS）。

## 公开访问地址（部署成功后）

https://fakerjavascrip.github.io/ygwenjianjia/

## 首次启用 Pages（只需做一次）

若 **Actions** 里 “Deploy GitHub Pages” 失败，请按顺序操作：

1. 打开仓库设置：[Pages 设置](https://github.com/fakerjavascrip/ygwenjianjia/settings/pages)
2. **Build and deployment** → **Source** 选择 **GitHub Actions**（不要选 “Deploy from a branch”）。
3. 打开 [Actions 列表](https://github.com/fakerjavascrip/ygwenjianjia/actions)，点开最近一次失败的工作流，点击 **Re-run all jobs**。

通过后几分钟内，即可用上面的 `github.io` 链接访问；以后每次推送到 `main` 会自动重新部署。
