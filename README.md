# heartbees.github.io

个人博客 —— **「Jimlynn的数字花园」**，记录 AI 探索、技术学习与生活感悟。

基于 [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) 主题构建，推送源码到 `main` 分支后由 **GitHub Actions** 自动构建并发布到 GitHub Pages。

## 在线访问

<https://heartbees.github.io/>

## 技术栈

| 用途 | 方案 |
| --- | --- |
| 静态站点生成 | Hugo（extended）0.153.4 |
| 主题 | PaperMod |
| 评论系统 | Waline |
| 自动部署 | GitHub Actions（`main` → `gh-pages`） |

## 目录结构

```text
.
├── content/
│   ├── about.md              # 「关于」页面
│   └── posts/                # 所有文章（Markdown）
├── layouts/                  # 覆盖主题的自定义布局
│   ├── index.html            # 自定义首页（hero + 最新文章）
│   ├── _default/single.html  # 文章详情页
│   ├── partials/comments.html# Waline 评论组件
│   └── shortcodes/font.html  # 自定义字号/颜色短代码
├── static/
│   ├── images/                  # 图片资源（原样拷贝到站点根 /images/）
│   └── seasons-atlas/           # 「岁时 SeasonAtlas」独立静态站（/seasons-atlas/）
│       ├── index.html           # 主入口（地图/筛选/收藏/日历）
│       ├── data.js              # 206 个目的地数据（含图与署名）
│       ├── dest/                # 206 个目的地独立页 + .ics + 索引
│       ├── assets/dest.css      # 目的地页共享样式
│       └── sitemap.xml          # 子站 sitemap（绝对 URL 已指向线上）
├── assets/                   # 需要被 Hugo 处理的静态资源
├── themes/PaperMod/          # 主题（直接内置，随仓库一起维护）
├── .github/workflows/deploy.yml  # 自动部署流水线
└── hugo.toml                 # 站点配置
```

## 本地开发

前置：安装 Hugo（extended 版）。

```bash
# 启动本地预览（含草稿），默认 http://localhost:1313
hugo server -D

# 生成静态文件到 public/
hugo

# 构建产物有问题时清缓存
rm -rf public/ resources/
```

## 写一篇新文章

在 `content/posts/` 下新建 `.md` 文件，头部使用 Front Matter（推荐统一用 YAML）：

```markdown
---
title: 文章标题
description: 一句话摘要（可选）
date: 2026-10-02T10:00:00+08:00
tags: ["标签1", "标签2"]
categories: ["分类"]
draft: false
---

正文内容……
```

注意两点：`draft` 必须是 `false` 才会发布；`date` 不要写成未来时间，否则会被 Hugo 跳过。

## 部署

把改动推送到 `main` 分支即可，GitHub Actions 会自动完成构建与发布，无需手动操作：

```bash
git add .
git commit -m "更新文章"
git push origin main
```

构建日志可在仓库的 **Actions** 页面查看，线上效果见 <https://heartbees.github.io/>。

## License

内容版权归作者所有；主题部分遵循 PaperMod 的 MIT 许可。
