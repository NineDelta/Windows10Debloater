
$ScheduledTasks = @{
    RegistryKeys = @(
        # Background Tasks
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy',
        'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy',

        # Scheduled Tasks
        'HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe'
    )
    Tasks = @(
        'Consolidator',
        'DmClient',
        'DmClientOnScenarioDownload',
        'UsbCeip',
        'XblGameSaveTask',
        'XblGameSaveTaskLogon'
    )
}

Function Disable-ScheduledTasks {      
    [CmdletBinding()]         
    Param()
        
    Write-Output "Disabling scheduled tasks..."
    $ScheduledTasks.Tasks | ForEach-Object { Get-ScheduledTask | Disable-ScheduledTask }
    $ScheduledTasks.RegistryKeys | ForEach-Object { Write-Output "Path:   ${_}"; Remove-Item -Recurse }
    Write-Output "Scheduled tasks disabled."
}

Function Enable-ScheduledTasks {       
    [CmdletBinding()]           
    Param()
        
    Write-Output "Enabling scheduled tasks..."
    $ScheduledTasks.Tasks | ForEach-Object { Get-ScheduledTask | Enable-ScheduledTask }
    Write-Output "Scheduled tasks enabled."
}
