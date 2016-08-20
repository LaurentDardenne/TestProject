ConvertFrom-StringData @'
  Title=New Powershell module project
  Description=Create a new project
  P_ProjectName=Enter the name of the project    
  P_ModuleName=Enter the name of the module   
  P_ModuleDesc=Enter a description of the module (required for publishing to the PowerShell Gallery)
  P_ModuleDesc_default=Enter a description of the module (required for publishing to the PowerShell Gallery)
  P_Version=Enter the version number for the module
  P_Delivery=Enter the name of the Delivery directory
   #P_Delivery_default=$(Remove-item Z:\ -Whatif)
  P_Delivery_default=${env:temp}\\Delivery  
  P_Logs=Enter the name of the logs directory
  P_Logs_default=${env:temp}\\Logs
  P_Log4Net=Do you want to use the Log4Posh Module ?
  C_Log4NetLabelYes=&amp;Yes
  C_Log4NetLabelNo=&amp;No
  M_FirstStep=create the repository for the '${PLASTER_PARAM_ProjectName}' project
  M_CreateNewDirectory=Create new directories and the required scripts
  note1=We must use Encoding attribut : Powershell do not preserve the original encoding
  M_CreateNewprofile=Create the profile of the project
  Xml_TDL=Personnal todo list
  templateFileSource=Templates\<%=${PLASTER_PARAM_ProjectName}%>_ProjectProfile.T.ps1 
  templateFileDestination=<!%=${PLASTER_PARAM_ProjectName}%>_ProjectProfile.ps1     
  
#todo clone
'@
