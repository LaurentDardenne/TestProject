#Build.ps1
#Construit la version de <%=${PLASTER_PARAM_ModuleName}%>  
 [CmdletBinding(DefaultParameterSetName = "Debug")]
 Param(
     [Parameter(ParameterSetName="Release")]
   [switch] $Release
 ) 
# Le profile du projet (<%=${PLASTER_PARAM_ProjectName}%>_ProjectProfile.ps1) doit être chargé

Set-Location $<%=${PLASTER_PARAM_ProjectName}%>Tools

try {
 'Psake'|
 Foreach {
   $name=$_
   Import-Module $Name -EA stop -force
 }
} catch {
 Throw "Module $name is unavailable."
}  

try {
  $Error.Clear()
    #Release utilise en interne Show-BalloonTip
    #Une fois ses tâches terminée, la fonction Show-BalloonTip
    #n'est plus disponible, on la recharge donc dans la portée courante. 
  . "$<%=${PLASTER_PARAM_ProjectName}%>Tools\Show-BalloonTip.ps1"
  Invoke-Psake .\Release.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo
  
  if ($psake.build_success)
  { 
   Show-BalloonTip –Text 'Construction terminée.' –Title 'Build <%=${PLASTER_PARAM_ModuleName}%>' –Icon Info 
   #Invoke-Psake .\BuildZipAndSFX.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo 
   if ($script:balloon -ne $null)
   {
     $script:balloon.Dispose()
     Remove-Variable -Scope script -Name Balloon
   }
  }
  else
  { 
   Show-BalloonTip –Text 'Build Fail' –Title 'Build <%=${PLASTER_PARAM_ModuleName}%>' –Icon Error   
  }
} finally {
  if ($script:balloon -ne $null)
  { 
    $script:balloon.Dispose()
    Remove-Variable -Scope script -Name Balloon
  }
}
