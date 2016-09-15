Param (
 # Specific to the development computer
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

# Common variable for development computers
if ( $null -eq [System.Environment]::GetEnvironmentVariable('Profile<%=${PLASTER_PARAM_ProjectName}%>','User'))
{ 
 [Environment]::SetEnvironmentVariable('Profile<%=${PLASTER_PARAM_ProjectName}%>',$VcsPathRepository, 'User')
  #refresh the Powershell environment provider
 $env:Profile<%=${PLASTER_PARAM_ProjectName}%>=$VcsPathRepository 
}

 # Specifics variables  to the development computer
$<%=${PLASTER_PARAM_ProjectName}%>Delivery= "$('<%=${PLASTER_PARAM_Delivery}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>"   
$<%=${PLASTER_PARAM_ProjectName}%>Logs= "$('<%=${PLASTER_PARAM_Logs}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>" 
$<%=${PLASTER_PARAM_ProjectName}%>Delivery, $<%=${PLASTER_PARAM_ProjectName}%>Logs|
 Foreach-Object {
  new-item $_ -ItemType Directory -EA SilentlyContinue         
 }

 # Commons variable for all development computers
 # Their content is specific to the development computer 
$<%=${PLASTER_PARAM_ProjectName}%>Bin= "$VcsPathRepository\Bin"
$<%=${PLASTER_PARAM_ProjectName}%>Help= "$VcsPathRepository\Documentation\Helps"
$<%=${PLASTER_PARAM_ProjectName}%>Setup= "$VcsPathRepository\Setup"
$<%=${PLASTER_PARAM_ProjectName}%>Vcs= "$VcsPathRepository"
$<%=${PLASTER_PARAM_ProjectName}%>Tests= "$VcsPathRepository\Tests"
$<%=${PLASTER_PARAM_ProjectName}%>Tools= "$VcsPathRepository\Tools"
$<%=${PLASTER_PARAM_ProjectName}%>Url='https://github.com/<%=${PLASTER_PARAM_FullName}%>\<%=${PLASTER_PARAM_ProjectName}%>.git' 

 #PSDrive to the project directory 
$null=New-PsDrive -Scope Global -Name <%=${PLASTER_PARAM_ProjectName}%> -PSProvider FileSystem -Root $<%=${PLASTER_PARAM_ProjectName}%>Vcs 

Write-Host 'Settings of the variables of <%=${PLASTER_PARAM_ProjectName}%> project.' -Fore Green

rv VcsPathRepository
