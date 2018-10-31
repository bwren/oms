$articles = get-childitem -path C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\*.md -Recurse
$articles += get-childitem -path C:\Users\bwren\Git\azure-docs-pr\articles\monitoring\*.md -Recurse
$articles += get-childitem -path C:\Users\bwren\Git\azure-docs-pr\articles\log-analytics\*.md -Recurse
$articles += get-childitem -path C:\Users\bwren\Git\azure-docs-pr\articles\application-insights\*.md -Recurse
$articles += get-childitem -path C:\Users\bwren\Git\azure-docs-pr\articles\monitoring-and-diagnostics\*.md -Recurse

$toc = gc C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\toc.yml

foreach ($article in $articles)
{
    
    if (($toc | Select-String $article.Name -Quiet) -ne $true) {$article.Name}

}
