@echo off
REM Drag sticker files onto this file, or: unbg.bat sticker.webp [more...]
if "%~1"=="" (
  echo Drop PNG/APNG/WebP/GIF files onto this file, or pass them as arguments.
  pause
  exit /b 1
)
python "%~dp0unbg.py" %*
if errorlevel 1 pause
