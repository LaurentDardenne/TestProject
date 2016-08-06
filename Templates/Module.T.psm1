#<%=${PLASTER_PARAM_ModuleName}%>.psm1

#<DEFINE %Log4Net%> 
      
   #Récupère le code d'une fonction publique du module Log4Posh (Prérequis)
   #et l'exécute dans la portée du module
$Script:lg4n_ModuleName=$MyInvocation.MyCommand.ScriptBlock.Module.Name
$InitializeLogging=$MyInvocation.MyCommand.ScriptBlock.Module.NewBoundScriptBlock(${function:Initialize-Log4NetModule})
&$InitializeLogging $Script:lg4n_ModuleName "$psScriptRoot\Log4Net.Config.xml"
#<UNDEF %Log4Net%>


 #Liste des raccourcis de type
 #ATTENTION ne pas utiliser dans la déclaration d'un type de paramètre d'une fonction 
$<%=${PLASTER_PARAM_ModuleName}%>ShortCut=@{
}

$AcceleratorsType= [PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")
Try {
  $<%=${PLASTER_PARAM_ModuleName}%>ShortCut.GetEnumerator() |
  Foreach {
   Try {
     $AcceleratorsType::Add($_.Key,$_.Value)
   } Catch [System.Management.Automation.MethodInvocationException]{
     Write-Error -Exception $_.Exception 
   }
 } 
} Catch [System.Management.Automation.RuntimeException] {
   Write-Error -Exception $_.Exception
}

# Suppression des objets du module 
Function OnRemove<%=${PLASTER_PARAM_ModuleName}%>Zip {
  $DebugLogger.PSDebug("Remove TypeAccelerators") #<%REMOVE%> 
  <%=${PLASTER_PARAM_ModuleName}%>ShortCut.GetEnumerator()|
   Foreach {
     Try {
       [void]$AcceleratorsType::Remove($_.Key)
     } Catch {
       write-Error -Exception $_.Exception 
     }
   }
#<DEFINE %Log4Net%> 
  Stop-Log4Net $Script:lg4n_ModuleName
#<UNDEF %Log4Net%>  
}#OnRemove<%=${PLASTER_PARAM_ModuleName}%>Zip
 
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { OnRemove<%=${PLASTER_PARAM_ModuleName}%>Zip }


# Function CloneOptions { 
# #Clone les propriétés de type 'Property" uniquement
#  param (
#   $Old,
#   $New=$null
#  ) 
# 
#  if ($New -eq $null) 
#  { $New=New-ZipSfxOptions }
# 
#  $Old.PSObject.Properties.Match("*","Property")|
#   Foreach {
#    $New."$($_.Name)"=$Old."$($_.Name)"
#   } 
#  $New
# } #CloneOptions 
# 
# Function Set-PsIonicSfxOptions { 
# # .ExternalHelp PsIonic-Help.xml         
#   param (
#     [Parameter(Position=0, Mandatory=$True,ValueFromPipeline=$True)]
#     [ValidateNotNullOrEmpty()]
#    [Ionic.Zip.SelfExtractorSaveOptions] $Options
#   )
#   [void](CloneSfxOptions $Options $Script:DefaultSfxConfiguration)
# } #Set-PsIonicSfxOptions 
# 
# Function Get-PsIonicSfxOptions { 
# # .ExternalHelp PsIonic-Help.xml         
# 
#  CloneSfxOptions $Script:DefaultSfxConfiguration
# } #Get-PsIonicSfxOptions 
# 
# Function Reset-PsIonicSfxOptions { 
# # .ExternalHelp PsIonic-Help.xml         
# 
#   $Script:DefaultSfxConfiguration=New-ZipSfxOptions
# } #Reset-PsIonicSfxOptions 
# 
# 
# #Crée la variable $DefaultSfxConfiguration
# Reset-PsIonicSfxOptions                                                        
# If (Test-Path Function:Get-PsIonicDefaultSfxConfiguration)
# { 
#   #A ce stade, les fonctions de ce module ne sont pas encore accessible à la fonction externe. 
#   #Même si ce code se trouvait après l'appel à Export-ModuleMember 
#   $FunctionBounded=$MyInvocation.MyCommand.ScriptBlock.Module.NewBoundScriptBlock(${function:Get-PsIonicDefaultSfxConfiguration})
#   &$FunctionBounded|Set-PsIonicSfxOptions
# }

 
#Set-Alias -name gzxo    -value Get-PsIonicSfxOptions

#Export-ModuleMember -Alias * -Function Set-PsIonicSfxOptions,Get-PsIonicSfxOptions,Reset-PsIonicSfxOptions
