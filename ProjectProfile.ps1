Import-Module Plaster
$VerbosePreference='Continue'


cd G:\PS\Plaster\TestProject

remove-item 'G:\PS\Plaster\Out\TestProject' -Recurse

$PlasterParams = @{
    TemplatePath = 'G:\PS\Plaster\TestProject'
    DestinationPath = 'G:\PS\Plaster\Out\TestProject'
    ProjectName ='PlasterTest'
    ModuleName = 'TestPlaster'
}

Invoke-Plaster @PlasterParams -Force 

cd G:\PS\Plaster\Out\TestProject\Tools\PlasterClone

remove-item 'C:\Ttemp\PlasterTest' -Recurse

$PlasterParams = @{
    TemplatePath = 'G:\PS\Plaster\Out\TestProject\Tools\PlasterClone'
    DestinationPath = 'C:\Ttemp\PlasterClone'
}

Invoke-Plaster @PlasterParams -Force 

return
$m=get-module plaster

$Vars=&$m {Invoke-Plaster @PlasterParams -Force ; gv Plaster_*}

$Vars|New-Variable
