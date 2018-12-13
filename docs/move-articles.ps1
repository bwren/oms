$baseFolder = 'C:\Users\bwren\Git\azure-docs-pr\articles'
$newFolder = 'azure-monitor'
$rootFolder = Join-Path -Path $baseFolder -ChildPath $newFolder
$articles = gc('C:\Users\bwren\Git\bwren\docs\articles-monitoring.csv') | ConvertFrom-Csv


New-Item -Path $rootFolder -Name "platform" -ItemType "directory"
New-Item -Path $rootFolder -Name "insights" -ItemType "directory"
New-Item -Path (Join-Path -Path $rootFolder -ChildPath "insights") -Name "app" -ItemType "directory"


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


########################### Move articles and images

foreach ($article in $articles)
{

    ## Move article
    "Move-Item -Path {0} -Destination {1}" -f  $article.OldFile, $article.NewFile
    Move-Item -Path $article.OldFile -Destination $article.NewFile

    ## Move images
    if (Test-Path $article.OldMediaFolder) {
        if (-not (Test-Path $article.NewMediaFolder))
        {
            'New-Item  -Path {0} -Name {1} -ItemType "directory"' -f (Split-Path $article.NewMediaFolder -parent), (Split-Path $article.NewMediaFolder -leaf)
            New-Item  -Path (Split-Path $article.NewMediaFolder -parent) -Name (Split-Path $article.NewMediaFolder -leaf) -ItemType "directory"
        }

        $images = Get-ChildItem -Path $article.OldMediaFolder
        foreach ($image in $images)
        {
            "Move-Item -Path {0} -Destination {1}" -f  $image.FullName, $article.NewMediaFolder 
            Move-Item -Path $image.FullName -Destination $article.NewMediaFolder 
        }
    }
}


########################### Update moved articles

$linkedArticles = $articles
foreach ($article in $articles)
{
    $articleText = gc $article.NewFile -Raw


    ## Update links in the moved articles to other moved articles
    foreach ($linkedArticle in $linkedArticles)
    {
        $articletext = $articletext.Replace($linkedArticle.OldFileName,$linkedArticle.NewFileName)
    }

    ## If the article moved to a deeper level, add ../
    $levels = $article.NewArticle.Split('\').Count - $article.OldArticle.Split('\').Count

    if ($levels -gt 0 )
    {
        $pathPrefix = "../"
        for ($i=0;$i -lt $levels; $i++) { $pathPrefix += "../" } 

        $articletext = $articletext.Replace("../",$pathPrefix)
    }

    ## Update media links to new article name
    $articletext = $articletext.Replace($article.OldMediaLink,$article.NewMediaLink)

    ## Update links to articles in old folder
    $folderArticles = Get-ChildItem $article.OldFolder -Filter *.md

    foreach ($folderArticle in $folderArticles)
    {
        if ($articleText.IndexOf($folderArticle.name) -gt 0)
        {
            '{0}: {1}: {2}' -f  $article.NewArticle, $folderArticle.name, ('{0}{1}/{2}' -f $pathPrefix, (Split-Path -Path $folderArticle.Directory -leaf), $folderArticle.Name)
            $articleText = $articleText.Replace($folderArticle.name, ('{0}{1}/{2}' -f $pathPrefix, (Split-Path -Path $folderArticle.Directory -leaf), $folderArticle.Name))
        }            
    }
    
    ## Save the article
    $articletext | Set-Content $article.NewFile -NoNewline
}


########################### Update articles in old folders

## Update links to articles in old folder to add path
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
                '{0}: {1}: {2}' -f  $folderArticle.FullName, $movedArticle.OldFileName, ('../{0}' -f $movedArticle.NewArticle)
                $articleText = $articleText.Replace($movedArticle.OldFileName, ('../{0}' -f $movedArticle.NewArticle.Replace('\','/')))
                $articletext | Set-Content $folderArticle.FullName -NoNewline
            }
        }
    }
}




########################### Update articles for other services

## for all articles update links to moved articles

$allArticles = Get-ChildItem $baseFolder -Filter *.md -Recurse
$allArticles.Count

foreach ($allArticle in $allArticles)
{
    #if ($allArticle.FullName.IndexOf("log-analytics") -gt 0) { '****** {0}' -f $allArticle.FullName }
    $allArticleText = gc $allArticle.FullName -Raw
    foreach ($article in $articles)
    {
        if ($allArticleText.IndexOf($article.OldArticle.replace('\','/')) -gt 0)
        {
            '{0}\{1}: {2}: {3}' -f  (Split-Path $allArticle.Directory -leaf), $allArticle.Name, $article.OldArticle, $article.NewArticle
            $allArticleText = $allArticleText.Replace($article.OldArticle, $article.NewArticle.replace('\','/'))
            $allArticleText = $allArticleText.Replace($article.OldArticle.replace('\','/'), $article.NewArticle.replace('\','/'))
            $allArticleText | Set-Content $allArticle.FullName -NoNewline
        }     
    }
}




# Azure Monitor move - Monitoring and Diagnostics articles 01

# This PR includes 9 articles being moved with 35 images. There should be about 40 other articles here that only include updated links to the moved articles. There are no changes to actual content.
