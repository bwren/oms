$service = "log-analytics"
$filebase = "c:\users\bwren\git\azure-docs-pr\articles\"
$links = Import-Csv .\am-links-articles.csv

$files = $links | where {$_.service.trim() -eq $service} | group file
#$files | Add-Member -NotePropertyName "filepath" -NotePropertyValue ""
#foreach ($file in $files) { $file.filepath = (Join-Path -Path $file.folder.trim() -ChildPath $file.file ) }

$redirects = gc -raw "C:\Users\bwren\Git\azure-docs-pr\.openpublishing.redirection.json" | ConvertFrom-Json

foreach ($filename in $files)
{
    $filelinks = $links | where {$_.file -eq $filename.Name}
    if (Test-Path (Join-Path -Path $filelinks[0].folder.trim() -ChildPath $filename.Name))
    {
        $file = Get-Item (Join-Path -Path $filelinks[0].folder.trim() -ChildPath $filename.Name)
        $file
        foreach ($filelink in $filelinks)
        {
            if ($filelink.link.StartsWith("..")) {$link = (join-path -Path (Split-Path -Path $file.DirectoryName -Parent) -ChildPath $filelink.link.replace("..",""))  }
            else {$link = (join-path -Path $file.DirectoryName -ChildPath $filelink.link.replace("./","").replace(".\",""))  }
            $linksearch = (join-path -path "articles\" -childpath $link.tolower().Replace($filebase,"")).replace("\","/")
            
            #'{0} {1}' -f  $filelink.link, $linksearch
            $linksearch
            $fileredirects = $redirects.redirections | where {$_.source_path -eq  $linksearch}

            foreach ($fileredirect in $fileredirects)
            {
                #"======================="
                "link: " + $filelink.link

                $redirectfile =  '{0}.md' -f (Split-Path -Path $fileredirect.redirect_url -Leaf)
                $redirectfolder = Split-Path (Split-Path -Path $fileredirect.redirect_url -Parent) -Leaf

                $fileredirect.redirect_url
                $redirectfile
                $redirectfolder
                $filefolder = Split-Path -Path $file.DirectoryName -Leaf

                if ($fileredirect.redirect_url.ToLower().IndexOf("http") -ge 0) {$fileredirect.redirect_url} 
                elseif ($redirectfolder -eq $filefolder) {$newlink = $redirectfile}
                else {$newlink = '../{0}/{1}' -f $redirectfolder, $redirectfile}

                "new link: " + $newlink

                (Get-Content $file.FullName).replace($filelink.link, $newlink) | Set-Content $file.FullName
            }
        }
    }
}
