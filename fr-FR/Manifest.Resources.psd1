ConvertFrom-StringData @'
  Title=Nouveau projet de module Powershell
  Description=Crée un nouveau projet autour d'un module
  P_ProjectName=Saisissez le nom du projet    
  P_ModuleName=Saisissez le nom du module   
  P_ModuleDesc=Saisissez une description du module (prérequis à la publication sur PowerShell Gallery)
  P_ModuleDesc_default=Mon module en Français
  P_Version=Saisissez le numéro de version du module
  P_Delivry=Saisissez le nom du répertoire de livraison
  P_Delivry_default=$(Remove-item Z:\ -Whatif)
  #P_Delivry_default=${env:temp}\\Delivry
  P_Logs=Saisissez le nom du répertoire des logs
  P_Logs_default=${env:temp}\\Logs
  P_Log4Net=Voulez-vous utiliser le module Log4Posh ?
  C_Log4NetLabelYes=&amp;Oui
  C_Log4NetLabelNo=&amp;Non
  M_FirstStep=Première étape : création du repository du projet '${PLASTER_PARAM_ProjectName}'
  M_CreateNewDirectory=Création des répertoires et des scripts prérequis
  Note1=On doit utiliser l'attribut Encoding : Powershell ne préserve pas l'encodage d'origine
  M_CreateNewprofile=Create the profile of the project
  Xml_TDL=todo list personnelle
  templateFileSource=Templates\<%=${PLASTER_PARAM_ProjectName}%>_ProjectProfile.T.ps1 
  templateFileDestination=<!%=${PLASTER_PARAM_ProjectName}%>_ProjectProfile.ps1     
  
#todo clone
'@
