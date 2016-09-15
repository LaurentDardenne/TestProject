$ModuleVersion=(Import-ManifestData "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\<%=${PLASTER_PARAM_ProjectName}%>.psd1").ModuleVersion

nuspec '<%=${PLASTER_PARAM_ProjectName}%>' $ModuleVersion {
   properties @{
        Authors='Dardenne Laurent'
        Description="<%=${PLASTER_PARAM_ModuleDesc}%>"
        title='<%=${PLASTER_PARAM_ProjectName}%>'
        summary='Transforms an XML file into a class C# and vice versa.'
        copyright='Copyleft'
        language='en-US'
        licenseUrl='https://creativecommons.org/licenses/by-nc-sa/4.0/'
        projectUrl='https://github.com/LaurentDardenne/<%=${PLASTER_PARAM_ProjectName}%>'
        iconUrl='https://github.com/LaurentDardenne/<%=${PLASTER_PARAM_ProjectName}%>/blob/master/icon/<%=${PLASTER_PARAM_ProjectName}%>.png'
        releaseNotes="$(Get-Content "$<%=${PLASTER_PARAM_ProjectName}%>Vcs\CHANGELOG.md" -raw)"
        tags=''
   }
   
   files {
    file -src "G:\PS\<%=${PLASTER_PARAM_ProjectName}%>\<%=${PLASTER_PARAM_ProjectName}%>.psd1"
    file -src "G:\PS\<%=${PLASTER_PARAM_ProjectName}%>\<%=${PLASTER_PARAM_ProjectName}%>.psm1"
   }
}|Save-Nuspec -FileName "$<%=${PLASTER_PARAM_ProjectName}%>Delivery\<%=${PLASTER_PARAM_ProjectName}%>.nuspec"
