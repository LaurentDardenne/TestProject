#Initialize-FilesTest.ps1

Import-Module Pester

if (Test-Path $Env:Temp)
{ $Temp=$Env:Temp }
else
{ $Temp=[System.IO.Path]::GetTempPath() }

$TestDirectory=Join-Path $Temp Test<%=${PLASTER_PARAM_ProjectName}%>
Write-host "Test in $TestDirectory"
rm $TestDirectory -rec -force -ea SilentlyContinue >$null
md $TestDirectory -ea SilentlyContinue >$null

 #Suppose la construction préalable via ..\Tools\Build.Ps1
Import-Module "$<%=${PLASTER_PARAM_ProjectName}%>Delivry\$<%=${PLASTER_PARAM_ModuleName}%>.psd1" 