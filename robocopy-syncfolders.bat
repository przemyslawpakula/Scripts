@echo off
REM Force UTF-8 coding
chcp 65001 >nul

REM Create catalog if not exists
if not exist "G:\Scripts\log" mkdir "G:\Scripts\log"

REM R:3 Retries, W:5 Wait 5 sec between retries, MT:16 Use 16 Processor threads for faster copy
robocopy "G:\Zdjęcia" "F:\Zdjęcia" /MIR /R:3 /W:5 /MT:16 /LOG:"G:\Scripts\log\robocopy_zdjecia.log"
robocopy "G:\backup - omvacer system" "F:\backup - omvacer system" /MIR /R:3 /W:5 /MT:16 /LOG:"G:\Scripts\log\robocopy_backup_omvacer_system.log"
robocopy "G:\Immich" "F:\Immich" /MIR /R:3 /W:5 /MT:16 /LOG:"G:\Scripts\log\robocopy_immich.log"
robocopy "G:\Scripts" "F:\Scripts" /MIR /R:3 /W:5 /MT:16 /LOG:"G:\Scripts\log\robocopy_scripts.log"

echo.
echo ======== Synchronization complete ========
pause
