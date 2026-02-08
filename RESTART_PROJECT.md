# 🚀 Finder App - Restart Guide

Follow these steps whenever you restart your computer or want to open the project again.

## 1. Start the Backend (Terminal 1)
Open a terminal and run these commands to start the Django server:

```powershell
cd C:\Users\nithi\.gemini\antigravity\scratch\finder-app\backend
.\venv\Scripts\activate
python manage.py runserver 0.0.0.0:8000
```

## 2. Start the Mobile App (Terminal 2)
Open a **new** terminal and run these commands to launch the app on your emulator:

```powershell
cd C:\Users\nithi\.gemini\antigravity\scratch\finder-app\mobile\finder_app
$env:Path += ";C:\src\flutter\bin"
flutter run
```

---

### 💡 Tips
* **Code is already saved**: Your progress and code changes are saved automatically on your hard drive. You don't need to "save" the running terminals.
* **Database**: Your MySQL database is persistent and will be ready as soon as you start the backend.
* **Hot Reload**: While the app is running, just press `r` in the Mobile Terminal to see your code changes instantly!

## 🛠️ Troubleshooting

### "Error waiting for a debug connection"
If you see this error when running `flutter run`, try these steps:
1. **Clean and Run**:
   ```powershell
   flutter clean; flutter run
   ```
2. **Cold Boot Emulator**: Close the emulator window, go to Android Studio Device Manager, click the "three dots" next to your emulator, and select **"Cold Boot Now"**.
3. **Restart the Terminal**: Close the terminal window entirely and open a new one.
