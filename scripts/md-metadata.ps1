$articles = dir C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\*.md -Recurse

$h = @{}
$articleCount = 0
foreach ($article in $articles)
{
    $articleText = gc $article
    $articleTextRaw = gc $article -Raw

    $metadata = @{}
    for ($line=1; $line -lt $articleText.Length; $line++)
    {
        if ($articleText[$line] -eq '---') { break }
        if ($articleText[$line].split(":")[1].Length -gt 0) 
            { $metadata[$articleText[$line].split(":")[0]] = $articleText[$line].split(":")[1].Trim() }
        else
            { $metadata[$articleText[$line].split(":")[0]] = "" }
    }

    #if (($metadata["ms.service"].Trim() -eq 'azure-monitor') -and ($metadata["ms.subservice"].Trim() -eq 'application-insights')) {
    #if ($metadata["ms.service"].Trim() -ne 'azure-monitor') {
    if ($metadata["ms.topic"].Trim() -eq 'article') {
    #if ($metadata["author"].Trim() -eq 'MGoedtel') {
    #if (($metadata["ms.service"].Trim() -eq 'azure-monitor') -and ($metadata["ms.subservice"].Trim() -eq 'logs')) {

        $articleCount += 1

        if ($metadata["ms.service"].Trim() -eq 'log-analytics') { $metadata["ms.subservice"] = 'logs' }
        if ($metadata["ms.service"].Trim() -eq 'application-insights') { $metadata["ms.subservice"] = 'application-insights' }

        $metadata["services"] = ' azure-monitor'
        $metadata["ms.service"] = ' azure-monitor'
        if ($metadata['ms.topic'].trim() -eq "article") { $metadata['ms.topic'] = 'conceptual' }
        if ($metadata['author'].trim() -eq "mgoedtel") { $metadata['author'] = 'MGoedtel' }
        if ($metadata['ms.topic'].trim() -eq "article") { $article.Name + ' - ' + $metadata['ms.topic'] }


        $oldMetadata = $articleTextRaw.Substring(0,$articleTextRaw.IndexOf('---',5))
        #$oldMetadata

        $newMetadata = "title: "         + $metadata['title'] + "`r`n" `
                     + "description: "   + $metadata['description'] + "`r`n" `
                     + "ms.service: "    + $metadata['ms.service'] + "`r`n" `
                     + "ms.subservice: " + $metadata['ms.subservice'] + "`r`n" `
                     + "ms.topic: "      + $metadata['ms.topic'] + "`r`n" `
                     + "author: "        + $metadata['author'] + "`r`n" `
                     + "ms.author: "     + $metadata['ms.author'] + "`r`n" `
                     + "ms.date: "       + $metadata['ms.date'] + "`r`n" `
                     + "`r`n" `

        if ($metadata['ms.reviewer'].Length -gt 0) { $newMetadata += ("ms.reviewer: "  + $metadata['ms.reviewer'] + "`r`n") }
        if ($metadata['ms.custom'].Length -gt 0)   { $newMetadata += ("ms.custom: "  + $metadata['ms.custom'] + "`r`n") }


        <#
        foreach ($key in $metadata.Keys)
        {
            $h[$key] = "x"

            if ($key -notin "","title","description") 
                {$newMetadata += $key +': ' + $metadata[$key] + "`r`n"}
        }
        #>

        #"---`r`n" + $newMetadata + "---`r`n`r`n"
    

        #$metadata

        $oldBody = $articleTextRaw.Substring($articleTextRaw.IndexOf('#'))
        $newArticleText = "---`r`n" + $newMetadata + "---`r`n`r`n" + $oldBody

        #$article.Name + ' - ' + $metadata['ms.topic'] + ' - ' + $metadata['author']

        #$newArticleText
        #set-content -Path $article.FullName -Value $newArticleText -NoNewline -Force

        #if ($articleCount -ge 50) { break }
    }
}

  $articleCount
    

