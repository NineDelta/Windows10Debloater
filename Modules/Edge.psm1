Function Enable-EdgePDF {
    [CmdletBinding()] 
    Param()

    Write-Output "Enabling Edge PDF default..."
    $NoPDF = "HKCR:\.pdf"
    $NoProgids = "HKCR:\.pdf\OpenWithProgids"
    $NoWithList = "HKCR:\.pdf\OpenWithList"

    #Sets edge back to default
    If (Get-ItemProperty $NoPDF NoOpenWith) { Remove-ItemProperty $NoPDF NoOpenWith } 
    If (Get-ItemProperty $NoPDF NoStaticDefaultVerb) { Remove-ItemProperty $NoPDF NoStaticDefaultVerb }       
    If (Get-ItemProperty $NoProgids NoOpenWith) { Remove-ItemProperty $NoProgids NoOpenWith }        
    If (Get-ItemProperty $NoProgids NoStaticDefaultVerb) { Remove-ItemProperty $NoProgids NoStaticDefaultVerb }        
    If (Get-ItemProperty $NoWithList NoOpenWith) { Remove-ItemProperty $NoWithList NoOpenWith }    
    If (Get-ItemProperty $NoWithList NoStaticDefaultVerb) { Remove-ItemProperty $NoWithList NoStaticDefaultVerb }
        
    #Removes an underscore '_' from the Registry key for Edge
    $Edge2 = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_"
    If (Test-Path $Edge2) { Set-Item $Edge2 AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723 }
    Write-Output "Edge PDF default enabled."
}

Function Disable-EdgePDF {
    [CmdletBinding()]
    Param()

    #Stops edge from taking over as the default .PDF viewer    
    Write-Output "Disabling Edge PDF default..."
    $NoPDF = "HKCR:\.pdf"
    $NoProgids = "HKCR:\.pdf\OpenWithProgids"
    $NoWithList = "HKCR:\.pdf\OpenWithList" 

    If (!(Get-ItemProperty $NoPDF NoOpenWith)) { New-ItemProperty $NoPDF NoOpenWith }        
    If (!(Get-ItemProperty $NoPDF NoStaticDefaultVerb)) { New-ItemProperty $NoPDF NoStaticDefaultVerb }        
    If (!(Get-ItemProperty $NoProgids NoOpenWith)) { New-ItemProperty $NoProgids NoOpenWith }        
    If (!(Get-ItemProperty $NoProgids NoStaticDefaultVerb)) { New-ItemProperty $NoProgids NoStaticDefaultVerb }        
    If (!(Get-ItemProperty $NoWithList NoOpenWith)) { New-ItemProperty $NoWithList NoOpenWith }        
    If (!(Get-ItemProperty $NoWithList NoStaticDefaultVerb)) { New-ItemProperty $NoWithList NoStaticDefaultVerb }
            
    #Appends an underscore '_' to the Registry key for Edge
    $Edge = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_"
    If (Test-Path $Edge) { Set-Item $Edge AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_ }
    Write-Output "Edge PDF default disabled."
}
