@echo off
if "%~1"=="" (
    echo Ошибка: укажите путь к PS-файлу.
    exit /b 1
)
if "%~2"=="" (
    echo Ошибка: укажите выходной файл ^(out^).
    exit /b 1
)
if "%~3"=="" (
    echo Ошибка: укажите устройство ^(device^), например pdfwrite.
    exit /b 1
)

set "lib=%~dp0steal.ps"
set "file=%~f1"
set "file=%file:\=/%"
set "out=%~f2"
set "out=%out:\=/%"
set "dev=%~3"

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

gswin64c -q -dNOPAUSE -dBATCH -dNOSAFER -sDEVICE=%dev% -sOutputFile="%out%" "%lib%" -c "(STEAL_TARGET) getenv {stealstart} if"

if errorlevel 1 (
    echo Ошибка: Ghostscript завершился с кодом %errorlevel%.
    exit /b 1
)

if /i "%dev%"=="nullpage" (
    echo Режим nullpage: выходной файл не создаётся.
) else if not exist "%~f2" (
    echo Внимание: устройство %dev% завершилось без ошибки, но файл %out% не создан.
    exit /b 1
) else (
    echo Готово: %out%
)
