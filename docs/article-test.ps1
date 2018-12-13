$articles = gc('C:\Users\bwren\Git\bwren\docs\articles-monitoring.csv') | ConvertFrom-Csv
$baseFolder = 'C:\Users\bwren\Git\azure-docs-pr\articles'

$articles | ForEach-Object { 
    #$_.OldArticle = $_.OldArticle.Replace('\','/')
    #$_.NewArticle = $_.NewArticle.Replace('\','/')

    $_ | Add-Member -NotePropertyName OldFolderName -NotePropertyValue $_.OldArticle.Split('\')[0] 
    $_ | Add-Member -NotePropertyName OldFileName -NotePropertyValue $_.OldArticle.Split('\')[1]
    $_ | Add-Member -NotePropertyName NewFolderName -NotePropertyValue (Split-Path -Path $_.NewArticle -parent)
    $_ | Add-Member -NotePropertyName NewFileName -NotePropertyValue (Split-Path -Path $_.NewArticle -leaf)

    $_ | Add-Member -NotePropertyName OldFolder -NotePropertyValue (Join-Path -Path $baseFolder -ChildPath $_.OldFolderName)
    $_ | Add-Member -NotePropertyName OldMediaFolder -NotePropertyValue (Join-Path -Path ('{0}\{1}' -f $_.OldFolder,"media") -ChildPath ([io.path]::GetFileNameWithoutExtension($_.OldFileName)))
    $_ | Add-Member -NotePropertyName OldFile -NotePropertyValue (Join-Path -Path $_.OldFolder -ChildPath $_.OldFileName)

    $_ | Add-Member -NotePropertyName NewFolder -NotePropertyValue (Join-Path -Path $baseFolder -ChildPath $_.NewFolderName)
    $_ | Add-Member -NotePropertyName NewMediaFolder -NotePropertyValue (Join-Path -Path ('{0}\{1}' -f $_.NewFolder,"media") -ChildPath ([io.path]::GetFileNameWithoutExtension($_.NewFileName)))
    $_ | Add-Member -NotePropertyName NewFile -NotePropertyValue (Join-Path -Path $_.NewFolder -ChildPath $_.NewFileName)

    $_ | Add-Member -NotePropertyName OldLink -NotePropertyValue ('../{0}/{1}' -f $_.OldFolderName, $_.OldFileName)
    $_ | Add-Member -NotePropertyName NewLink -NotePropertyValue ('../{0}/{1}' -f $_.NewFolderName, $_.NewFileName).Replace('\','/')
    $_ | Add-Member -NotePropertyName OldMediaLink -NotePropertyValue ('{0}/{1}' -f "media", ([io.path]::GetFileNameWithoutExtension($_.OldFileName)))
    $_ | Add-Member -NotePropertyName NewMediaLink -NotePropertyValue ('{0}/{1}' -f "media", ([io.path]::GetFileNameWithoutExtension($_.NewFileName)))

}




$oldfoldercount = 0
$oldarticlesHash = @{}
$folders = $articles | group OldFolder
foreach ($folder in $folders.Name)
{
    $folderArticles = Get-ChildItem $folder -Filter *.md
    $movedArticles = $articles | where {$_.OldFolder -eq $folder}

    foreach ($folderArticle in $folderArticles)
    {
        $articleText = gc $folderArticle.FullName -Raw

        foreach ($movedArticle in $movedArticles)
        {
            if ($articleText.IndexOf($movedArticle.OldFileName) -gt 0)
            {
                if ($oldarticlesHash[$folderArticle.FullName]) {$oldarticlesHash[$folderArticle.FullName] += 1 }
                else {$oldarticlesHash += @{$folderArticle.FullName=1}}
                $oldfoldercount += 1
            }
        }
    }
}


$allfoldercount = 0
$allarticlesHash = @{}
$allArticles = Get-ChildItem $baseFolder -Filter *.md -Recurse

foreach ($allArticle in $allArticles)
{
    #if ($allArticle.FullName.IndexOf("log-analytics") -gt 0) { '****** {0}' -f $allArticle.FullName }
    $allArticleText = gc $allArticle.FullName -Raw
    foreach ($article in $articles)
    {
        if ($allArticleText.IndexOf($article.OldArticle.replace('\','/')) -gt 0)
        {
            if ($allarticlesHash[$allArticle.FullName]) {$allarticlesHash[$allArticle.FullName] += 1 }
            else {$allarticlesHash += @{$allArticle.FullName=1}}
            $allfoldercount += 1
        }     
    }
}

$imagecount = 0
foreach ($article in $articles)
{

    if (Test-Path $article.OldMediaFolder) {
        $images = Get-ChildItem -Path $article.OldMediaFolder
        $imagecount += $images.count
    }
}



#Check if any missing

foreach ($article in $articles)
{
    if (test-path $article.OldFile) { write-host  $article.OldFile, (test-path $article.OldFile) }
    else { write-host  $article.OldFile, (test-path $article.OldFile) -ForegroundColor red }
}

$imagecount
$oldarticlesHash.count
$allarticlesHash.count
$articles.Count

$imagecount + $oldarticlesHash.count + $allarticlesHash.count + $articles.Count