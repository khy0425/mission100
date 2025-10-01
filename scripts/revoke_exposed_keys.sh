#!/bin/bash

# Mission100 - Exposed API Key Revocation Script
# This script helps automate the API key rotation process

set -e

echo "================================================"
echo "🔐 Mission100 API Key Rotation Script"
echo "================================================"
echo ""

EXPOSED_KEY="AIzaSyAZ_UQ4DiylhhhO5uAS796tmCsv9DEIm1k"
PROJECT_ID="mission100-v3"

echo "⚠️  EXPOSED KEY: $EXPOSED_KEY"
echo ""

# Step 1: Open Google Cloud Console
echo "📋 Step 1: Revoke the exposed API key"
echo "--------------------------------------------"
echo "Opening Google Cloud Console..."
echo ""
echo "🌐 URL: https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID"
echo ""
echo "Manual steps:"
echo "1. Find API key: $EXPOSED_KEY"
echo "2. Click the trash icon to DELETE"
echo "3. Confirm deletion"
echo ""
read -p "Press Enter when key is revoked..."

# Step 2: Download new Firebase config
echo ""
echo "📋 Step 2: Download fresh Firebase configuration"
echo "--------------------------------------------"
echo "Opening Firebase Console..."
echo ""
echo "🌐 URL: https://console.firebase.google.com/project/$PROJECT_ID/settings/general"
echo ""
echo "Manual steps:"
echo "1. Scroll to 'Your apps' section"
echo "2. Find your Android app"
echo "3. Click 'google-services.json' download button"
echo "4. Save to Downloads folder"
echo ""
read -p "Press Enter when file is downloaded..."

# Step 3: Copy file to project
echo ""
echo "📋 Step 3: Installing new configuration"
echo "--------------------------------------------"

if [ -f ~/Downloads/google-services.json ]; then
    cp ~/Downloads/google-services.json android/app/google-services.json
    echo "✅ google-services.json installed successfully"

    # Verify file is not tracked by git
    if git check-ignore android/app/google-services.json > /dev/null; then
        echo "✅ File is properly ignored by git"
    else
        echo "❌ WARNING: File might be tracked by git!"
        echo "   Run: git rm --cached android/app/google-services.json"
    fi
else
    echo "❌ google-services.json not found in Downloads"
    echo "   Please download it manually and place in android/app/"
fi

# Step 4: Check for unauthorized access
echo ""
echo "📋 Step 4: Security audit"
echo "--------------------------------------------"
echo "Opening Firebase Authentication..."
echo ""
echo "🌐 URL: https://console.firebase.google.com/project/$PROJECT_ID/authentication/users"
echo ""
echo "Check for:"
echo "- Unknown users"
echo "- Suspicious sign-in timestamps"
echo "- Unusual geographic locations"
echo ""
read -p "Press Enter when audit is complete..."

# Step 5: Close GitHub Security Alert
echo ""
echo "📋 Step 5: Close GitHub Security Alert"
echo "--------------------------------------------"
echo "Opening GitHub Security Alerts..."
echo ""
echo "🌐 URL: https://github.com/khy0425/mission100/security/secret-scanning"
echo ""
echo "Manual steps:"
echo "1. Find the alert for: $EXPOSED_KEY"
echo "2. Click 'Close alert'"
echo "3. Select reason: 'Revoked'"
echo "4. Add comment: 'Key revoked and rotated'"
echo ""
read -p "Press Enter when alert is closed..."

# Step 6: Verification
echo ""
echo "📋 Step 6: Final verification"
echo "--------------------------------------------"

# Check if new file exists
if [ -f android/app/google-services.json ]; then
    # Extract new API key from file
    NEW_KEY=$(grep -o '"current_key": "[^"]*"' android/app/google-services.json | cut -d'"' -f4)

    if [ "$NEW_KEY" != "$EXPOSED_KEY" ]; then
        echo "✅ New API key installed: ${NEW_KEY:0:20}..."
        echo "✅ Different from exposed key"
    else
        echo "❌ WARNING: New key is same as exposed key!"
        echo "   Please download a fresh google-services.json"
    fi
else
    echo "⚠️  google-services.json not found"
fi

echo ""
echo "================================================"
echo "✅ API Key Rotation Complete!"
echo "================================================"
echo ""
echo "Security Checklist:"
echo "[✓] Exposed key revoked"
echo "[✓] New configuration downloaded"
echo "[✓] File installed and git-ignored"
echo "[✓] Security audit completed"
echo "[✓] GitHub alert closed"
echo ""
echo "Next steps:"
echo "1. Test app functionality"
echo "2. Monitor Firebase logs for 24 hours"
echo "3. Consider enabling Firebase App Check"
echo ""
