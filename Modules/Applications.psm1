$Apps = @{
    Blacklist = @(
        # Windows 10 AppX Apps
        'Microsoft.BingNews', 
        'Microsoft.WindowsCamera', 
        'Microsoft.GetHelp', 
        'Microsoft.Getstarted', 
        'Microsoft.Messaging', 
        'Microsoft.Microsoft3DViewer', 
        'Microsoft.MicrosoftOfficeHub', 
        'Microsoft.MicrosoftSolitaireCollection', 
        'Microsoft.NetworkSpeedTest', 
        'Microsoft.News', 
        'Microsoft.Office.Lens', 
        'Microsoft.Office.OneNote', 
        'Microsoft.Office.Sway', 
        'Microsoft.OneConnect', 
        'Microsoft.People', 
        'Microsoft.Print3D', 
        'Microsoft.RemoteDesktop', 
        'Microsoft.SkypeApp', 
        'Microsoft.Office.Todo.List', 
        'Microsoft.Whiteboard', 
        'Microsoft.WindowsAlarms', 
        'microsoft.windowscommunicationsapps', 
        'Microsoft.WindowsFeedbackHub', 
        'Microsoft.WindowsMaps', 
        'Microsoft.WindowsSoundRecorder', 
        'Microsoft.Xbox.TCUI', 
        'Microsoft.XboxApp', 
        'Microsoft.XboxGameOverlay', 
        'Microsoft.XboxSpeechToTextOverlay', 
        'Microsoft.ZuneMusic', 
        'Microsoft.ZuneVideo', 

        # Sponsored Windows 10 AppX Apps
        '*EclipseManager*', 
        '*ActiproSoftwareLLC*', 
        '*AdobeSystemsIncorporated.AdobePhotoshopExpress*', 
        '*Duolingo-LearnLanguagesforFree*', 
        '*PandoraMediaInc*', 
        '*CandyCrush*', 
        '*Wunderlist*', 
        '*Flipboard*', 
        '*Twitter*', 
        '*Facebook*', 
        '*Spotify*', 
        '*Minecraft*', 
        '*Royal Revolt*', 
        '*Sway*', 
        '*Speed Test*', 
        '*Dolby*', 
        '*Windows.CBSPreview*', 
        
        # Optional Apps
        # Typically not removed, but can be if needed
        '*Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe*', 
        '*Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe*', 
        '*Microsoft.BingWeather*', 
        '*Microsoft.MSPaint*', 
        '*Microsoft.MicrosoftStickyNotes*', 
        '*Microsoft.Windows.Photos*' 

        # Whitelisted Apps
        #'Microsoft.DesktopAppInstaller',
        #'Microsoft.StorePurchaseApp', 
        #'*Microsoft.WindowsCalculator*', 
        #'*Microsoft.WindowsStore*',
        #'Microsoft.XboxIdentityProvider'
    )
    Whitelist = @(
        # DotNet
        '.NET',
        'Framework',

        # Windows Apps
        'Microsoft.DesktopAppInstaller',
        'Microsoft.StorePurchaseApp',
        'Microsoft.WindowsCalculator',
        'Microsoft.WindowsStore',
        'Microsoft.XboxIdentityProvider'
    )
}

function Remove-Apps {
    [CmdletBinding()]
    Param([Parameter(Mandatory=$false)][switch]$RemoveAll)

    Write-Output "Removing apps..."
    If ($RemoveAll) { Remove-AppsUsingWhitelist } Else { Remove-AppsUsingBlacklist }
    Write-Output "Apps removed."
}

Function Restore-Apps {
    [CmdletBinding()]
    Param ()

    Get-AppxPackage -AllUsers | `
        ForEach-Object { Add-AppxPackage -Verbose -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}

Function Remove-AppsUsingBlacklist {
    [CmdletBinding()]
    Param ()
    
    Get-AppxPackage -AllUsers | `
        Where-Object { $_.Name -In $Apps.Blacklist } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxPackage | `
        Where-Object { $_.Name -In $Apps.Blacklist } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxProvisionedPackage -Online | `
        Where-Object { $_.DisplayName -In $Apps.Blacklist } | `
        Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Function Remove-AppsUsingWhitelist {
    [CmdletBinding()]  
    Param()

    Get-AppxPackage -AllUsers | `
        Where-Object { $_.Name -NotIn $Apps.Whitelist } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxPackage | `
        Where-Object { $_.Name -NotIn $Apps.Whitelist } | `
        Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppxProvisionedPackage -Online | `
        Where-Object { $_.DisplayName -NotIn $Apps.Whitelist } | `
        Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Function Restore-AppsUsingWhitelist {
    [CmdletBinding()]     
    Param()

    Get-AppxPackage -AllUsers | `
        Where-Object { $_.Name -In $Apps.Whitelist } | `
        Where-Object { $_.Name -NotIn $Apps.Blacklist } | `
        ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}

Function Restore-AppsUsingBlacklist {
    [CmdletBinding()]     
    Param()

    Get-AppxPackage -AllUsers | `
        Where-Object { $_.Name -In $Apps.Whitelist } | `
        Where-Object { $_.Name -NotIn $Apps.Blacklist } | `
        ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}
