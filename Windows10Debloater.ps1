#This function finds any AppX/AppXProvisioned package and uninstalls it, except for Freshpaint, Windows Calculator, Windows Store, and Windows Photos.
#Also, to note - This does NOT remove essential system services/software/etc such as .NET framework installations, Cortana, Edge, etc.

#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "&" + $MyInvocation.MyCommand.Definition + "" 
    Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator." -ForegroundColor "White"
    Start-Sleep 1
    Start-Process "powershell.exe" -Verb RunAs -ArgumentList $arguments
    Break
}

#no errors throughout
$ErrorActionPreference = 'SilentlyContinue'

function Apply-Changes {
    [CmdletBinding()]
    Param([Parameter(Mandatory=$false)][switch]$RemoveAll)

    Write-Output "Applying changes..."
    New-RegistryDrive; Start-Sleep 1
    Remove-Apps $RemoveAll; Start-Sleep 1
    Remove-Keys; Start-Sleep 1
    Restore-Apps; Start-Sleep 1
    Enable-Privacy; Start-Sleep 1
    Disable-Cortana; Start-Sleep 1
    Disable-Services; Start-Sleep 1

    $CloudStore = "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\CloudStore"
    If (Test-Path $CloudStore) {
        Stop-Process Explorer.exe -Force
        Remove-Item $CloudStore
        Start-Process Explorer.exe -Wait
    }
}

Function Revert-Changes {   
    [CmdletBinding()]
    Param()
    
    Write-Output "Reverting changes..."
    New-RegistryDrive; Start-Sleep 1
    Restore-Apps; Start-Sleep 1
    Restore-Keys; Start-Sleep 1
    Enable-Tasks; Start-Sleep 1
    Disable-Privacy; Start-Sleep 1
    Enable-Cortana; Start-Sleep 1
    Enable-Services; Start-Sleep 1
}

$DebloatFolder = "C:\Temp\Windows10Debloater"
New-TranscriptDirectory -TranscriptDirectoryPath "$DebloatFolder"
Start-Transcript -OutputDirectory "$DebloatFolder"

Add-Type -AssemblyName PresentationCore, PresentationFramework

#GUI prompt Debloat/Revert options and GUI variables
$Button = [Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [Windows.MessageBoxImage]::Error
$Warn = [Windows.MessageBoxImage]::Warning
$Ask = 'The following will allow you to either Debloat Windows 10 or to revert changes made after Debloating Windows 10.

        Select "Yes" to Debloat Windows 10

        Select "No" to Revert changes made by this script
        
        Select "Cancel" to stop the script.'

$EverythingorSpecific = "Would you like to remove everything that was preinstalled on your Windows Machine? Select Yes to remove everything, or select No to remove apps via a blacklist."
$EdgePdf = "Do you want to stop edge from taking over as the default PDF viewer?"
$EdgePdf2 = "Do you want to revert changes that disabled Edge as the default PDF viewer?"
$Reboot = "For some of the changes to properly take effect it is recommended to reboot your machine. Would you like to restart?"
$OneDriveDelete = "Do you want to uninstall One Drive?"

$Prompt1 = [Windows.MessageBox]::Show($Ask, "Debloat or Revert", $Button, $ErrorIco) 
Switch ($Prompt1) {
    #This will debloat Windows 10
    Yes {
        $Prompt2 = [Windows.MessageBox]::Show($EverythingorSpecific, "Everything or Specific", $Button, $Warn)
        switch ($Prompt2) {
            Yes { Apply-Changes -RemoveAll }
            No  { Apply-Changes }
        }
        $Prompt3 = [Windows.MessageBox]::Show($EdgePdf, "Edge PDF", $Button, $Warn)
        Switch ($Prompt3) {
            Yes { Stop-EdgePDF; Write-Output "Edge will no longer take over as the default PDF viewer." }
            No  { Write-Output "You chose not to stop Edge from taking over as the default PDF viewer." }
        }
        $Prompt4 = [Windows.MessageBox]::Show($OneDriveDelete, "Delete OneDrive", $Button, $ErrorIco) 
        Switch ($Prompt4) {
            Yes { Uninstall-OneDrive; Write-Output "OneDrive is now removed from the computer." }
            No  { Write-Output "You have chosen to skip removing OneDrive from your machine." }
        }
        $Prompt5 = [Windows.MessageBox]::Show($Reboot, "Reboot", $Button, $Warn) 
        Switch ($Prompt5) {
            Yes { Remove-RegistryDrive; Stop-Transcript; Restart-Computer }
            No  { Remove-RegistryDrive; Stop-Transcript; Exit }
        }
    }
    No {
        Revert-Changes
        $Prompt6 = [Windows.MessageBox]::Show($EdgePdf2, "Revert Edge", $Button, $ErrorIco)
        Switch ($Prompt6) {
            Yes { Enable-EdgePDF; Write-Output "Edge will no longer be disabled from being used as the default Edge PDF viewer." }
            No  { Write-Output "You have chosen to keep the setting that disallows Edge to be the default PDF viewer." }
        }
        $Prompt7 = [Windows.MessageBox]::Show($Reboot, "Reboot", $Button, $Warn)
        Switch ($Prompt7) {
            Yes { Remove-RegistryDrive; Stop-Transcript; Restart-Computer }
            No  { Remove-RegistryDrive; Stop-Transcript; Exit }
        }
    }
}
