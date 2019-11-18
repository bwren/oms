$tables = Import-Csv -Path "C:\Users\bwren\Git\bwren\docs\tables.csv" | where {$_.Priority -eq 1}
$properties = Import-Csv -Path "C:\Users\bwren\Git\bwren\docs\properties.csv"
$repoPath = "C:\Users\bwren\Git\azure-reference-other-pr\azure-monitor-ref\tables"

$files = $true
$toc = $false

if ($files) {

    $wc = New-Object System.Net.WebClient 

    foreach ($table in $tables)
    {
        $table.'Table Name' + "====================================="

        $articleText = gc C:\Users\bwren\Git\bwren\docs\template-table.md -raw

        $articleText = $articleText.Replace("<meta-title>","Azure Monitor Logs reference - {0}" -f $table.'Table Name')
        $articleText = $articleText.Replace("<meta-description>","Reference for {0} table in Azure Monitor Logs." -f $table.'Table Name')
        $articleText = $articleText.Replace("<meta-date>",(Get-Date).ToString("MM/dd/yyyy"))

        $articleText = $articleText.Replace("<Header>","{0} table" -f $table.'Table Name')

        $articleText = $articleText.Replace("<Description>","{0}" -f $table.'Description ')

        $propertiesText = ""

        $propertiesText += "| Property | Type | Description |`r`n"
        $propertiesText += "|:---|:---|:---|`r`n"

        foreach ($property in ($properties | where {$_.TableName -eq $table."Table Name"}))
        {
            $propertiesText += "| {0} | {1} | {2} |`r`n" -f $property.ColumnName, $property.ColumnType, $property.Description
        }
    
        $articleText = $articleText.Replace("<Properties>",$propertiesText)

        $linkTitleText = ""
        if ($table.Link.Length -gt 0) {
            $data = $wc.downloadstring($table.Link) 
            $title = [regex] '(?<=<title>)([\S\s]*?)(?=</title>)' 
            $linkTitleText = $title.Match($data).value.Replace("| Microsoft Docs","").trim()

            $linkText = "[{0}]({1})`r`n" -f $linkTitleText, $table.Link
            $articleText = $articleText.Replace("<Link>",$linkText)
        
            $table.Link
            $linkText
        }
        else { $linkText = "" }

        #$articleText
        New-Item -Path $repoPath -Name ($table.'Table Name' + '.md') -ItemType "file" -Value $articleText -Force
    }
}

if ($toc) {

    $tocText = ""
    foreach ($table in $tables) {
        $tocText += "  - name: {0}`r`n" -f $table.'Table Name'
        $tocText += "    href: tables/{0}.md`r`n" -f $table.'Table Name'
    }

    $tocText
}