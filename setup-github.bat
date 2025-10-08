@echo off
REM GitHub Setup Helper Script (Windows)
REM This script helps you connect your local repository to GitHub

echo.
echo ===================================
echo   GitHub Setup Helper
echo ===================================
echo.

REM Check if git is initialized
if not exist .git (
    echo ERROR: Not a git repository. Run 'git init' first.
    pause
    exit /b 1
)

echo [OK] Git repository detected
echo.

REM Check if remote already exists
git remote | findstr "origin" >nul
if %errorlevel% equ 0 (
    echo WARNING: Remote 'origin' already exists:
    git remote -v
    echo.
    set /p remove="Do you want to remove it and add a new one? (y/n): "
    if /i "%remove%"=="y" (
        git remote remove origin
        echo [OK] Removed existing remote
    ) else (
        echo Keeping existing remote. Exiting.
        pause
        exit /b 0
    )
)

echo.
echo Please provide your GitHub repository details:
echo.

REM Get GitHub username
set /p github_user="GitHub username: "

REM Get repository name
set /p repo_name="Repository name (default: MCP-figma): "
if "%repo_name%"=="" set repo_name=MCP-figma

REM Construct the URL
set repo_url=https://github.com/%github_user%/%repo_name%.git

echo.
echo Adding remote: %repo_url%
git remote add origin %repo_url%

echo [OK] Remote added successfully!
echo.

REM Show current branch
for /f "tokens=*" %%i in ('git branch --show-current') do set current_branch=%%i
echo Current branch: %current_branch%
echo.

REM Ask if they want to push now
set /p push_now="Do you want to push to GitHub now? (y/n): "

if /i "%push_now%"=="y" (
    echo.
    echo Pushing to GitHub...
    
    REM Ensure we're on main branch
    if not "%current_branch%"=="main" (
        echo Renaming branch to 'main'...
        git branch -M main
    )
    
    REM Push to GitHub
    git push -u origin main
    if %errorlevel% equ 0 (
        echo.
        echo [SUCCESS] Successfully pushed to GitHub!
        echo.
        echo Next steps:
        echo 1. Go to: https://github.com/%github_user%/%repo_name%
        echo 2. Click 'Settings' -^> 'Pages'
        echo 3. Under 'Source', select 'GitHub Actions'
        echo 4. Wait for deployment (check the 'Actions' tab^)
        echo 5. Your site will be live at: https://%github_user%.github.io/%repo_name%/
        echo.
    ) else (
        echo.
        echo [ERROR] Push failed. This might be because:
        echo   - The repository doesn't exist on GitHub yet
        echo   - You need to create it first at: https://github.com/new
        echo   - You might need to authenticate
        echo.
        echo After creating the repository on GitHub, run:
        echo   git push -u origin main
    )
) else (
    echo.
    echo Remote configured. When you're ready to push, run:
    echo   git push -u origin main
)

echo.
echo Done!
echo.
pause
