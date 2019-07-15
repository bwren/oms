$tocfilefolder = "azure-monitor" 
$tocfile = gc C:\Users\bwren\Git\azure-docs-pr\articles\$tocfilefolder\toc.yml
$services = @("azure-monitor","log-analytics","application-insights","monitoring-and-diagnostics","monitoring")
$outFile = "C:\Users\bwren\Git\bwren\docs\azure-monitor-articles.csv"

$toc = @{}
$path = ("","","","","","","","","","")
foreach ( $entry in $tocfile )
{

    if ($entry.Trim().StartsWith("-"))
    {

        $level = $entry.IndexOf("-") / 2 + 1
        $path[$level] = $entry.Split(":")[1].Trim()
        $section = ""
        for ($i=1;$i -le ($level-1); $i++) { $section += $path[$i] + "\"}
        $title = $path[$level]
        $tocpath = $section + $title
        $header = $path[1]

    }

    if ($entry.TrimStart().ToLower().StartsWith("href")) 
    { 

        $href = $entry.ToLower().Split("?")[0].Substring($entry.IndexOf("href")+6).TrimEnd()
        if ($href.EndsWith(".md"))
        {
            $name = $href.Substring($href.LastIndexOf("/")+1)
            $folder  = $href.Split("/")[1]
            $fullname = $folder + "/" + $name

            #$filepath = $href.Substring($href.IndexOf("/")+1)
            #if ($filepath.IndexOf("/") -eq -1) { $filepath = $tocfilefolder + "/" + $filepath }

            $toc.Add($href,$tocpath)
        
        }
    }

}


if (Test-Path $outFile) { Remove-Item $outFile }

$root = "C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\"
$articles = get-childitem -path (Join-Path -Path $root -ChildPath "*.md") -Recurse

foreach ($article in $articles) {

    $article.FullName

    $object = New-Object PSObject

    # File information
    #$object | Add-Member Noteproperty service $service

    $object | Add-Member Noteproperty filename $article.Name
    $object | Add-Member Noteproperty foldername $article.Directory.BaseName

    $fullpath = $article.FullName.Replace($root,"")

    $object | Add-Member Noteproperty path $fullpath.Substring(0,$fullpath.LastIndexOf("\"))
    $object | Add-Member Noteproperty fullpath $fullpath

    # TOC  information
    $tocpath = $toc[$fullpath.Replace("\","/")]
$fullpath
$tocpath
    $object | Add-Member Noteproperty tocheader $tocpath.Substring(0,$tocpath.IndexOf("\"))
    $object | Add-Member Noteproperty tocfolder $tocpath.Substring(0,$tocpath.LastIndexOf("\"))
    $object | Add-Member Noteproperty tocname $tocpath.Substring(0,$tocpath.IndexOf("\"))
    $object | Add-Member Noteproperty tocpath $tocpath

    $articleContent = gc $article

    # Metadata
    $metaIndex1 = [array]::indexof($articleContent,"---") + 1
    $metaIndex2 = [array]::indexof($articleContent,"---",$metaIndex1+1) - 1

    $metadata = @{}
    $articleContent[$metaIndex1..$metaIndex2] | foreach { $metadata += $_.Replace(":","=") | ConvertFrom-StringData  }

    $object | Add-Member Noteproperty title $metadata["title"]
    $object | Add-Member Noteproperty description $metadata["description"]
    $object | Add-Member Noteproperty services $metadata["services"] 
    $object | Add-Member Noteproperty documentationcenter $metadata["documentationcenter"]
    $object | Add-Member Noteproperty author $metadata["author"]
    $object | Add-Member Noteproperty manager $metadata["manager"]
    $object | Add-Member Noteproperty editor $metadata["editor"] 
    $object | Add-Member Noteproperty ms.assetid $metadata["ms.assetid"]
    $object | Add-Member Noteproperty ms.service $metadata["ms.service"]
    $object | Add-Member Noteproperty ms.workload $metadata["ms.workload"]
    $object | Add-Member Noteproperty ms.tgt_pltfrm $metadata["ms.tgt_pltfrm"]
    $object | Add-Member Noteproperty ms.devlang $metadata["ms.devlang"]
    $object | Add-Member Noteproperty ms.topic $metadata["ms.topic"]
    $object | Add-Member Noteproperty ms.date $metadata["ms.date"]
    $object | Add-Member Noteproperty ms.author $metadata["ms.author"]
    $object | Add-Member Noteproperty ms.component $metadata["ms.component"]

    $object | Export-Csv -Path $outFile -Append -Force
 
}