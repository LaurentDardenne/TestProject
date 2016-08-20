Import-Module Plaster
$VerbosePreference='Continue'

$Source="$PSScriptRoot"
$outDir="$Source\Out\Create"

$PlasterParams = @{
    TemplatePath = $Source
    DestinationPath = $outDir
    ProjectName ='PSScriptAnalyzerRules'
    ModuleName = 'PSScriptAnalyzerRules'
}

Invoke-Plaster @PlasterParams

$SourceClone="$OutDir\Tools\PlasterClone"

$PlasterParams = @{
    TemplatePath = $SourceClone
    DestinationPath ="$Source\Out\Clone"
}

Invoke-Plaster @PlasterParams -Force 

return
$m=get-module plaster

$Vars=&$m {Invoke-Plaster @PlasterParams -Force ; gv Plaster_*}

$Vars|New-Variable
