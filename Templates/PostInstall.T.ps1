#PostInstall 
#Project <%=${PLASTER_PARAM_ProjectName}%>  

$Delivry="$('<%=${PLASTER_PARAM_Delivry}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>"   
$Logs="$('<%=${PLASTER_PARAM_Logs}%>'.TrimEnd('\','/'))\<%=${PLASTER_PARAM_ProjectName}%>"
$Delivry,$logs|
 Foreach { 
   if (!(Test-Path $_)
   ( New-Item $_ -ItemType Directory > $null }
 }   

#Library for Explorer
Copy-item '<%=${PLASTER_DestinationPath}%>\<%=${PLASTER_PARAM_ProjectName}%>.library-ms' '<%=${Env:AppData}%>\Microsoft\Windows\Libraries\<%=${PLASTER_PARAM_ProjectName}%>.library-ms' -Force

#Project profile 
if (!(Test-Path "$PSProfile\ProjectsProfile")
 ( New-Item "$PSProfile\ProjectsProfile" -ItemType Directory > $null}   
Copy-item '<%=${PLASTER_DestinationPath}%>\<%=${PLASTER_PARAM_ProjectName}%>_ProjectProfile.ps1' "$PSProfile\ProjectsProfile" -Force


