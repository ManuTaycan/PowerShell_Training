<#
.SYNOPSIS
    This script gets CPU stats and write a log

.NOTE
    Author:     ManuTaycan
    Date:       2026.05.25
    Scope:      Exercise
    Mentor:     Gemeni
    TimeSpent:  5 h

.STEPS
    1. Get CPU stats
    2. Write them into a log.txt
        2.1 Round stats
        2.2 Format: [25.05.2026 14:22:05] - 
    3. Warn if surthen stats go above surthen limits

.LINKS
    https://stackoverflow.com/questions/6298941/how-do-i-find-the-cpu-and-ram-usage-using-powershell
    https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-processor

    https://stackoverflow.com/a/39738567
    https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-round-to-specific-decimal-place/
    https://stackoverflow.com/a/6298963
    https://woshub.com/write-output-log-files-powershell/

.NOTE
    >> and .NET don't go togheter very well (Encoding)
#>


# --- Step 0. The script requires elevated priviledges
function Test-Administrator  
{  
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}
if(-not (Test-Administrator))
{ 
    Write-Error "This script must be executed as Administrator.";
    exit 1;
}
$ErrorActionPreference = "Stop";


# --- Step 1. -Get CPU stats
function Get-CPUStats {
    function Get-Temperature {
        $t = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
        $temp = @()

        foreach ($temp in $t.CurrentTemperature)
        {
        $tempCelsius = $temp / 100
        [System.Math]::Round($tempCelsius)
        }
        return [System.Math]::Round($tempCelsius)   
    }

    $test = Get-Temperature
    $rawAverage = $test | Measure-Object -Average | Select-Object -ExpandProperty Average
    $finalAverageTemp = [System.Math]::Round($rawAverage)
    $finalAverageTemp
    Get-WmiObject Win32_Processor | Select-Object -ExpandProperty LoadPercentage
}


# --- Step 2. Logs
$logPath = "C:\Users\Sergiu Manu\OneDrive\Dokumente\PowerShell_Training\Exercises\Logs"
$logFile = "$logPath\CPU_Stats_log.txt"
if(-not ($logPath)){
    mkdir -Path $logPath -Force
}


if (Test-Path $logFile) {
    $fileSize = (Get-Item $logFile).Length
    
    if ($fileSize -gt 1KB) {
        $allLines = [System.IO.File]::ReadAllLines($logFile, [System.Text.Encoding]::UTF8)
        $remainingLines = [System.Linq.Enumerable]::Skip($allLines, 2)
        [System.IO.File]::WriteAllLines($logFile, $remainingLines, [System.Text.Encoding]::UTF8)
    }
}


$stats = Get-CPUStats
$date = Get-Date -Format dd.MM.yyyy
$time = Get-Date -Format HH:mm:ss
foreach($stat in $stats){
    "[$date $time] - $stat" | Out-File -FilePath $logFile -Encoding utf8 -Append
}

# --- Step 3. Warnings
if ($stats[0] -gt 65){
    Write-Host "CPU temperature exids normal outputs!"
}
if ($stats[1] -gt 100){
    Write-Host "CPU temperature exids normal outputs!"
}