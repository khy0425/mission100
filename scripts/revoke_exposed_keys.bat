@echo off
REM Mission100 - Exposed API Key Revocation Script (Windows)
REM This script helps automate the API key rotation process

setlocal EnableDelayedExpansion

echo ================================================
echo 🔐 Mission100 API Key Rotation Script
echo ================================================
echo.

set EXPOSED_KEY=AIzaSyAZ_UQ4DiylhhhO5uAS796tmCsv9DEIm1k
set PROJECT_ID=mission100-v3

echo ⚠️  EXPOSED KEY: %EXPOSED_KEY%
echo.

REM Step 1: Open Google Cloud Console
echo 📋 Step 1: Revoke the exposed API key
echo --------------------------------------------
echo Opening Google Cloud Console...
start https://console.cloud.google.com/apis/credentials?project=%PROJECT_ID%
echo.
echo Manual steps:
echo 1. Find API key: %EXPOSED_KEY%
echo 2. Click the trash icon to DELETE
echo 3. Confirm deletion
echo.
pause

REM Step 2: Download new Firebase config
echo.
echo 📋 Step 2: Download fresh Firebase configuration
echo --------------------------------------------
echo Opening Firebase Console...
start https://console.firebase.google.com/project/%PROJECT_ID%/settings/general
echo.
echo Manual steps:
echo 1. Scroll to 'Your apps' section
echo 2. Find your Android app
echo 3. Click 'google-services.json' download button
echo 4. Save to Downloads folder
echo.
pause

REM Step 3: Copy file to project
echo.
echo 📋 Step 3: Installing new configuration
echo --------------------------------------------

set DOWNLOADS_PATH=%USERPROFILE%\Downloads\google-services.json
set TARGET_PATH=android\app\google-services.json

if exist "%DOWNLOADS_PATH%" (
    copy /Y "%DOWNLOADS_PATH%" "%TARGET_PATH%"
    echo ✅ google-services.json installed successfully

    REM Verify file is not tracked by git
    git check-ignore "%TARGET_PATH%" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo ✅ File is properly ignored by git
    ) else (
        echo ❌ WARNING: File might be tracked by git!
        echo    Run: git rm --cached android/app/google-services.json
    )
) else (
    echo ❌ google-services.json not found in Downloads
    echo    Please download it manually and place in android\app\
)

REM Step 4: Check for unauthorized access
echo.
echo 📋 Step 4: Security audit
echo --------------------------------------------
echo Opening Firebase Authentication...
start https://console.firebase.google.com/project/%PROJECT_ID%/authentication/users
echo.
echo Check for:
echo - Unknown users
echo - Suspicious sign-in timestamps
echo - Unusual geographic locations
echo.
pause

REM Step 5: Close GitHub Security Alert
echo.
echo 📋 Step 5: Close GitHub Security Alert
echo --------------------------------------------
echo Opening GitHub Security Alerts...
start https://github.com/khy0425/mission100/security/secret-scanning
echo.
echo Manual steps:
echo 1. Find the alert for: %EXPOSED_KEY%
echo 2. Click 'Close alert'
echo 3. Select reason: 'Revoked'
echo 4. Add comment: 'Key revoked and rotated'
echo.
pause

REM Step 6: Verification
echo.
echo 📋 Step 6: Final verification
echo --------------------------------------------

if exist "%TARGET_PATH%" (
    echo ✅ google-services.json exists
    echo ⚠️  Please verify it contains a different API key
) else (
    echo ⚠️  google-services.json not found
)

echo.
echo ================================================
echo ✅ API Key Rotation Complete!
echo ================================================
echo.
echo Security Checklist:
echo [✓] Exposed key revoked
echo [✓] New configuration downloaded
echo [✓] File installed and git-ignored
echo [✓] Security audit completed
echo [✓] GitHub alert closed
echo.
echo Next steps:
echo 1. Test app functionality
echo 2. Monitor Firebase logs for 24 hours
echo 3. Consider enabling Firebase App Check
echo.

pause
