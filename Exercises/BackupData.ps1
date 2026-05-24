<#
.SYNOPSIS
    This script should backup data from /Exercises/Logs/ into /Test/Logs/ and
    generate a log/csv file.

.NOTE
    Author:     ManuTaycan
    Date:       2026.05.24
    Scope:      Exercises
    Mentor:     Gemeni
    TimeSpent:  3,5 Hours

.STEPS
    1. Does the script run with elevated priviledges?
        1.1 Yes? -> Run
        1.2 No?  -> Stop
    2. Define parameters
        2.1 Run
        2.2 Help
        2.3 CopyToPath
        2.4 CostumRun
    3. Define folder to backup
    4. Define folder to backup into
        4.1 Create folder if not existent
    5. Backup
        5.1 Backed up date must be added the backup date to the end : _yyyy-MM-dd
    6. Create .csv report
        6.1 With [PsCustomObject] create
            -DataName
            -Status
            -TimeStamp
        6.2 Try-Catch for errors
    7. Functions for the rest of the parameters
    8. Logic


.LINKS
    https://serverfault.com/questions/95431/in-a-powershell-script-how-can-i-check-if-im-running-with-administrator-privil
    https://stackoverflow.com/questions/22182409/replace-part-of-file-name-powershell
    https://codemia.io/knowledge-hub/path/powershell_-_extract_file_name_and_extension
    https://learn.microsoft.com/de-de/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7.5

.KNOWN-ISSUES
    -The script seems to copy teh first item twice
    -The log CSV displays only one item. Probably an override issue.
    -I don't know how to create the status object.
#>


# --- Step 1.
<#
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
#>


# --- Step 2.
param (
    [switch]$Run,
    [switch]$Help,
    $CopyToPath
)


# --- Step 3.
$backUpFromPath = "C:\Users\Sergiu Manu\OneDrive\Dokumente\PowerShell_Training\Exercises\Logs\"
$backUpPath = "C:\Users\Sergiu Manu\OneDrive\Dokumente\PowerShell_Training\Test\Logs_BackUp\"


# --- Step 4. For the $Run
function Create-BackUpPath{
    if(-not (Test-Path $backUpPath)){
        mkdir -Path $backUpPath -Force
    }
}
# --- Step 4. For the $CopyToPath
function Create-DestinationPath{
    if(-not (Test-Path $CopytoPath)){
        try {
            mkdir -Path $CopyToPath -Force
        }
        catch {
            Write-Host "[ERROR]: $_"
        }
    }
}



# --- Step 5. and 6. For $Run
function Copy-StandardPathItems{
    $items = Get-ChildItem -Path "$backUpFromPath\"
    foreach($item in $items){
        try {
            Copy-Item -Path "$backUpFromPath\*" -Destination $backUpPath
            $date = Get-Date -Format _yyyy-MM-dd
            $newName = $item.BaseName + $date + $item.Extension
            $path = Join-Path $backUpPath $item.Name
            Rename-Item -Path $path -NewName $newName

            $name03 = Get-ChildItem -Path "$backUpPath\$newName"
            $forCSV = [PSCustomObject]@{
                DataName = $name03.Name
                Status = ""
                TimeStamp = [datetime]::Now
            }
            Export-Csv -InputObject $forCSV -Path "$backUpPath\Backup_Log.csv" -Delimiter ";" -Encoding UTF8
        }
        catch {
            Write-Host "[ERROR]: $_"
        }
    }
}
# --- Step 5. and 6. For $CopyToPath
function Copy-CustomPathItems{
    $items = Get-ChildItem -Path "$backUpFromPath\"
    foreach($item in $items){
        try {
            Copy-Item -Path "$backUpFromPath\*" -Destination $CopyToPath -Recurse
            $date = Get-Date -Format _yyyy-MM-dd
            $newName = $item.BaseName + $date + $item.Extension
            $path = Join-Path $CopyToPath $item.Name
            Rename-Item -Path $path -NewName $newName

            $name02 = Get-ChildItem -Path "$CopyToPath\$newName"
            $forCSV = [PSCustomObject]@{
                DataName = $name02.Name
                Status = ""
                TimeStamp = [datetime]::Now
            }
            Export-Csv -InputObject $forCSV -Path "$CopyToPath\Backup_Log.csv" -Delimiter ";" -Encoding UTF8
        }
        catch {
            Write-Host "[ERROR]: $_"
        }
    }
}



# --- Step 7.
function Help{
    Write-Host @"
    .SYNOPSIS
        This script should backup data from /Exercises/Logs/ into /Test/Logs/ and
        generate a log/csv file.

    .NOTE
        Author:     ManuTaycan
        Date:       2026.05.24
        Scope:      Exercises
        Mentor:     Gemeni

    .EXAMPLES
        .\BackupData.ps1 -Run
            - It runs the Backup in the standard directories

        .\BackupData.ps1 -Help
            - Displays this massage

        .\BackupData.ps1 -CopyToPath "Your path"
            - Runs the script useing your new path
    .LINKS
        https://serverfault.com/questions/95431/in-a-powershell-script-how-can-i-check-if-im-running-with-administrator-privil
        https://stackoverflow.com/questions/22182409/replace-part-of-file-name-powershell
        https://codemia.io/knowledge-hub/path/powershell_-_extract_file_name_and_extension
        https://learn.microsoft.com/de-de/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7.5
"@

}



# --- Step 8.
if ($Run){
    Create-BackUpPath
    Copy-StandardPathItems
}

if ($CopyToPath){
    Create-DestinationPath
    Copy-CustomPathItems
}

if ($Help){
    Help
}