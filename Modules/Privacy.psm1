$PrivacyKeys = @(
    # Windows Experience Feedback
        # Disable Advertising ID
        [PSCustomObject]@{ KeyName = 'Enabled'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' }
        # Disable Windows Feedback Experience
        [PSCustomObject]@{ KeyName = 'PeriodInNanoSeconds'; Value = 0; DefaultValue = 1; Path = 'HKCU:\Software\Microsoft\Siuf\Rules' }

    # Windows Search
        # Disable web results in Windows Search
        [PSCustomObject]@{ KeyName = 'DisableWebSearch'; Value = 1; DefaultValue = 0; Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' }
        # Disable Bing in Windows Search
        [PSCustomObject]@{ KeyName = 'BingSearchEnabled'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' }

    # Windows Data Collection
        # Disable Data Collection
        [PSCustomObject]@{ KeyName = 'AllowTelemetry'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' }
        [PSCustomObject]@{ KeyName = 'AllowTelemetry'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' }
        [PSCustomObject]@{ KeyName = 'AllowTelemetry'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection' }

    # Windows Wifi Sense
        # Disable Wifi Sense
        [PSCustomObject]@{ KeyName = 'Value'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting' }
        [PSCustomObject]@{ KeyName = 'Value'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots' }
        [PSCustomObject]@{ KeyName = 'AutoConnectAllowedOEM'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config' }

    # Windows Location Tracking
        # Disabling Location Tracking
        [PSCustomObject]@{ KeyName = 'SensorPermissionState'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}' }
        [PSCustomObject]@{ KeyName = 'Status'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration' }
)

Function Enable-Privacy {
    [CmdletBinding()]
    Param()

    Write-Output "Enabling privacy options..."
    $PrivacyKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Write-Output "Key:   ${_.KeyName}   Path:   ${_.Path}";
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.Value
    }
    Write-Output "Privacy enabled."
}

Function Disable-Privacy {
    [CmdletBinding()]
    Param()
   
    Write-Output "Disabling privacy options..."
    $PrivacyKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Write-Output "Key:   ${_.KeyName}   Path:   ${_.Path}";
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.DefaultValue
    }
    Write-Output "Privacy disabled."
}
