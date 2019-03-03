$CortanaKeys = @(
    # Accept the Cortana Privacy Policy
    [PSCustomObject]@{ KeyName = 'AcceptedPrivacyPolicy'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' },
    # Prevent Cortana from collecting dictionary information
    [PSCustomObject]@{ KeyName = 'RestrictImplicitTextCollection'; Value = 1; DefaultValue = 0; Path = 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' },
    # Prevent Cortana from collecting handwriting information
    [PSCustomObject]@{ KeyName = 'RestrictImplicitInkCollection'; Value = 1; DefaultValue = 0; Path = 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' },
    # Allow Cortana to access Contacts
    [PSCustomObject]@{ KeyName = 'HarvestContacts'; Value = 0; DefaultValue = 1; Path = 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore' },
    # Disable Cortana from Windows Search
    [PSCustomObject]@{ KeyName = 'AllowCortana'; Value = 0; DefaultValue = 1; Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' }
)

Function Disable-Cortana {
    [CmdletBinding()]
    Param()

    Write-Output "Disabling Cortana..."
    $CortanaKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Write-Output "Key:   ${_.KeyName}   Path:   ${_.Path}";
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.Value
    }
    Write-Output "Cortana disabled."
}

Function Enable-Cortana {
    [CmdletBinding()]
    Param()

    Write-Output "Enabling Cortana..."
    $CortanaKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Write-Output "Key:   ${_.KeyName}   Path:   ${_.Path}";
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.DefaultValue
    }
    Write-Output "Cortana enabled."
}
