@echo off
echo ========================================
echo Firebase Secret API Key Setup
echo ========================================
echo.
echo This script will help you set up OpenAI API key securely in Firebase.
echo.
echo Step 1: Install dependencies
echo ----------------------------------------
cd functions
call npm install
if %errorlevel% neq 0 (
    echo ERROR: npm install failed
    pause
    exit /b 1
)
echo.
echo Step 2: Set Firebase Secret
echo ----------------------------------------
cd ..
echo.
echo Please enter your OpenAI API key when prompted.
echo The key should start with "sk-"
echo.
firebase functions:secrets:set OPENAI_API_KEY
if %errorlevel% neq 0 (
    echo ERROR: Failed to set secret
    pause
    exit /b 1
)
echo.
echo Step 3: Deploy Firebase Functions
echo ----------------------------------------
echo.
firebase deploy --only functions
if %errorlevel% neq 0 (
    echo ERROR: Deploy failed
    pause
    exit /b 1
)
echo.
echo ========================================
echo SUCCESS! API key is now secure!
echo ========================================
echo.
echo Your API key is stored in Firebase Secret Manager.
echo It is NOT in your app code or Git repository.
echo.
pause
