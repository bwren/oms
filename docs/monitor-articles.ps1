$root = "c:\users\bwren\git\azure-docs-pr\articles"

<#
foreach ($service in ($root | get-childitem -Directory))
{
    $service.name
    foreach ($article in ($service.FullName | get-childitem -filter "*.md" -Recurse))
    {
        $articleText = gc $article.FullName -raw
        if ($articleText.IndexOf("azure-monitor") -gt 0)
        {
            $service.name + " | " + $article.fullname
        }
    }
}
#>

$tocs = $root | Get-ChildItem -Filter toc.yml -Recurse
foreach ($toc in $tocs)
{
    foreach ($line in (gc $toc))
    {
        if (($line.ToString()).IndexOf("monitor") -gt 0)
        {
            $toc
            $line.ToString()
        }
        
    }
}