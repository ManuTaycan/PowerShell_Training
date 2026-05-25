<#
.SYNOPSIS
    This script gets CPU stats and write a log

.NOTE
    Author:     ManuTaycan
    Date:       2026.05.25
    Scope:      Exercise
    Mentor:     Gemeni
    TimeSpent:  (from 12:00)

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


.INFOS
    
#>



# --- Step 1. -Get CPU stats
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
$avg = $test
$avg | Measure-Object -Average | Select-Object Average | Format-Table
Get-WmiObject Win32_Processor | Select-Object LoadPercentage | Format-Table
