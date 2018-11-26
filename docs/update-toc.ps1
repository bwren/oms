$baseFolder = 'C:\Users\bwren\Git\azure-docs-pr\articles'
$newFolder = 'azure-monitor'
$rootFolder = Join-Path -Path $baseFolder -ChildPath $newFolder
$articles = gc('C:\Users\bwren\Git\bwren\docs\articles-monitoring.csv') | ConvertFrom-Csv

$tocpath = Join-Path -Path $rootFolder -ChildPath "toc.yml"
$toc = gc($tocpath) -raw

foreach ($article in $articles)
{
    $oldpath = '../{0}?toc=/azure/azure-monitor/toc.json' -f $article.OldArticle.Replace('\','/')
    $newpath = $article.NewArticle.Replace("azure-monitor/","").Replace('\','/')
    $toc = $toc.Replace($oldpath, $newpath)
}

$toc | Set-Content $tocpath -NoNewline