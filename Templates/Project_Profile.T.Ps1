Param (
 # Spécifique au poste de développement
 [string] $VcsPathRepository='' #"<%=${PLASTER_DestinationPath}%>"
) 

if (Test-Path env:APPVEYOR_BUILD_FOLDER)
{
  $VcsPathRepository=$env:APPVEYOR_BUILD_FOLDER
}

if (!(Test-Path $VcsPathRepository))
{
  Throw 'Configuration error, the variable $VcsPathRepository should be configured.'
}

#Variable commune à tous les postes
#todo ${env:Name with space}
if ( $null -eq [System.Environment]::GetEnvironmentVariable("Profile<%=${PLASTER_PARAM_ProjectName}%>","User"))
{ 
 [Environment]::SetEnvironmentVariable("Profile<%=${PLASTER_PARAM_ProjectName}%>",$VcsPathRepository, "User")
  #refresh the environment Provider
 $env:Profile<%=${PLASTER_PARAM_ProjectName}%>=$VcsPathRepository 
}

 # Variable spécifiques au poste de développement
$<%=${PLASTER_PARAM_ProjectName}%>Delivry= "$('<%=${PLASTER_PARAM_Delivry}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>"   
$<%=${PLASTER_PARAM_ProjectName}%>Logs= "$('<%=${PLASTER_PARAM_Logs}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>" 

 # Variable communes à tous les postes, leurs contenu est spécifique au poste de développement
$<%=${PLASTER_PARAM_ProjectName}%>Bin= "$VcsPathRepository\Bin"
$<%=${PLASTER_PARAM_ProjectName}%>Help= "$VcsPathRepository\Documentation\Helps"
$<%=${PLASTER_PARAM_ProjectName}%>Setup= "$VcsPathRepository\Setup"
$<%=${PLASTER_PARAM_ProjectName}%>Vcs= "$VcsPathRepository"
$<%=${PLASTER_PARAM_ProjectName}%>Tests= "$VcsPathRepository\Tests"
$<%=${PLASTER_PARAM_ProjectName}%>Tools= "$VcsPathRepository\Tools"

if (Test-Path env:APPVEYOR_BUILD_FOLDER)
{
  $<%=${PLASTER_PARAM_ProjectName}%>Url="'https://github.com/${env:APPVEYOR_REPO_NAME}.git" 
}
else
{
  $<%=${PLASTER_PARAM_ProjectName}%>Url= 'Todo'
  # Configuration error, the variable path $<%=${PLASTER_PARAM_ProjectName}%>Url should be configured.'
  Set-PSBreakpoint -Variable <%=${PLASTER_PARAM_ProjectName}%>Url -Mode readwrite 
}
 #PSDrive sur le répertoire du projet 
$null=New-PsDrive -Scope Global -Name <%=${PLASTER_PARAM_ProjectName}%> -PSProvider FileSystem -Root $<%=${PLASTER_PARAM_ProjectName}%>Vcs 

Write-Host "Projet <%=${PLASTER_PARAM_ProjectName}%> configuré." -Fore Green

rv VcsPathRepository
