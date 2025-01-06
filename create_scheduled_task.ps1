# Define paths and log file
$batchFilePath = "C:\Users\loges\Desktop\docker\sync_windows_backup.bat"
$logFilePath = "C:\Users\loges\Desktop\docker\sync_task_logr.txt"

# Define the name and folder for the scheduled task
$taskName = "S3 Bucket Sync Task"
$taskFolder = "AWSFileBackup"  # Task folder in Task Scheduler

# Ensure the log file exists
if (-Not (Test-Path -Path $logFilePath)) {
    New-Item -Path $logFilePath -ItemType File -Force
}
Set-Content -Path $logFilePath -Value ""  # Clear existing log content

# Create the action to execute the batch file and append logs
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$batchFilePath >> `"$logFilePath`" 2>&1`"" 

# Create the trigger to run every Monday at 12:29 PM
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At "12:41"

# Register the scheduled task (Run with highest privileges)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -TaskPath "\$taskFolder\" -RunLevel Highest -Description "Runs the S3 sync batch file every Monday." -Force

# Output confirmation to the console
Write-Host "Scheduled task '$taskName' created successfully in folder '$taskFolder'."
Write-Host "Log file will be updated at '$logFilePath'."
