#todo proxy de Invoke-Plaster?

$PSGalleryPublishUri = 'https://www.myget.org/F/ottomatt/api/v2/package'
$PSGallerySourceUri = 'https://www.myget.org/F/ottomatt/api/v2'
try{
 Get-PSRepository OttoMatt -EA Stop >$null   
}catch {
  if ($_.CategoryInfo.Category -ne 'ObjectNotFound')
  { throw $_ }
  else
  { Register-PSRepository -Name OttoMatt -SourceLocation $PSGallerySourceUri -PublishLocation $PSGalleryPublishUri -InstallationPolicy Trusted }
}

 #On installe les prérequis sur le poste pas dans le référentiel projet
 # La tâche de build doit pointer sur ces scripts 
 #user : "${env:USERPROFILE}\Documents\WindowsPowerShell\Scripts"
 #all : "${env:ProgramFiles}\WindowsPowerShell\Scripts
'Replace-String','Lock-File','Remove-Conditionnal',
'Show-BalloonTip','Test-BOMFile','Using-Culture'|
  Foreach {
   Install-Script -name "$_" -Repository OttoMatt -Scope AllUsers 
  }
"Log4Posh","DTW.PS.FileSystem" |
 Foreach {
   Install-Module -name $_ -Repository OttoMatt -Scope AllUsers
 }
 