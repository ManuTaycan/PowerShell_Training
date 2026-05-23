<#
.SYNOPSIS
    This script should get the local accounts wich are enabled and export those inso a .csv
    The following data needs to be in the .csv:
        Username
        Password last changed
        Last Login

.NOTE
    Author:     ManuTaycan
    Date:       2026.05.23
    Scope:      Exercises
    Mentor:     Gemeni

.STEPS
    1. Get enabled local users
    2. Create PSCustomObject wiht the requested data
    3. Save the .csv into the logs Folder
        3.1. Check if the Logs folder exists and inf not create it
#>


# --- declarations
$logPath = "$env:USERPROFILE\OneDrive\Dokumente\PowerShell_Training\Exercises\Logs"

# --- Step 1.
$users = Get-LocalUser -Name * | Where-Object -Property Enabled -EQ "True" | Select-Object -Property Name, PasswordLastSet, LastLogon

# --- Step 3.1
if (-not (Test-Path -Path $logPath)) {
    mkdir -Path $logPath
}

# --- Step 3.
Export-Csv -Path "$logPath\Local_Enabled_Users.csv" -InputObject $users


# --- Gemenis way
<#
# --- declarations
$logPath = "$env:USERPROFILE\OneDrive\Dokumente\PowerShell_Training\Exercises\Logs"

# --- Step 1. (Hier holen wir uns die rohen User-Objekte)
$users = Get-LocalUser | Where-Object -Property Enabled -EQ $true

# --- Step 3.1 (Dein Ordner-Check: absolut perfekt!)
if (-not (Test-Path -Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}

# --- Step 2 & 3. (Wir jagen die User durch ein Custom Object direkt in die CSV)
$users | ForEach-Object {
    [PSCustomObject]@{
        Username            = $_.Name
        PasswordLastChanged = $_.PasswordLastSet
        LastLogin           = $_.LastLogon
    }
} | Export-Csv -Path "$logPath\Local_Enabled_Users.csv" -NoTypeInformation -Encoding UTF8
#>