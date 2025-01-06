
# Define paths and log file
$batchFilePath = "C:\Users\loges\Desktop\docker\sync_windows_backup.bat"
$logFilePath = "C:\Users\loges\Desktop\docker\sync_task_logr.txt"

# Define the name and folder for the scheduled task
$taskName = "S3 bucket sync Task"
$taskFolder = "AWS_file_backup"  # Task folder in Task Scheduler

# Ensure the log file exists and clear any previous content
if (-Not (Test-Path -Path $logFilePath)) {
    New-Item -Path $logFilePath -ItemType File -Force
}
Set-Content -Path $logFilePath -Value ""  # Clear existing log content

# Create the Action for the task, appending logs to the log file
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$batchFilePath >> `"$logFilePath`" 2>&1`""

# Create the Trigger to run every Sunday at 00:10
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "00:53"

# Register the scheduled task (Run with highest privileges)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -TaskPath "\$taskFolder\" -RunLevel Highest -Description "Runs the S3 sync batch file every Sunday at 00:45" -Force

# Output confirmation to the log
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
Add-Content -Path $logFilePath -Value "$timestamp - Scheduled task '$taskName' created successfully at folder '$taskFolder'."
Add-Content -Path $logFilePath -Value "$timestamp - Full task path: \MyTasks\$taskName"

# Console output
Write-Host "Scheduled task '$taskName' created successfully at folder '$taskFolder'."
Write-Host "Full task path: \MyTasks\$taskName"