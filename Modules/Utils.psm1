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
