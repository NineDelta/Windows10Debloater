# Check Administrator
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator"
    Start-Sleep 5
    Exit 0
}

# No errors throughout
$ErrorActionPreference = 'SilentlyContinue'

Import-Module ./Modules/Applications
Import-Module ./Modules/Cortana
Import-Module ./Modules/Edge
Import-Module ./Modules/Explorer
Import-Module ./Modules/OneDrive
Import-Module ./Modules/Privacy
Import-Module ./Modules/Registry
Import-Module ./Modules/ScheduledTasks
Import-Module ./Modules/Services
Import-Module ./Modules/Utils

Function Remove-Bloat {
    [CmdletBinding()]
    Param([Parameter(Mandatory=$false)][switch]$RemoveAll)

    ForEach ($i In 3)
    {
        Write-Output "Applying changes..."
        New-RegistryDrive;      Start-Sleep 1

        Remove-Apps $RemoveAll; Start-Sleep 1
        Remove-RegistryKeys;    Start-Sleep 1
        Disable-ScheduledTasks; Start-Sleep 1
        Disable-Services;       Start-Sleep 1
        Enable-Privacy;         Start-Sleep 1
        Disable-Cortana;        Start-Sleep 1
        Remove-ExplorerItems;   Start-Sleep 1
        Stop-EdgePDF;           Start-Sleep 1
        Uninstall-OneDrive;     Start-Sleep 1

        Remove-RegistryDrive;   Start-Sleep 1
        Write-Output "Changes applied."
    }
}

Function Restore-Bloat {   
    [CmdletBinding()]
    Param()
    
    ForEach ($i In 3)
    {
        Write-Output "Reverting changes..."
        New-RegistryDrive;      Start-Sleep 1

        Restore-Apps;           Start-Sleep 1
        Restore-RegistryKeys;   Start-Sleep 1
        Enable-ScheduledTasks;  Start-Sleep 1
        Enable-Services;        Start-Sleep 1
        Disable-Privacy;        Start-Sleep 1
        Enable-Cortana;         Start-Sleep 1
        Restore-ExplorerItems;  Start-Sleep 1

        Remove-RegistryDrive;   Start-Sleep 1
        Write-Output "Changes reverted."
    }
}

$DebloatFolder = "C:\Temp\Windows10Debloater"
New-TranscriptDirectory -TranscriptDirectoryPath "$DebloatFolder"
Start-Transcript -OutputDirectory "$DebloatFolder"
Remove-Bloat -RemoveAll
Stop-Transcript
