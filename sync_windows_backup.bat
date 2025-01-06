@echo off
setlocal

:: Set variables
set LOCAL_DIR=C:\Users\loges\Desktop\docker\quickans
set S3_BUCKET=s3://window-serverbackup/versi
set REGION=us-east-1
set LOG_FILE=C:\Users\loges\Desktop\docker\quickans\docker_sync_log.txt

:: Check if LOCAL_DIR exists
if not exist "%LOCAL_DIR%" (
    echo LOCAL_DIR does not exist: %LOCAL_DIR%
    exit /b 1
)

:: Check if the LOG_FILE path exists
if not exist "%LOG_FILE%" (
    echo LOG_FILE path does not exist: %LOG_FILE%
)

:: Log the paths
echo LOCAL_DIR: %LOCAL_DIR%
echo S3_BUCKET: %S3_BUCKET%
echo LOG_FILE: %LOG_FILE%

:: Sync local directory to S3 bucket
echo Starting sync operation at %date% %time% >> "%LOG_FILE%"
aws s3 sync "%LOCAL_DIR%" "%S3_BUCKET%" --region %REGION% >> "%LOG_FILE%" 2>&1

:: Check for errors
if %ERRORLEVEL% NEQ 0 (
    echo Error occurred during sync operation. Check the log for details. >> "%LOG_FILE%"
    :: Do not delete the log file if there was an error
    echo Log file retained due to error.
) else (
    echo Sync operation completed successfully at %date% %time%. >> "%LOG_FILE%"
    :: Delete the log file if the sync operation was successful
    del "%LOG_FILE%"
)

endlocal
