@echo off
chcp 65001 > nul
echo.
echo ========================================
echo Hugo 博客自动推送脚本（CMD 格式，双击运行）
echo ========================================
echo.

:: 第一步：切换到 main 分支（源码分支，确保有 Hugo 配置）
echo 【1/6】正在切换到 main 分支...
git checkout main
if %errorlevel% neq 0 (
    echo 提示：main 分支不存在，尝试创建并关联远程 main 分支...
    git checkout -b main origin/main
)
echo 已完成分支切换（若提示已在 main 分支，属正常现象）
echo.

:: 第二步：编译 Hugo 静态资源（生成 public 文件夹）
echo 【2/6】正在编译 Hugo 静态资源...
hugo
if %errorlevel% equ 0 (
    echo 静态资源编译成功，已生成 public 文件夹
) else (
    echo 错误：编译失败！请检查 Hugo 环境和配置文件（hugo.toml）
    pause
    exit /b 1
)
echo.

:: 第三步：切换到 gh-pages 分支（部署分支）
echo 【3/6】正在切换到 gh-pages 分支...
git checkout gh-pages
if %errorlevel% neq 0 (
    echo 提示：gh-pages 分支不存在，创建新分支...
    git checkout -b gh-pages
)
echo 已完成分支切换
echo.

:: 第四步：复制 public 内资源到 gh-pages 根目录（无嵌套，删除 public）
echo 【4/6】正在复制静态资源到根目录...
if exist "public" (
    :: 复制 public 内所有内容到当前目录（根目录）
    xcopy "public\*" "." /s /e /y /q
    :: 删除 public 文件夹，避免嵌套
    rd /s /q "public"
    echo 静态资源复制完成，已删除冗余 public 文件夹
) else (
    echo 错误：public 文件夹不存在，编译失败！
    pause
    exit /b 1
)
echo.

:: 第五步：Git 暂存并提交更新
echo 【5/6】正在暂存并提交更新...
git add .
git commit -m "更新博客：自动推送新内容（CMD 脚本）"
echo 提交完成（若提示「无文件更改」，属正常现象，无需担心）
echo.

:: 第六步：推送到远程 GitHub gh-pages 分支
echo 【6/6】正在推送到远程 GitHub...
git push origin gh-pages
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo 推送成功！
    echo 温馨提示：等待 5 分钟左右，线上博客将自动同步更新
    echo 博客地址：https://heartbees.github.io
    echo ========================================
) else (
    echo.
    echo ========================================
    echo 推送失败！首次部署请手动执行以下命令：
    echo git push origin gh-pages -f
    echo ========================================
)

:: 脚本结束，暂停查看结果
echo.
pause