Function Get-BlacklistedServices {
    [CmdletBinding()]   
    Param()

    $Services = Get-Content -Path "./Lists/Services/Blacklist.json" | `
        ConvertFrom-Json | `
        ForEach-Object { $_.Services } | `
        Where-Object { $_.ShouldRemove -eq $true } | `
        Select-Object Name

    return $Services
}

Function Disable-Services {
    [CmdletBinding()]     
    Param()

    Get-BlacklistedServices | ForEach-Object { Stop-Service; Set-Service -StartupType Disabled }
}

Function Enable-Services {
    [CmdletBinding()]     
    Param()
    
    Get-BlacklistedServices | ForEach-Object { Set-Service -StartupType Automatic; Start-Service }
}
