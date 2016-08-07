Import-Module Plaster
$VerbosePreference='Continue'

$Source='G:\PS\Plaster\TestProject'
 #$outDir="$Env:Temp\Plaster\Out\TestProject"
$outDir='G:\PS\Plaster\Out\TestProject'
md $outDir 

remove-item $outDir -Recurse

$PlasterParams = @{
    TemplatePath = $Source
    DestinationPath = $outDir
    ProjectName ='PlasterTest'
    ModuleName = 'TestPlaster'
}

Invoke-Plaster @PlasterParams -Force 

$SourceClone="$OutDir\Tools\PlasterClone"
$outDir='G:\PS\Plaster\Out\PlasterClone'

md  $outDir
remove-item $outDir -Recurse

$PlasterParams = @{
    TemplatePath = $SourceClone
    DestinationPath = $outDir
}

Invoke-Plaster @PlasterParams -Force 

return
$m=get-module plaster

$Vars=&$m {Invoke-Plaster @PlasterParams -Force ; gv Plaster_*}

$Vars|New-Variable
