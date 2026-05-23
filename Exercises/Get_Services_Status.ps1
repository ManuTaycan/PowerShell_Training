<#
.SYNOPSIS
    This script should contain a couple of services in an array and ask the status of each one
    and state if the service is running or not.

.NOTE
    I wrote this script in order to exercise my PowerShell skils
    Author: ManuTaycan

.STEPS
    1. Create Array
    2. Get Service Status
    3. Display Infos
#>


# --- Step 1.
$services = @(
    "Spooler",
    "WinRM"
)

# --- Step 2. #Gemeni: The problem is that i give the allready filtered result to the try-catch
$getServices = Get-Service -Name $services

# --- Step 3.
foreach ($service in $getServices){
    try {
        $getServices
        if ($service.Status -eq "Running") {
            Write-Host "The Service: $($service.Name) is curently running." -ForegroundColor Green
        }
        else {
            Write-Host "The Service: $($service.Name) is isn't running!!!" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[ERROR]: $($service.Name) has a problem: $_"
    }
}
