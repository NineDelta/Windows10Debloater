Function Get-BlacklistedApplications {
    [CmdletBinding()]   
    Param()

    $BlacklistedApps = Get-Content -Path "./Lists/Apps/Blacklist.json" | `
        ConvertFrom-Json | `
        ForEach-Object { $_.Apps } | `
        Where-Object { $_.ShouldRemove -eq $true } | `
        Select-Object Name 

    return $BlacklistedApps
}

Function Get-WhitelistedApplications {
    [CmdletBinding()]   
    Param()

    $WhitelistedApps = Get-Content -Path "./Lists/Apps/Whitelist.json" | `
        ConvertFrom-Json | `
        ForEach-Object { $_.Apps } | `
        Where-Object { $_.ShouldRemove -eq $false } | `
        Select-Object Name 

    return $WhitelistedApps
}

function Remove-Apps {
    [CmdletBinding()]
    Param([Parameter(Mandatory=$false)][switch]$RemoveAll)

    If ($RemoveAll) { Remove-AllApps } Else { Remove-BlackListedApps }
}

Function Remove-BlacklistedApps {
    [CmdletBinding()]
    Param ()

    $BlacklistedApps = Get-BlacklistedApplications
    
    Get-AppxPackage -AllUsers | `
        Where-Object { $_.Name -In $BlacklistedApps } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxPackage | `
        Where-Object { $_.Name -In $BlacklistedApps } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxProvisionedPackage -Online | `
        Where-Object { $_.DisplayName -In $BlacklistedApps } | `
        Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Function Remove-AllApps {
    [CmdletBinding()]  
    Param()
    
    $WhitelistedApps = Get-WhitelistedApplications

    Get-AppxPackage -AllUsers | Where-Object { $_.Name -NotIn $WhitelistedApps } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxPackage | Where-Object { $_.Name -NotIn $WhitelistedApps } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxProvisionedPackage -Online | `
        Where-Object { $_.DisplayName -NotIn $WhitelistedApps } | `
        Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Function Restore-WhitelistedApps {
    [CmdletBinding()]     
    Param()
    
    $WhitelistedApps = Get-WhitelistedApplications

    Get-AppxPackage -AllUsers | `
        Where-Object { $_.Name -In $WhitelistedApps } | `
        ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}

Function Restore-Apps {
    [CmdletBinding()]
    Param ()

    Get-AppxPackage -AllUsers | `
        ForEach-Object { Add-AppxPackage -Verbose -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}
