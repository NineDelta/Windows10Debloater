$Services = @(
    # WAP Push Service
    'dmwappushservice',
    # Diagnostics Tracking Service
    'DiagTrack'
)

Function Disable-Services {
    [CmdletBinding()]     
    Param()

    Write-Output "Disabling unnecessary services..."
    $Services | ForEach-Object { Stop-Service; Set-Service -StartupType Disabled }
    Write-Output "Unnecessary services disabled."
}

Function Enable-Services {
    [CmdletBinding()]     
    Param()
    
    Write-Output "Enabling unnecessary services..."
    $Services | ForEach-Object { Set-Service -StartupType Automatic; Start-Service }
    Write-Output "Unnecessary services enabled."
}
