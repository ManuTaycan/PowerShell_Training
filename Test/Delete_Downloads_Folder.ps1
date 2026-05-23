<#
.SYNOPSIS
    This script deletes the Downloads folders content for the current user but not the folder itself.

.NOTE
    Make sure to run this script with appropriate permissions, as it will delete files from the Downloads folder.
    USERPROFILE=C:\Users\Sergiu Manu
    "C:\Users\Sergiu Manu\Downloads"

.STEPS
    1. define path
    2. Get-Items inside path
    3. See wich items are older than 30 days
    4. Delete those items with results

#>

# --- 1.
$path = "$env:USERPROFILE\Downloads\"
$limitDate = (Get-Date).AddDays(-30) #Gemeni

# --- 2. and 3
$itemsToDelete = Get-ChildItem -Path $path | Where-Object { $_.LastWriteTime -lt $limitDate } #Gemeni from |

# --- 4. #Gemeni added $item and $($item.Name) and the Try-Catch
foreach ($item in $itemsToDelete) {
    try {
        Remove-Item -Path $item.FullName -Recurse -WhatIf
        Write-Host "Datei $($item.Name) wurde erfolgreich gelöscht." -ForegroundColor Green
    } 
    catch {
        # Falls eine Datei gesperrt ist oder blockiert wird
        Write-Host "Datei $($item.Name) konnte nicht gelöscht werden! Fehler: $_" -ForegroundColor Red
    }
}