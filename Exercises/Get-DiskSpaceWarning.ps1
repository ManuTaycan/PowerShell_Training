<#
.SYNOPSIS
    This script should use functions to get the disk space of all disks
    and if a disk has 15% or less free space it should generate a warning.
    Otherwise it should give a good check or something

.NOTE
    Author:     ManuTaycan
    Date:       2026.05.23
    Scope:      Exercises
    Mentor:     Gemeni

.STEPS
    1. Experiment with the disk features in Powershell
    2. Create parameters (optional)
    3. Create the function
        3.1 Get the space and the free space
        3.2 Calculate the percentage
        3.3 Whrite the warnings

.SYNTAXES
    HealthStatus          : Healthy (Get-Disk)
    Get-Disk -FriendlyName * | Select-Object * | Format-List
    Get-PSDrive -Name * | Select-Object * | Format-List
    ProzentFrei = (FreierSpeicher / GesamtSpeicher) * 100
#>


# --- Step 2.
param(
    [switch]$Run,
    [switch]$Help
)
# --- Step 3.
function Check-DiskSpace{
    $drives = Get-PSDrive -Name * | Where-Object Used -NE $null | Select-Object Name, Free, Used
    foreach($drive in $drives){
        try {
            $driveSizes = $drive.Free + $drive.Used            
        }
        catch {
            Write-Host "[ERROR]: $_" -ForegroundColor Red
        }
        foreach($driveSize in $driveSizes){
                try {
                    $drivePercentage = ($drive.Free / $driveSize) * 100
                    $drivePercentage
                }
                catch {
                    Write-Host "[ERROR]: $_" -ForegroundColor Red
                }
            }
            if (($drivePercentage) -gt 15) {
                foreach($drive in $drives){
                    try {
                        Write-Host "The drive $($drive.Name) has enough free space :)" -ForegroundColor Green
                    }
                    catch {
                        Write-Host "[ERROR]: $_" -ForegroundColor Red
                    }
                }
            }else {
                Write-Host "[WARNING]: The disk has less then 15% free space!" -ForegroundColor Red
            }
    }
}

# --- Optional Step
function Get-DiskCheck{
    $diskHealth = Get-Disk -FriendlyName * | Select-Object HealthStatus
    if (($diskHealth) -like "Healthy") {
        Write-Host "[CRITICAL ISSUE]: Disk stet is unhealthy!" -ForegroundColor DarkYellow
        Write-Host "[INFO]: $_" -ForegroundColor DarkYellow
        Exit 1
    }
}

# --- Help parameter
function Help{
    Write-Host ".SYNOPSIS"
    Write-Host "    This script should use functions to get the disk space of all disks"
    Write-Host "    and if a disk has 15% or less free space it should generate a warning."
    Write-Host "    Otherwise it should give a good check or something"
    Write-Host ""
    Write-Host ".PARAMETERS"
    Write-Host "    -Help"
    Write-Host "    -Run"
    Write-Host ""
    Write-Host ".EXAMPLES"
    Write-Host "    Get-DiskSpaceWarning.ps1 -Help"
    Write-Host "        -Displays this message"
    Write-Host ""
    Write-Host "    Get-DiskSpaceWarning.ps1 -Run"
    Write-Host "        -Runs the healt check"
}

# --- Logic of the script
if($run){
    Get-DiskCheck
    Check-DiskSpace
}

If($Help){
    Help
}