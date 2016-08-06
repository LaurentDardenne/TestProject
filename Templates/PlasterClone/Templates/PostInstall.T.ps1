#PostInstall Plaster <%=${PLASTER_PARAM_ProjectName}%>  

#Une fois le repository du projet crée, 
# ces fichiers peuvent être recopiés sur une autre poste

#Bibliothéque pour l'Explorer
Copy-item '<!%=${PLASTER_DestinationPath}%>\<%=${PLASTER_PARAM_ProjectName}%>.library-ms' '<!%=${Env:AppData}%>\Microsoft\Windows\Libraries\<%=${PLASTER_PARAM_ProjectName}%>.library-ms' -Force

#Profile du projet
Copy-item '<!%=${PLASTER_DestinationPath}%>\<%=${PLASTER_PARAM_ProjectName}%>_ProjectProfile.ps1' "$PSProfile\ProjectsProfile" -Force
