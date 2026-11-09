@echo off
rem ================================================================
rem  AgroGest - iniciar la aplicacion con doble clic (Windows)
rem  Requisitos: JDK 21 instalado y MySQL en ejecucion.
rem  Para detener la aplicacion: cerrar esta ventana o pulsar Ctrl+C.
rem ================================================================
setlocal
cd /d "%~dp0"
title AgroGest

rem --- Buscar un JDK 21 (usa JAVA_HOME si ya apunta a Java 21) ---
set "JDK21="
if defined JAVA_HOME if exist "%JAVA_HOME%\bin\javac.exe" (
    "%JAVA_HOME%\bin\java" -version 2>&1 | findstr /c:"version \"21" >nul && set "JDK21=%JAVA_HOME%"
)
if not defined JDK21 for /d %%D in ("C:\Program Files\Eclipse Adoptium\jdk-21*" "C:\Program Files\Java\jdk-21*" "C:\Program Files\Microsoft\jdk-21*") do (
    if exist "%%~D\bin\javac.exe" set "JDK21=%%~D"
)
if not defined JDK21 (
    echo No se encontro un JDK 21. Instalelo desde https://adoptium.net/ y vuelva a intentar.
    pause
    exit /b 1
)
set "JAVA_HOME=%JDK21%"
set "PATH=%JAVA_HOME%\bin;%PATH%"
echo Usando Java: %JAVA_HOME%

if not exist ".env" (
    echo Falta el archivo .env. Copie .env.example como .env y complete los datos.
    pause
    exit /b 1
)

echo.
echo Iniciando AgroGest... la primera vez tarda unos minutos (descarga dependencias).
echo Cuando aparezca "Started AgroGestApplication", abra http://localhost:8080
echo.
start "" cmd /c "timeout /t 40 /nobreak >nul & start http://localhost:8080"
call "%~dp0mvnw.cmd" spring-boot:run
echo.
echo AgroGest se detuvo.
pause
