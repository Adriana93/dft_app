@echo off
echo =====================================
echo Android Emulator + Flutter inditas
echo =====================================

echo.
echo 1. Emulator inditasa...
flutter emulators --launch Pixel_6

echo.
echo 2. Varakozas az emulator bootolasara...
adb wait-for-device

:wait_boot
for /f "tokens=*" %%i in ('adb shell getprop sys.boot_completed') do set boot=%%i
if not "%boot%"=="1" (
    timeout /t 2 >nul
    goto wait_boot
)

echo.
echo Emulator kesz!

echo.
echo 3. Csomagok telepitese...
flutter pub get

echo.
echo 4. App inditasa...
flutter run

pause