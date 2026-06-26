@echo off
chcp 65001 >nul

:: 检查管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% NEQ 0 (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:menu
cls
echo =============================================
echo         快捷方式箭头管理工具
echo =============================================
echo.
echo   [1] 隐藏快捷方式箭头
echo   [2] 恢复快捷方式箭头
echo   [3] 退出
echo.
echo =============================================
echo.

:select
set /p choice=请选择操作 (1/2/3)： 

if "%choice%"=="1" goto hide
if "%choice%"=="2" goto restore
if "%choice%"=="3" goto exit
echo 输入无效，请重新选择！
timeout /t 2 >nul
goto menu

:hide
cls
echo =============================================
echo           正在隐藏快捷方式箭头...
echo =============================================
echo.

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d "%systemroot%\system32\imageres.dll,197" /t REG_SZ /f >nul 2>&1

echo 正在重启Windows资源管理器以应用更改...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo 操作完成！快捷方式箭头已被隐藏。
echo 3秒后自动退出...
timeout /t 3 >nul
exit

:restore
cls
echo =============================================
echo           正在恢复快捷方式箭头...
echo =============================================
echo.

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /f >nul 2>&1

echo 正在重启Windows资源管理器以应用更改...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo 操作完成！快捷方式箭头已恢复。
echo 3秒后自动退出...
timeout /t 3 >nul
exit

:exit
echo.
echo 感谢使用，再见！
timeout /t 2 >nul
exit