$toc = gc C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\toc.yml
#$outFile = "C:\Users\bwren\Git\bwren\docs\azure-monitor-toc.csv"

#if (Test-Path $outFile) { Remove-Item $outFile }

$path = ("","","","","","","","","","")
foreach ( $entry in $toc )
{

    if ($entry.Trim().StartsWith("-"))
    {

        $level = $entry.IndexOf("-") / 2 + 1
        $path[$level] = $entry.Split(":")[1].Trim()
        $section = ""
        for ($i=1;$i -le ($level-1); $i++) { $section += $path[$i] + "\"}
        $title = $path[$level]
        $fullpath = $section + $title
        $header = $path[1]

    }

    if ($entry.TrimStart().ToLower().StartsWith("href")) 
    { 
        $article = New-Object PSObject

        $href = $entry.ToLower().Split("?")[0].Substring($entry.IndexOf("href")+6)
        if ($href.Trim().EndsWith(".md"))
        {
            $name = $href.Substring($href.LastIndexOf("/")+1)
            $folder  = $href.Replace($name,"") #$href.Split("/")[1]
        }
        else 
        {
            $name = $href.trim()
        }
        
        $article | Add-Member Noteproperty name    $name.Replace(".md","").Replace("yml","")
        $article | Add-Member Noteproperty section $section

        #$article | Add-Member Noteproperty href    $href
        #$article | Add-Member Noteproperty header  $header
        #$article | Add-Member Noteproperty path    $fullpath
        #$article | Add-Member Noteproperty title   $title
        #$article | Add-Member Noteproperty folder  $folder
        
        #$article #| Export-Csv -Path $outFile -Append

        '"' + $article.name + '","' + $article.section + '",'

    }

}