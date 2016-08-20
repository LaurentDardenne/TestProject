#Release.ps1
#Construit la version Release via Psake

Task default -Depends CreateZip 

Task CreateZip -Depends Delivery,PSScriptAnalyzer,TestBomFinal {

  $zipFile = "$env:\Temp\<%=${PLASTER_PARAM_ProjectName}%>.zip"
  Add-Type -assemblyname System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::CreateFromDirectory($<%=${PLASTER_PARAM_ProjectName}%>Delivery, $zipFile)
  if (Test-Path env:APPVEYOR)
  { Push-AppveyorArtifact $zipFile }     
}

Task Delivery -Depends Clean,RemoveConditionnal {
 #Recopie les fichiers dans le répertoire de livraison  
$VerbosePreference='Continue'
 
#log4Net config
# on copie la config de dev nécessaire au build. 
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\Log4Net.Config.xml" "$<%=${PLASTER_PARAM_ProjectName}%>Livraison"

#Doc xml localisée
   #US
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\<%=${PLASTER_PARAM_ProjectName}%>.Resources.psd1" "$<%=${PLASTER_PARAM_ProjectName}%>Livraison\<%=${PLASTER_PARAM_ProjectName}%>.Resources.psd1" 
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\en-US\about_<%=${PLASTER_PARAM_ProjectName}%>.help.txt" "$<%=${PLASTER_PARAM_ProjectName}%>Livraison\en-US\about_<%=${PLASTER_PARAM_ProjectName}%>.help.txt"

  #Fr 
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\fr-FR\$<%=${PLASTER_PARAM_ProjectName}%>.Resources.psd1" "$<%=${PLASTER_PARAM_ProjectName}%>Livraison\fr-FR\<%=${PLASTER_PARAM_ProjectName}%>.Resources.psd1"
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\fr-FR\about_<%=${PLASTER_PARAM_ProjectName}%>.help.txt" "$<%=${PLASTER_PARAM_ProjectName}%>Livraison\fr-FR\about_<%=${PLASTER_PARAM_ProjectName}%>.help.txt"
 

#Demos
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\Demos" "$<%=${PLASTER_PARAM_ProjectName}%>Livraison\Demos" -Recurse

#PS1xml   

#Licence                         

#Module
      #<%=${PLASTER_PARAM_ProjectName}%>.psm1 est créé par la tâche RemoveConditionnal
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\<%=${PLASTER_PARAM_ProjectName}%>.psd1" "$<%=${PLASTER_PARAM_ProjectName}%>Delivery"
   
#Setup
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Setup\<%=${PLASTER_PARAM_ProjectName}%>Setup.ps1" "$<%=${PLASTER_PARAM_ProjectName}%>Delivery"

#Other 
   Copy "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\Revisions.txt" "$<%=${PLASTER_PARAM_ProjectName}%>Delivery"
} #Delivery

Task RemoveConditionnal -Depend TestLocalizedData {
#Traite les pseudo directives de parsing conditionnelle
  
   $VerbosePreference='Continue'
   ."$<%=${PLASTER_PARAM_ProjectName}%>Tools\Remove-Conditionnal.ps1"
   Write-debug "Configuration=$Configuration"
   Dir "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\<%=${PLASTER_PARAM_ProjectName}%>.psm1"|
    Foreach {
      $Source=$_
      Write-Verbose "Parse :$($_.FullName)"
      $CurrentFileName="$<%=${PLASTER_PARAM_ProjectName}%>Delivery\$($_.Name)"
      Write-Warning "CurrentFileName=$CurrentFileName"
      if ($Configuration -eq "Release")
      { 
         Write-Warning "`tTraite la configuration Release"
         #Supprime les lignes de code de Debug et de test
         #On traite une directive et supprime les lignes demandées. 
         #On inclut les fichiers.       
        Get-Content -Path $_ -ReadCount 0 -Encoding UTF8|
         Remove-Conditionnal -ConditionnalsKeyWord 'DEBUG' -Include -Remove -Container $Source|
         Remove-Conditionnal -Clean| 
         Set-Content -Path $CurrentFileName -Force -Encoding UTF8        
      }
      else
      { 
         #On ne traite aucune directive et on ne supprime rien. 
         #On inclut uniquement les fichiers.
        Write-Warning "`tTraite la configuration DEBUG" 
         #Directive inexistante et on ne supprime pas les directives
         #sinon cela génére trop de différences en cas de comparaison de fichier
        Get-Content -Path $_ -ReadCount 0 -Encoding UTF8|
         Remove-Conditionnal -ConditionnalsKeyWord 'NODEBUG' -Include -Container $Source|
         Set-Content -Path $CurrentFileName -Force -Encoding UTF8       
         
      }
    }#foreach
} #RemoveConditionnal

Task TestLocalizedData -ContinueOnError {
 ."$<%=${PLASTER_PARAM_ProjectName}%>Tools\Test-LocalizedData.ps1"

 $SearchDir="$<%=${PLASTER_PARAM_ProjectName}%>Vcs"
 Foreach ($Culture in $Cultures)
 {
   Dir "$SearchDir\<%=${PLASTER_PARAM_ProjectName}%>.psm1"|          
    Foreach-Object {
       #Construit un objet contenant des membres identiques au nombre de 
       #paramètres de la fonction Test-LocalizedData 
      New-Object PsCustomObject -Property @{
                                     Culture=$Culture;
                                     Path="$SearchDir";
                                       #convention de nommage de fichier d'aide
                                     LocalizedFilename="$($_.BaseName)LocalizedData.psd1";
                                     FileName=$_.Name;
                                       #convention de nommage de variable
                                     PrefixPattern="$($_.BaseName)Msgs\."
                                  }
    }|   
    Test-LocalizedData -verbose
 }
} #TestLocalizedData

Task Clean -Depends Init {
# Supprime, puis recrée le dossier de livraison   

   $VerbosePreference='Continue'
   Remove-Item $<%=${PLASTER_PARAM_ProjectName}%>Delivery -Recurse -Force -ea SilentlyContinue
   "$<%=${PLASTER_PARAM_ProjectName}%>Delivery\en-US", 
   "$<%=${PLASTER_PARAM_ProjectName}%>Delivery\fr-FR", 
   "$<%=${PLASTER_PARAM_ProjectName}%>Delivery\FormatData",
   "$<%=${PLASTER_PARAM_ProjectName}%>Delivery\TypeData",
   "$<%=${PLASTER_PARAM_ProjectName}%>Delivery\Logs"|
   Foreach {
    md $_ -Verbose -ea SilentlyContinue > $null
   } 
} #Clean

Task Init -Depends TestBOM {
#validation à minima des prérequis

 Write-host "Mode $Configuration"
  if (-not (Test-Path Env:Profile<%=${PLASTER_PARAM_ProjectName}%>))
  {Throw 'La variable $Profile<%=${PLASTER_PARAM_ProjectName}%> n''est pas déclarée.'}
    
} #Init

Task TestBOM {
#Validation de l'encodage des fichiers AVANT la génération  
  Write-Host "Validation de l'encodage des fichiers du répertoire : $<%=${PLASTER_PARAM_ProjectName}%>Vcs"
  
  Import-Module DTW.PS.FileSystem -Global
  
  $InvalidFiles=@(&"$<%=${PLASTER_PARAM_ProjectName}%>Tools\Test-BOMFile.ps1" $<%=${PLASTER_PARAM_ProjectName}%>Vcs)
  if ($InvalidFiles.Count -ne 0)
  { 
     $InvalidFiles |Format-List *
     Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
  }
} #TestBOM

#On duplique la tâche, car PSake ne peut exécuter deux fois une même tâche
Task TestBOMFinal {

#Validation de l'encodage des fichiers APRES la génération  
  
  Write-Host "Validation de l'encodage des fichiers du répertoire : $<%=${PLASTER_PARAM_ProjectName}%>Delivery"
  $InvalidFiles=@(&"$<%=${PLASTER_PARAM_ProjectName}%>Tools\Test-BOMFile.ps1" $<%=${PLASTER_PARAM_ProjectName}%>Delivery)
  if ($InvalidFiles.Count -ne 0)
  { 
     $InvalidFiles |Format-List *
     Throw "Des fichiers ne sont pas encodés en UTF8 ou sont codés BigEndian."
  }
} #TestBOMFinal

Task PSScriptAnalyzer {
  Write-host "Todo ValideParameterSet etc"
}#PSScriptAnalyzer
