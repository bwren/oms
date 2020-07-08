#$issues = Get-GitHubIssue -Uri https://github.com/MicrosoftDocs/azure-docs -State All -IgnorePullRequests -Since ([datetime]"6/1/2020")

foreach ($issue in $issues)
{
    if ($issue.body.indexof("#### Document Details") -gt 0 )
    {
        $ContentStart = $issue.body.IndexOf("Content Source: ")
        $ContentEnd = $issue.body.IndexOf(")",$ContentStart) #IndexOf([char]10,$ContentStart)l
        $ServiceStart = $issue.body.IndexOf("Service: ")
        $ServiceEnd = $issue.body.IndexOf("**", $ServiceStart+12)

        if ($ServiceStart -gt 0) {

            $Content = $issue.body.Substring($ContentStart,$ContentEnd-$ContentStart+1).Replace("Content Source:","").Trim()
            $Service = $issue.body.Substring($ServiceStart,$ServiceEnd-$ServiceStart).Replace("Service:","").Replace("**","").Trim()

            if ($Service -eq "azure-monitor") {
                #"==============================="
                #$issue.body
                #$issue.body.Leng1th
                #$Content
                #$ServiceStart
                #$ServiceEnd
                #$Service

                $issueObject = New-Object -TypeName psobject
                $issueObject | Add-Member -MemberType NoteProperty -Name "CreatedAt" -Value $issue.created_at
                $issueObject | Add-Member -MemberType NoteProperty -Name "Assignee" -Value $issue.assignee.login
                $issueObject | Add-Member -MemberType NoteProperty -Name "Url" -Value $issue.html_url
                $issueObject | Add-Member -MemberType NoteProperty -Name "Title" -Value $issue.title
                #$issueObject | Add-Member -MemberType NoteProperty -Name "Service" -Value $Service
                $issueObject | Add-Member -MemberType NoteProperty -Name "Content" -Value $Content

                #$issueObject | Export-Csv 'C:\Users\bwren\git\bwren\docs\GitHubIssues.csv' -Append
                $issueObject | Export-Csv  'C:\Users\bwren\git\bwren\docs\GitHubIssues2006.csv' -Append 
                #"{0},{1},{2},{3},{4},{5}" -f $issue.created_at, $issue.assignee, $issue.html_url, $issue.title, $Service, $Content
            }
        } 
    }
}



<#
#### Document Details

⚠ *Do not edit this section. It is required for docs.microsoft.com ➟ GitHub issue linking.*

* ID: ac149cc8-9751-81aa-98b1-17d6b383ce50
* Version Independent ID: f09f1038-5787-8663-54e6-afe600bdccc8
* Content: [Consistency levels and Azure Cosmos DB APIs](https://docs.microsoft.com/en-us/azure/cosmos-db/consistency-levels-across-apis)
* Content Source: [articles/cosmos-db/consistency-levels-across-apis.md](https://github.com/Microsoft/azure-docs/blob/master/articles/cosmos-db/consistency-levels-across-apis.md)
* Service: **cosmos-db**
* GitHub Login: @markjbrown
* Microsoft Alias: **mjbrown**
#>