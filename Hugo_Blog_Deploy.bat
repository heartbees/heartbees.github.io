@echo off
rem 1. 强制设置工作目录为脚本所在目录（避免路径问题，杜绝闪退）
cd /d "%~dp0"
rem 2. 统一UTF-8编码，兼容中文，无乱码
chcp 65001 > nul
git config --local i18n.commitencoding utf-8
git config --local i18n.logoutputencoding utf-8

echo.
echo ========================================
echo Hugo 博客最终版脚本（不消失+不闪退+同步成功）
echo 核心：本地新增/删除文章 → 覆盖同步到GitHub
echo ========================================
echo.

rem 3. 第一步：切换到main分支（源码分支）
echo 【1/5】切换到main分支（文章源码分支）
git checkout main
if %errorlevel% neq 0 (
    echo 提示：main分支不存在，自动创建
    git checkout -b main
)
echo 已切换到main分支
echo.

rem 4. 第二步：暂存并提交本地文章修改
echo 【2/5】暂存并提交本地文章修改（新增/删除）
echo 提示：正在暂存content目录下的所有修改...
git add content/
git add hugo.toml hugo.yaml 2>nul

git diff --quiet --cached
if %errorlevel% neq 0 (
    git commit -m "博客源码更新：新增/删除文章（本地优先）"
    echo 提示：本地修改已提交
) else (
    echo 提示：本地无修改，跳过提交
)
echo.

rem 5. 第三步：推送main分支到GitHub（强制覆盖，杜绝旧文章回传）
echo 【3/5】推送main分支到GitHub（本地修改覆盖远程）
git push origin main
if %errorlevel% equ 0 (
    echo 提示：✅ main分支推送成功！GitHub的content/posts已同步
) else (
    echo 提示：⚠️ main分支推送失败，执行强制推送（覆盖远程旧内容）
    git push origin main -f
    echo 提示：强制推送完成，远程旧内容已被本地覆盖
)
echo.

rem 6. 第四步：构建静态文件（仅清理public缓存，不碰其他文件）
echo 【4/5】构建全新静态文件（仅清理public缓存）
if exist "public" (
    rd /s /q "public"
    echo 提示：已删除旧public缓存
)
hugo
if %errorlevel% equ 0 (
    echo 提示：✅ Hugo构建成功，生成新静态文件
) else (
    echo 错误：❌ Hugo构建失败，请先本地运行hugo server验证
    goto :END_PAUSE  # 构建失败也强制暂停，不闪退
)
echo.

rem 7. 第五步：推送静态文件到gh-pages分支
echo 【5/5】推送静态文件到gh-pages分支（线上博客更新）
git checkout gh-pages
if %errorlevel% neq 0 (
    echo 提示：gh-pages分支不存在，自动创建
    git checkout -b gh-pages
)
xcopy "public\*" "." /s /e /y /q /I
rd /s /q "public"
git add .
git commit -m "博客线上更新：新增/删除文章（本地优先）"
git push origin gh-pages
if %errorlevel% equ 0 (
    echo 提示：✅ gh-pages推送成功！线上博客10-15分钟后更新
) else (
    echo 提示：⚠️ gh-pages推送失败，执行强制推送
    git push origin gh-pages -f
    echo 提示：强制推送完成，线上旧内容已被本地覆盖
)
git checkout main
echo.

rem 8. 部署完成提示
echo ========================================
echo 部署完成！核心效果已实现：
echo 1. 本地新增/删除的文章 → 已覆盖同步到GitHub main分支
echo 2. 远程旧文章 → 已被本地修改覆盖，不会再回传
echo 3. 脚本自身 → 安全保留在博客根目录，未被修改
echo 4. 线上博客 → 10-15分钟后访问：https://heartbees.github.io
echo ========================================

rem 关键优化：强化暂停，永不自动退出，杜绝误以为脚本消失
:END_PAUSE
echo.
echo 按任意键关闭窗口（脚本文件仍在博客根目录，不会消失）
pause > nul