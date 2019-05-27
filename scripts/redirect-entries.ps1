$articles = gc('C:\Users\bwren\Git\bwren\docs\articles-monitoring.csv') | ConvertFrom-Csv

$redirect = New-Object PSObject
$redirect | Add-Member -NotePropertyName source_path -NotePropertyValue ""
$redirect | Add-Member -NotePropertyName redirect_url -NotePropertyValue ""
$redirect | Add-Member -NotePropertyName redirect_document_id -NotePropertyValue ""

foreach ($article in $articles)
{
    $redirect.source_path = 'articles/{0}' -f $article.OldArticle.Replace('\','/')
    $redirect.redirect_url = '/azure/{0}' -f $article.NewArticle.Replace('\','/').Replace('.md','')
    $redirect.redirect_document_id = $true

    ($redirect | ConvertTo-Json).replace("}","},")
}