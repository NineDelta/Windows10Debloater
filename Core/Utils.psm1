Function Assert-RunningAsAdmin {   
    [CmdletBinding()]
    Param()

    #This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        $arguments = "&" + $MyInvocation.MyCommand.Definition + "" 
        Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator." -ForegroundColor "White"
        Start-Sleep 1
        Start-Process "powershell.exe" -Verb RunAs -ArgumentList $arguments
        Break
    }
}

Function New-RegistryDrive {   
    [CmdletBinding()]
    Param()

    Write-Output "Creating PSDrive 'HKCR' (HKEY_CLASSES_ROOT)."
    Write-Output "This will be used for the duration of the script as it is necessary for the modification of specific registry keys."
    New-PSDrive HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
}

Function Remove-RegistryDrive {   
    [CmdletBinding()]
    Param()

    Write-Output "Remvoving the HKCR drive..."
    Remove-PSDrive HKCR
}

Function New-TranscriptDirectory {   
    [CmdletBinding()]
    Param([Parameter(Mandatory=$true)][string]$TranscriptDirectoryPath)

    If (Test-Path $TranscriptDirectoryPath) {
        Write-Output "$TranscriptDirectoryPath exists. Skipping."
    } Else {
        Write-Output "The folder "$TranscriptDirectoryPath" doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
        New-Item -Path "$TranscriptDirectoryPath" -ItemType Directory
        Write-Output "The folder $TranscriptDirectoryPath was successfully created."
    }
}

