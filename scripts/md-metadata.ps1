$articles = dir C:\Users\bwren\Git\azure-docs-pr\articles\azure-monitor\*.md -Recurse

$hash = @{}
$SubServiceCsv = Import-Csv -Path C:\users\bwren\Git\bwren\docs\subservice.csv
$SubServiceCsvHash = @{}
foreach ($row in $SubServiceCsv) { $SubServiceCsvHash[$row.LiveUrl]=$row.SubService }
#$SubServiceCsvHash


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

    $LiveUrl = $article.FullName.Replace("C:\Users\bwren\Git\azure-docs-pr\articles","https://docs.microsoft.com/en-us/azure").Replace('\','/').Replace('.md','')

    #if ($metadata['ms.service'] -ne 'azure-monitor') { $article.Name }
    if ($article.Name -match "container-insights") 
    {
        $metadata['ms.service'] = "azure-monitor"
        $metadata['author'] = "magoedte"
        $metadata['ms.author'] = "magoedte"

    }


    if ($metadata['ms.subservice'] -ne $SubServiceCsvHash[$LiveUrl])
    { 

        $oldMetadata = $articleTextRaw.Substring(0,$articleTextRaw.IndexOf('---',5))
        $newMetadata = "title: "         + $metadata['title'] + "`r`n" `
                     + "description: "   + $metadata['description'] + "`r`n" `
                     + "ms.service: "    + $metadata['ms.service'] + "`r`n" `
                     + "ms.subservice: " + $SubServiceCsvHash[$LiveUrl] + "`r`n" `
                     + "ms.topic: "      + $metadata['ms.topic'] + "`r`n" `
                     + "author: "        + $metadata['author'] + "`r`n" `
                     + "ms.author: "     + $metadata['ms.author'] + "`r`n" `
                     + "ms.date: "       + $metadata['ms.date'] + "`r`n" `
                     + "`r`n" `

        if ($metadata['ms.reviewer'].Length -gt 0) { $newMetadata += ("ms.reviewer: "  + $metadata['ms.reviewer'] + "`r`n") }
        if ($metadata['ms.custom'].Length -gt 0)   { $newMetadata += ("ms.custom: "  + $metadata['ms.custom'] + "`r`n") }
        

        $article.Name
        '|' + $metadata['ms.subservice'] + '|'
        '|' + $SubServiceCsvHash[$LiveUrl] + '|'
        '===='


        if ($articleCount -ge 10) { break }
        
        $oldBody = $articleTextRaw.Substring($articleTextRaw.IndexOf('#'))
        $newArticleText = "---`r`n" + $newMetadata + "---`r`n`r`n" + $oldBody

        set-content -Path $article.FullName -Value $newArticleText -NoNewline -Force

        #"---`r`n" + $newMetadata + "---`r`n`r`n"
        #$metadata['ms.subservice'] + ' - ' + $SubServiceCsvHash[$LiveUrl]
        $articleCount += 1


    }



        


        

        #if (($metadata['ms.subservice']).length -eq 0)
        #{
            #$articleCount += 1   
        #}

        <#
        foreach ($key in $metadata.Keys)
        {
            $h[$key] = "x"

            if ($key -notin "","title","description") 
                {$newMetadata += $key +': ' + $metadata[$key] + "`r`n"}
        }
        #>

        


        #if ($articleCount -ge 50) { break }
    #}
}

$articleCount




    #if (($metadata["ms.service"].Trim() -eq 'azure-monitor') -and ($metadata["ms.subservice"].Trim() -eq 'application-insights')) {
    #if ($metadata["ms.service"].Trim() -ne 'azure-monitor') {
    #if ($metadata["ms.topic"].Trim() -eq 'article') {
    #if ($metadata["author"].Trim() -eq 'MGoedtel') {
    #if (($metadata["ms.service"].Trim() -eq 'azure-monitor') -and ($metadata["ms.subservice"].Trim() -eq 'logs')) {

    #$articleCount += 1

    #if ($metadata["ms.service"].Trim() -eq 'log-analytics') { $metadata["ms.subservice"] = 'logs' }
    #if ($metadata["ms.service"].Trim() -eq 'application-insights') { $metadata["ms.subservice"] = 'application-insights' }

    #$metadata["services"] = ' azure-monitor'
    #$metadata["ms.service"] = ' azure-monitor'
    #if ($metadata['ms.topic'].trim() -eq "article") { $metadata['ms.topic'] = 'conceptual' }
    #if ($metadata['author'].trim() -eq "mgoedtel") { $metadata['author'] = 'MGoedtel' }
    #if ($metadata['ms.topic'].trim() -eq "article") { $article.Name + ' - ' + $metadata['ms.topic'] }


            <#
        foreach ($key in $metadata.Keys)
        {
            $h[$key] = "x"

            if ($key -notin "","title","description") 
                {$newMetadata += $key +': ' + $metadata[$key] + "`r`n"}
        }
        #>
