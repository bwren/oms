$baseFolder = 'C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor'
$articles = Get-ChildItem $baseFolder -Filter *.md -Recurse

$terms = "log analytics", "metrics explorer", "management solution", "azure monitor query language", "log analytics query language", "kusto"

$output = @()
foreach ($article in $articles)
{
    $articleText = gc $article.FullName

    $linenumber = 0
    foreach ($line in $articletext)
    {
        $linenumber += 1
        foreach ($term in $terms)
        {
            if ($line.tolower().indexof($term) -gt 0)
            {
                $lineoutput = New-Object PSObject
                $lineoutput | Add-Member Noteproperty Article    $article.FullName.Replace($baseFolder,"")
                $lineoutput | Add-Member Noteproperty LineNumber $linenumber
                $lineoutput | Add-Member Noteproperty Term       $term
                $lineoutput | Add-Member Noteproperty Line       $line
                $output += $lineoutput
            }
        }
    }
}

#$output | Export-Csv -Path 'C:\Users\bwren\Git\bwren\docs\rebrand.csv'
