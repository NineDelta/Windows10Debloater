$Apps = @{
    SimpleRegistryKeys = @(
        # Background Tasks
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy',

        # Scheduled Tasks
        'HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe',

        # Windows File
        'HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0',

        # Windows Protocol
        'HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0',
        'HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy',

        # Windows Share
        'HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0',

        # Leftover registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        'HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y',
        'HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0',
        'HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy'
    )
    RegistryKeys = @(
        # Windows Bloatware Delivery Service
            # Disable Consumer Features
            [PSCustomObject]@{ KeyName = 'DisableWindowsConsumerFeatures'; Value = 1; DefaultValue = 0; Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' },
            # Disable bloatware delivery
            [PSCustomObject]@{ KeyName = 'ContentDeliveryAllowed'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' },
            # Disable preinstalled apps
            [PSCustomObject]@{ KeyName = 'OemPreInstalledAppsEnabled'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' },
            # Disable preinstalled apps
            [PSCustomObject]@{ KeyName = 'PreInstalledAppsEnabled'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' },
            # Disable preinstalled apps
            [PSCustomObject]@{ KeyName = 'PreInstalledAppsEverEnabled'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' },
            # Disable silent app installs
            [PSCustomObject]@{ KeyName = 'SilentInstalledAppsEnabled'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' },
            # Disable suggestions
            [PSCustomObject]@{ KeyName = 'SystemPaneSuggestionsEnabled'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' },

        # Windows Mixed Reality Portal
            # Disable Windows Mixed Reality Portal
            [PSCustomObject]@{ KeyName = 'FirstRunSucceeded'; Value = 0; DefaultValue = 1; Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic' }
    )
}

Function Remove-RegistryKeys {
    [CmdletBinding()]   
    Param()

    Write-Output "Removing bloatware registry keys..."
    $Apps.SimpleRegistryKeys | ForEach-Object { Remove-Item -Recurse }
    $Apps.RegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.Value
    }
    Write-Output "Bloatware registry keys removed."
}

Function Restore-RegistryKeys {
    [CmdletBinding()]   
    Param()

    Write-Output "Restoring bloatware registry keys..."
    $Apps.RegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.DefaultValue
    }
    Write-Output "Bloatware registry keys restored."
}
