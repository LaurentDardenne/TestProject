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

$Error.Clear()
Invoke-Psake .\Release.ps1 -parameters @{"Config"="$($PsCmdlet.ParameterSetName)"} -nologo

