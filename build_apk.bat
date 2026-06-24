@echo off
title Cliniprax APK Builder
echo ==========================================
echo Cliniprax Android APK Builder
echo ==========================================
echo.

:: Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter SDK was not found in your system PATH.
    echo.
    echo Please follow these steps to install it:
    echo 1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
    echo 2. Extract it and add the "flutter\bin" folder to your system Environment Variables (Path).
    echo 3. Install Android Studio and set up the Android SDK.
    echo 4. Open a new command prompt and run this script again.
    echo.
    pause
    exit /b
)

echo [INFO] Flutter SDK found.
echo.

:: Check if android directory exists, if not generate it
if not exist android (
    echo [INFO] Generating Android platform files...
    call flutter create . --platforms=android
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to generate Android platform files.
        pause
        exit /b
    )
)

echo [INFO] Injecting secure native settings (Screen protection)...
mkdir "%~dp0android\app\src\main\kotlin\com\example\cliniprax_osce" 2>nul
copy /Y "%~dp0android_template\MainActivity.kt" "%~dp0android\app\src\main\kotlin\com\example\cliniprax_osce\MainActivity.kt" >nul
if %errorlevel% neq 0 (
    echo [WARNING] Failed to inject custom MainActivity.kt. Screenshots may not be blocked.
) else (
    echo [INFO] Screenshot protection successfully integrated!
)


echo [INFO] Fetching packages and dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to fetch packages. Please check your internet connection.
    pause
    exit /b
)

echo [INFO] Building Android APK (Release mode)...
echo This may take a few minutes for the first build...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] APK build failed.
    echo.
    echo Please make sure you have:
    echo 1. Android Studio and Android SDK installed.
    echo 2. Java JDK installed and JAVA_HOME environment variable set.
    echo 3. Run "flutter doctor" in a new command prompt to diagnose any environment issues.
    echo.
    pause
    exit /b
)

echo.
echo =======================================================
echo [SUCCESS] APK built successfully!
echo.
echo You can find the APK file here:
echo %~dp0build\app\outputs\flutter-apk\app-release.apk
echo =======================================================
echo.
explorer "%~dp0build\app\outputs\flutter-apk\"
pause
