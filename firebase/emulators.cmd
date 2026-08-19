@echo off
REM Starts the Firebase emulators with a supported JDK.
REM
REM firebase-tools requires Java 21+, but this machine has Java 8 earlier in the
REM machine PATH than JDK 21:
REM
REM   C:\Program Files (x86)\Common Files\Oracle\Java\java8path\java.exe  1.8.0_501
REM   C:\Program Files\Microsoft\jdk-21.0.12.8-hotspot\bin\java.exe       21.0.12
REM
REM firebase-tools invokes the bare command "java" and ignores JAVA_HOME, so the
REM only fix is to put JDK 21 first in PATH. Machine PATH beats user PATH on
REM Windows, so a user-level entry would not win - it has to be done per-process,
REM which is what this script does.
REM
REM Usage:  firebase\emulators.cmd

setlocal

set "JDK21=C:\Program Files\Microsoft\jdk-21.0.12.8-hotspot"

if not exist "%JDK21%\bin\java.exe" (
  echo ERROR: JDK 21 not found at "%JDK21%".
  echo Install it, or edit JDK21 in this script to point at your JDK 21+ install.
  exit /b 1
)

set "PATH=%JDK21%\bin;%PATH%"
set "JAVA_HOME=%JDK21%"

echo Using Java:
java -version
echo.

cd /d "%~dp0"
firebase emulators:start --project demo-yoogee --only auth,firestore,storage %*

endlocal
