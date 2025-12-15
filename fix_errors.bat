@echo off
echo Starting repair process...
echo This may take a few minutes. Please wait.

echo.
echo 1. Cleaning project...
call flutter clean

echo.
echo 2. Getting dependencies...
call flutter pub get

echo.
echo 3. Generating missing files (Freezed & JSON)...
call flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo -----------------------------------------------
echo SUCCESS! All files generated.
echo You can now run the app in Android Studio.
echo -----------------------------------------------
pause
