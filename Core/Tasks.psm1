Function Get-ScheduledTasksBlacklist {
    [CmdletBinding()]   
    Param()

    $Tasks = Get-Content -Path "./Lists/ScheduledTasks/Blacklist.json" | `
        ConvertFrom-Json | `
        ForEach-Object { $_.Tasks } | `
        Where-Object { $_.ShouldRemove -eq $true } | `
        Select-Object Name 

    return $Tasks
}

Function Disable-Tasks {      
    [CmdletBinding()]         
    Param()
        
    #Disables scheduled tasks that are considered unnecessary 
    Write-Output "Disabling scheduled tasks..."
    Get-ScheduledTasksBlacklist | ForEach-Object { Get-ScheduledTask | Disable-ScheduledTask }
    Write-Output "Scheduled tasks disabled."
}

Function Enable-Tasks {       
    [CmdletBinding()]           
    Param()
        
    #Re-enables scheduled tasks that were disabled when running the Debloat switch
    Write-Output "Enabling scheduled tasks..."
    Get-ScheduledTasksBlacklist | ForEach-Object { Get-ScheduledTask | Enable-ScheduledTask }
    Write-Output "Scheduled tasks enabled."
}
