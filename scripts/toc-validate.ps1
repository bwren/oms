$toc = gc C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\toc.yml -Raw
$articles = dir C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\*.md -Recurse

foreach ($article in $articles)
{
    $shortName = $article.fullname.replace("C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\","").replace("\","/")
    $index =  $toc.IndexOf($shortName)
    if ($index -eq -1 ) { $shortName }
}