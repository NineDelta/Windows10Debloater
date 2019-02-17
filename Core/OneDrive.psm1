Function Uninstall-OneDrive {
    [CmdletBinding()]
    Param()

    Write-Output "Checking for pre-existing files and folders located in the OneDrive folders..."
    Start-Sleep 1
    If (Get-Item -Path "$env:USERPROFILE\OneDrive\*") {
        Write-Output "Files found within the OneDrive folder! Checking to see if a folder named OneDriveBackupFiles exists."
        Start-Sleep 1
              
        If (Get-Item "$env:USERPROFILE\Desktop\OneDriveBackupFiles" -ErrorAction SilentlyContinue) {
            Write-Output "A folder named OneDriveBackupFiles already exists on your desktop. All files from your OneDrive location will be moved to that folder." 
        }
        Else {
            If (!(Get-Item "$env:USERPROFILE\Desktop\OneDriveBackupFiles" -ErrorAction SilentlyContinue)) {
                Write-Output "A folder named OneDriveBackupFiles will be created and will be located on your desktop. All files from your OneDrive location will be located in that folder."
                New-item -Path "$env:USERPROFILE\Desktop" -Name "OneDriveBackupFiles"-ItemType Directory -Force
                Write-Output "Successfully created the folder 'OneDriveBackupFiles' on your desktop."
            }
        }
        Start-Sleep 1
        Move-Item -Path "$env:USERPROFILE\OneDrive\*" -Destination "$env:USERPROFILE\Desktop\OneDriveBackupFiles" -Force
        Write-Output "Successfully moved all files/folders from your OneDrive folder to the folder 'OneDriveBackupFiles' on your desktop."
        Start-Sleep 1
        Write-Output "Proceeding with the removal of OneDrive."
        Start-Sleep 1
    }
    Else {
        If (!(Get-Item -Path "$env:USERPROFILE\OneDrive\*")) {
            Write-Output "Either the OneDrive folder does not exist or there are no files to be found in the folder. Proceeding with removal of OneDrive."
            Start-Sleep 1
        }
    }

    Write-Output "Uninstalling OneDrive"
    New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
    $ExplorerReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    $ExplorerReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    Stop-Process -Name "OneDrive*"
    Start-Sleep 2
    If (!(Test-Path $onedrive)) { $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe" }
    Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
    Start-Sleep 2

    Write-Output "Stopping explorer"
    Start-Sleep 1
    .\taskkill.exe /F /IM explorer.exe
    Start-Sleep 3

    Write-Output "Removing leftover files"
    Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
    Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
    Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
    If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") { Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse }

    Write-Output "Removing OneDrive from windows explorer"
    If (!(Test-Path $ExplorerReg1)) { New-Item $ExplorerReg1 }
    Set-ItemProperty $ExplorerReg1 System.IsPinnedToNameSpaceTree -Value 0 
    If (!(Test-Path $ExplorerReg2)) { New-Item $ExplorerReg2 }
    Set-ItemProperty $ExplorerReg2 System.IsPinnedToNameSpaceTree -Value 0

    Write-Output "Restarting Explorer that was shut down before."
    Start-Process explorer.exe -NoNewWindow
    
    Write-Output "Enabling the Group Policy 'Prevent the usage of OneDrive for File Storage'."
    $OneDriveKey = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
    If (!(Test-Path $OneDriveKey)) { Mkdir $OneDriveKey }

    $DisableAllOneDrive = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
    If (Test-Path $DisableAllOneDrive) { New-ItemProperty $DisableAllOneDrive -Name OneDrive -Value DisableFileSyncNGSC -Verbose }
}
