$service = "monitoring-and-diagnostics"
$filebase = "C:\users\bwren\Git\azure-docs-pr\articles\"
$links = Import-Csv C:\Users\bwren\Git\bwren\scripts\am-links.csv

$files = $links | where {$_.service.trim() -eq $service} | group file

foreach ($filename in $files)
{
    $filelinks = $links | where {$_.file -eq $filename.Name}
    $file = Get-Item (Join-Path -Path $filelinks[0].folder.trim() -ChildPath $filename.Name)
    $mediafolder = '{0}\media\{1}' -f $filelinks[0].folder.trim(), $file.Name.Replace(".md","")

    "========"
    $file.Name
    'Media:  {0}' -f $mediafolder

    foreach ($filelink in $filelinks)
    {
        $oldimage = Join-Path -Path ('{0}{1}' -f $filebase,$service) -ChildPath $filelink.link
        if (-not (Test-Path $mediafolder)) 
        { 
            'Creating new media folder {0}' -f $mediafolder
            New-Item  -Path (Split-Path $mediafolder -parent) -Name (Split-Path $mediafolder -leaf) -ItemType "directory"
        }
        $newimage = Join-Path -Path $mediafolder.trim() -ChildPath (Split-Path $filelink.medianame -leaf)

        $imagefile = Get-Item $oldimage        
        $newlink  = 'media/{0}/{1}' -f $file.Name.trim().Replace(".md",""),$imagefile.Name

        Copy-Item -Path $oldimage -Destination $newimage

        'Old image:  {0}' -f $oldimage
        'New image:  {0}' -f $newimage
        'New link:   {0}' -f $newlink

        (Get-Content $file.FullName).replace($filelink.link, $newlink) | Set-Content $file.FullName

    }

    #$article
}


