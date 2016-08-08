cd $PSScriptroot
Function Format-TestLocalizedData {
<#
.SYNOPSIS
  Formate et affiche les données issues de Compare-Localized.
#> 
 param(
       #Collection des clés à comparer
     [Parameter(Position=0, Mandatory=$true)]
     [AllowNull()]
   [Object[]]$Inputobject 
 )
  if ($null -eq $Inputobject) {return} 
  $Egaux, $Supprime, $Nouveaux =1..3|% {New-Object System.Collections.ArrayList}
  
  foreach ($Item in $InputObject)
  {
     Write-debug "item = $($Item.SideIndicator)"
     switch ($Item.SideIndicator) 
     {
      '==' {$Egaux.Add($Item.InputObject)>$null;Write-debug "Egal $($Item.InputObject))" }
      '<=' {$Nouveaux.Add($Item.InputObject)>$null;Write-debug "Nouveau $($Item.InputObject))" }
      '=>' {$Supprime.Add($Item.InputObject)>$null;Write-debug "Supprimé $($Item.InputObject))" }
     }
  }

  $ofs="`r`n`t"
  Write-host "Valide les clés du fichier '$($InputObject.FileName)':" -fore Cyan
  Write-host " Clés utilisées pour la culture '$($InputObject.Culture)':" -fore green
   Write-host "`t$Egaux" 
  
  Write-host " Clés inconnues dans le code source :" -fore green
   Write-host "`t$Supprime"
  
  Write-host " Clés inutilisées de la liste localisée :" -fore green
   Write-host "`t$Nouveaux"
}#Format-TestLocalizedData


Import-LocalizedData -BindingVariable USMsg -Filename "Manifest.Resources.psd1" -UI 'en-US' -EA Stop
Import-LocalizedData -BindingVariable FRMsg -Filename "Manifest.Resources.psd1" -UI 'fr-FR' -EA Stop

$Compare=Compare-Object ($USMsg.Keys -as [string[]]) ($FRMsg.Keys -as [string[]])-IncludeEqual
Add-member -Member NoteProperty -name Culture -input $Compare -value $Culture
Add-member -Member NoteProperty -name Filename -input $Compare -value "Manifest.Resources.psd1" 
Format-TestLocalizedData $Compare