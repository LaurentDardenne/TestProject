
# Spécifique au poste de développement
$VcsPathRepository="<!%=${PLASTER_DestinationPath}%>" 

#Variable commune à tous les postes
#todo ${env:Name with space}
if ( $null -eq [System.Environment]::GetEnvironmentVariable("<%=${PLASTER_PARAM_ProjectName}%>Profile","User"))
{ [Environment]::SetEnvironmentVariable("<%=${PLASTER_PARAM_ProjectName}%>Profile",$VcsPathRepository, "User") }

 # Variable spécifiques au poste de développement
$<%=${PLASTER_PARAM_ProjectName}%>Delivry= "$('<!%=${PLASTER_PARAM_Delivry}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>"   
$<%=${PLASTER_PARAM_ProjectName}%>Logs= "$('<!%=${PLASTER_PARAM_Logs}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>" 

 # Variable communes à tous les postes, leurs contenu est spécifique au poste de développement
$<%=${PLASTER_PARAM_ProjectName}%>Bin= "$VcsPathRepository\Bin"
$<%=${PLASTER_PARAM_ProjectName}%>Help= "$VcsPathRepository\Documentation\Helps"
$<%=${PLASTER_PARAM_ProjectName}%>Setup= "$VcsPathRepository\Setup"
$<%=${PLASTER_PARAM_ProjectName}%>Vcs= "$VcsPathRepository"
$<%=${PLASTER_PARAM_ProjectName}%>Tests= "$VcsPathRepository\Tests"
$<%=${PLASTER_PARAM_ProjectName}%>Tools= "$VcsPathRepository\Tools"
$<%=${PLASTER_PARAM_ProjectName}%>Url= 'todo'
#todo a supprimer une fois l'url du projet renseigné
Set-PSBreakpoint -Variable <%=${PLASTER_PARAM_ProjectName}%>Url -Mode readwrite 

 #PSDrive sur le répertoire du projet 
$null=New-PsDrive -Scope Global -Name <%=${PLASTER_PARAM_ProjectName}%> -PSProvider FileSystem -Root $<%=${PLASTER_PARAM_ProjectName}%>Vcs 

Write-Host "Projet <%=${PLASTER_PARAM_ProjectName}%> configuré." -Fore Green

rv VcsPathRepository
