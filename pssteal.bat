@echo off
if "%~1"=="" (
    echo Ошибка: укажите путь к PS-файлу.
    exit /b 1
)

set "lib=%~dp0steal.ps"
set "file=%~f1"
set "file=%file:\=/%"

:: Проверка, существует ли библиотека
if not exist "%lib%" (
    echo Ошибка: не найден файл steal.ps рядом с этим скриптом!
    echo Ожидалось: %lib%
    exit /b 1
)

if not exist "%~f1" (
    echo Ошибка: файл не найден: %~f1
    exit /b 1
)

:: Передаём путь через переменную, чтобы безопасно обработать скобки в названиях папок
set "STEAL_TARGET=%file%"

gswin64c -q -dNOPAUSE -dBATCH -dNOSAFER -sDEVICE=nullpage "%lib%" -c "(STEAL_TARGET) getenv {stealstart} if"