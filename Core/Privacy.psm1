Function Get-PrivacyRegistryKeys {
    [CmdletBinding()]   
    Param()

    $PrivacyKeys = Get-Content -Path "./Lists/RegistryKeys/Cortana.json" | `
        ConvertFrom-Json | `
        ForEach-Object { $_.Keys } | `
        Where-Object { $_.ShouldRemove -eq $true }

    return $PrivacyKeys
}

Function Enable-Privacy {
    [CmdletBinding()]
    Param()
     
    Get-PrivacyRegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.Value
    }
}

Function Disable-Privacy {
    [CmdletBinding()]
    Param()
   
    Get-PrivacyRegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.DefaultValue
    }
}
