@REM Maven Wrapper script for Windows
@echo off
setlocal EnableDelayedExpansion

set "MAVEN_PROJECTBASEDIR=%~dp0"
set "WRAPPER_JAR=%MAVEN_PROJECTBASEDIR%.mvn\wrapper\maven-wrapper.jar"
set "WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain"

if not exist "%WRAPPER_JAR%" (
    echo Error: Could not find maven-wrapper.jar
    exit /b 1
)

set "JAVA_EXE=java.exe"
if defined JAVA_HOME (
    set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
) else (
    where java >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        for /f "tokens=*" %%i in ('where java 2^>nul') do set "JAVA_EXE=%%i" & goto :java_found
    )
)
:java_found

REM Quote each argument so paths with spaces (e.g. C:\Program Files) are passed correctly to Java
set "MAVEN_ARGS="
:parse_args
if "%~1"=="" goto :run_java
set "MAVEN_ARGS=!MAVEN_ARGS! "%~1""
shift
goto :parse_args
:run_java

"%JAVA_EXE%" -Dmaven.multiModuleProjectDirectory="%MAVEN_PROJECTBASEDIR%" -classpath "%WRAPPER_JAR%" %WRAPPER_LAUNCHER% !MAVEN_ARGS!

endlocal
