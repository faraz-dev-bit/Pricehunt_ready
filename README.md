# PriceHunt Flutter 🛍️

India's Smartest Shopping App — Compare prices across Amazon, Flipkart & more!

## Termux Se GitHub Push Karne Ka Tarika

### Step 1 — Git Setup
```bash
pkg update && pkg upgrade -y
pkg install git -y
git config --global user.name "TumharaName"
git config --global user.email "email@gmail.com"
```

### Step 2 — GitHub SSH Key
```bash
pkg install openssh -y
ssh-keygen -t ed25519 -C "email@gmail.com"
cat ~/.ssh/id_ed25519.pub
# Ye key GitHub Settings > SSH Keys mein add karo
```

### Step 3 — New GitHub Repo Banao
1. github.com/new par jao
2. Name: `pricehunt-flutter`
3. Private select karo
4. **README initialize mat karo** (important!)
5. Create Repository

### Step 4 — Is ZIP ko Extract Karo aur Push Karo
```bash
cd ~
# ZIP extract karo jahan bhi save kiya ho
unzip pricehunt_flutter.zip
cd pricehunt_flutter

# Git initialize karo
git init
git add .
git commit -m "Initial commit - PriceHunt Flutter with android folder"

# GitHub se connect karo (apna username daalo)
git remote add origin git@github.com:TumharaUsername/pricehunt-flutter.git
git branch -M main
git push -u origin main
```

### Step 5 — Codemagic Build
1. codemagic.io login karo
2. Add Application > GitHub repo select karo
3. Flutter App select karo
4. Start new build!

## Project Structure
```
pricehunt_flutter/
├── android/          ← ✅ Proper Android folder (Codemagic ke liye)
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── kotlin/com/pricehunt/MainActivity.kt
│   │       └── res/
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradle.properties
├── lib/
│   ├── main.dart
│   ├── screens/screens.dart
│   ├── models/models.dart
│   ├── services/api_service.dart
│   ├── theme/app_theme.dart
│   └── widgets/common_widgets.dart
├── assets/
├── pubspec.yaml
└── codemagic.yaml
```
