
@echo off
setlocal

:: Set variables
set LOCAL_DIR=C:\Users\loges\Desktop\docker\quickans
set S3_BUCKET=s3://window-serverbackup/backup_v1
set REGION=us-east-1
set LOG_FILE=C:\Users\loges\Desktop\docker\quickans\docker_sync_log.txt

:: Ensure the log file exists
if not exist "%LOG_FILE%" (
    echo [%date% %time%] Creating log file at %LOG_FILE%.
    echo. > "%LOG_FILE%"
)

:: Log start of the sync operation
echo [%date% %time%] Starting sync operation. >> "%LOG_FILE%"

:: Run the sync command with detailed output
aws s3 sync "%LOCAL_DIR%" "%S3_BUCKET%" --region %REGION% >> "%LOG_FILE%" 2>&1

:: Check for errors
if %ERRORLEVEL% NEQ 0 (
    echo [%date% %time%] Error occurred during sync operation. >> "%LOG_FILE%"
    echo [%date% %time%] Check the above log for detailed error messages. >> "%LOG_FILE%"
    exit /b 1
) else (
    echo [%date% %time%] Sync operation completed successfully. >> "%LOG_FILE%"
    echo [%date% %time%] Synced files: >> "%LOG_FILE%"
    aws s3 ls "%S3_BUCKET%" --region %REGION% >> "%LOG_FILE%" 2>&1
)
