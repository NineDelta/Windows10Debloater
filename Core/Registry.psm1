Function Get-RegistryKeysBlacklist {
    [CmdletBinding()]   
    Param()

    $Keys = Get-Content -Path "./Lists/Keys/Blacklist.json" | `
        ConvertFrom-Json | `
        ForEach-Object { $_.Keys } | `
        Where-Object { $_.ShouldRemove -eq $true } | `
        Select-Object Path 

    return $Keys
}

Function Remove-Keys {
    [CmdletBinding()]   
    Param()

    Write-Output "Removing bloatware registry keys..."
    Get-RegistryKeysBlacklist | ForEach-Object { Remove-Item -Recurse }
    Write-Output "Bloatware registry keys removed."
}
