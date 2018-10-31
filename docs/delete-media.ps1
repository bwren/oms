$filebase = "C:\users\bwren\Git\azure-docs-pr\articles\"
$files = Import-Csv C:\Users\bwren\Git\bwren\scripts\media-files-delete.csv

foreach ($file in $files | where {$_.service -eq "monitoring"})
{
    $filename = '{0}{1}\media\{2}'  -f $filebase,$file.service,$file.fullname
    $filename
    remove-item -path $filename
}


<#
$folders = Get-ChildItem -Path ('{0}{1}\media'  -f $filebase,$file.service,$file) | ?{ $_.PSIsContainer }

foreach ($folder in $folders)
{
    '{0} {1}'  -f $folder.FullName,(Get-ChildItem -Path $folder.FullName).count
}
#>