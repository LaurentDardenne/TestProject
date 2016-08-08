cd $PSScriptroot

$HashTableVariableName='ManifestLocalizedData'
Microsoft.PowerShell.Utility\Import-LocalizedData $HashTableVariableName -FileName Manifest.Resources.psd1 -verbose
 #Assert: LocalizedData must exist inside the scope
get-item variable:$HashTableVariableName -ea Stop >$null

$Content=gc .\plasterManifest.Localized.xml -raw
$pattern = "\`$$HashTableVariableName\.(?!\s)(?<KeyName>.*?)(?=(<|'|\s|\)|}|\.|-))"

 #We use one private fonction outside the module context 
$m=ipmo Plaster -pass

 #Replace all variable $ManifestLocalizedData.xxx
$sbReplaceLocalized={[regex]::Replace($content, $pattern, {
    param($match)
    Write-Debug "`r`nReceive  $($match.Value)"
    $Key=&$m Expandstring $match.groups['KeyName'].Value
    if ($($match.groups['KeyName'].Value) -ne $Key)
    {  Write-Debug "`t`tExpandString '$($match.groups['KeyName'].Value)' to '$Key'" }

     #if (iex "`$$HashTableVariableName.ContainsKey(`$Key)")
    if ($ManifestLocalizedData.ContainsKey($Key))
    {
      Write-Debug "`t found '$key'"
      $lzdValue=$ManifestLocalizedData.$Key
      if (![string]::IsNullOrEmpty($lzdValue))
      {
        Write-Debug "`t Check the value '$lzdValue'"
        &$m Expandstring $lzdValue > $null
        Write-Debug "`t return '$lzdValue'"
        return $lzdValue
      }
      else
      { Write-Error "The value of the key '$Key' is null or empty."  }
    }
    else
    { Write-Error "The key '$Key' do not exist "  }

 },  @('IgnoreCase', 'SingleLine', 'MultiLine'))
}
$newContent = &$sbReplaceLocalized
$Culture=[System.Threading.Thread]::CurrentThread.CurrentCulture
$Path="$PSScriptroot\plasterManifest_$Culture.xml"
Set-Content -LiteralPath $path -Value $newContent -Encoding UTF8
Write-Host "File created : $Path"
#type $Path|more
#Using-Culute -Culture 'fr-FR' -Script {.\BuildManifest.ps1}
#Using-Culute -Culture 'en-US' -Script {.\BuildManifest.ps1}
  