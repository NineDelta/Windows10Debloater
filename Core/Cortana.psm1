Function Get-CortanaRegistryKeys {
    [CmdletBinding()]   
    Param()

    $CortanaKeys = Get-Content -Path "./Lists/RegistryKeys/Cortana.json" | `
        ConvertFrom-Json | `
        ForEach-Object { $_.Keys } | `
        Where-Object { $_.ShouldRemove -eq $true }

    return $CortanaKeys
}

Function Disable-Cortana {
    [CmdletBinding()]
    Param()

    Get-CortanaRegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.Value
    }
}

Function Enable-Cortana {
    [CmdletBinding()]
    Param()

    Get-CortanaRegistryKeys | ForEach-Object { 
        If (!(Test-Path $_.Path)) { New-Item $_.Path }
        Set-ItemProperty -Path $_.Path -Name $_.KeyName -Value $_.DefaultValue
    }
}
