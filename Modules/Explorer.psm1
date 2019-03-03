$ExplorerKeys = @{
    SimpleRegistryKeys = @(
        # Context Menu
            # Edit with Paint3D
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit'
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\3D Edit'
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpe\Shell\3D Edit'
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit'
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit'
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\3D Edit'
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\3D Edit'
            'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\3D Edit'
            # Share
            'HKLM:\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\ModernSharing'
    )
    RegistryKeys = @(
        # Task Bar
            # Disable People Icon
            [PSCustomObject]@{ KeyName = 'PeopleBand'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' }
    
        # Start Menu
            # Disable Windows Live Tiles
            [PSCustomObject]@{ KeyName = 'NoTileApplicationNotification'; Value = 1; DefaultValue = 0; Path = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' }
    
        # Context Menu
            # Cast to Device
            [PSCustomObject]@{ KeyName = 'Blocked'; Value = '{7AD84985-87B4-4a16-BE58-8B72A5B390F7}' ; DefaultValue = ''; Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions' }
    )
} 

Function Remove-ExplorerItems {
    [CmdletBinding()]
    Param()

    $ExplorerKeys.SimpleRegistryKeys | ForEach-Object { Remove-Item -Recurse }
    $ExplorerKeys.RegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.Value
    }

    $CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
    If (Test-Path $CloudStore) {
        Stop-Process Explorer.exe -Force
        Remove-Item $CloudStore
        Start-Process Explorer.exe -Wait
    }

    Remove-StartMenuPins
}

Function Restore-ExplorerItems {
    [CmdletBinding()]
    Param()

    $ExplorerKeys.RegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.DefaultValue
    }
}

Function Remove-StartMenuPins {
    Write-Output "Unpinning all Tiles from the Start Menu..."
    (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | `
        ForEach-Object { $_.Verbs() } | `
        Where-Object { $_.Name -match 'Un.*pin from Start' } | `
        ForEach-Object { $_.DoIt() }
    Write-Output "Tiles unpinned."
}
