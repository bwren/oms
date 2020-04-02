
$token = ConvertTo-SecureString "714e6a1d848e2126f95c2dae57a3bfebabfc3706" -AsPlainText -Force


# All pull requests in the last month
$targetUpdatedDate = get-date "3/1/2020"
$lastUpdatedDate = get-date 
$prs = $null
$pageNumber = 1

do {
    $prpage = $null
    do  {
        $prpage = Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls?state=closed&sort=updated&direction=desc&page=$pageNumber" -Authentication OAuth -Token $token  
    } while ($null -eq $prpage)
    $lastUpdatedDate = $prpage[29].updated_at

    $prs += $prpage
    $pageNumber += 1

    $prpage[29].number
    $prs.Count
    $lastUpdatedDate

} while ($lastUpdatedDate -gt $targetUpdatedDate)


# Pull requests with azure-monitor articles
$prsam = @()
foreach ($pr in $prs)
{
    $prnumber = $pr.number
    $files = @()
    $files = Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls/$prnumber/files" -Authentication OAuth -Token $token
    foreach ($file in $files)
    {
        $includepr = $false
        if ($file.filename.IndexOf("azure-monitor") -gt 0 )
        {
            $includepr = $true
        }
    }

    if ($includepr -eq $true)
    {
        $prsam += $pr
        $prnumber.tostring() + " " + $prsam.count.tostring()
    }
}


$updatedFiles = @()
foreach ($pr in $prsam)
{
    $prnumber = $pr.number
    $files = Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls/$prnumber/files" -Authentication OAuth -Token $token

    $prnumber
    
    foreach ($file in $files)
    {
        if ($file.filename -match ".md")
        {
            $updatedFile = [PSCustomObject]@{
                Number = $pr.number
                Title  = $pr.title
                ClosedAt = $pr.closed_at
                User = $pr.user.login
                FileName = $file.filename
                Addition = $file.additions
                Delections = $file.deletions
                Changes = $file.changes
                Patch = $file.patch
            }
            $updatedFiles += $updatedFile
        }
    }
}

$updatedFiles | ConvertTo-Json | out-file "C:\Users\bwren\Microsoft\Carmon Mills Group - Azure security and management\Stats\March 2020\UpdatedArticles.json"

<#
if ($null -eq $prpage) {"no"} else {"yes"}

Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls?state=closed&page=3" -Authentication OAuth -Token $token | ft number, closed_at


Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls?state=closed&direction=desc&sort=updated&page=1" -Authentication OAuth -Token $token | ft number, closed_at
$prs | ft number,state

Invoke-RestMethod -Headers
$prs = Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls?state=closed&sort=updated&direction=desc&page=2" -Authentication OAuth -Token $token
$prs | ft number,state
$prs = Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls?state=closed&sort=updated&direction=desc&page=3" -Authentication OAuth -Token $token
$prs | ft number,state
$prs = Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls?state=closed&sort=updated&direction=desc&per_page=100&page=4" -Authentication OAuth -Token $token
$prs | ft number,state
$prs = Invoke-RestMethod -uri "https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls?state=closed&sort=updated&direction=desc&per_page=100&page=5" -Authentication OAuth -Token $token
$prs | ft number,state


$commits = Invoke-RestMethod -uri https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls/108473/commits -Authentication OAuth -Token $token

Invoke-RestMethod -uri https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/commits/0bddd0a0bece68919dae535672ca0944c82a5001 -Authentication OAuth -Token $token

$pr = Get-GitHubPullRequest -OwnerName MicrosoftDocs -RepositoryName azure-docs-pr -PullRequest 108473


$pr = Invoke-RestMethod -uri https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls/108473 -Authentication OAuth -Token $token
$commits = Invoke-RestMethod -uri $pr.commits_url -Authentication OAuth -Token $token
$files = Invoke-RestMethod -uri https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/pulls/108473/files -Authentication OAuth -Token $token

$commit = Invoke-RestMethod -uri https://api.github.com/repos/MicrosoftDocs/azure-docs-pr/commits/108473 -Authentication OAuth -Token $token


Add-Type -Path "C:\Users\bwren\Documents\WindowsPowerShell\Modules\AutomatedMetrics\Octokit.dll" 
$cred = New-Object octokit.credentials -ArgumentList "bwren", "714e6a1d848e2126f95c2dae57a3bfebabfc3706"
$inmem = new-object OctoKit.Internal.InMemoryCredentialStore -ArgumentList ($cred)
$header = New-Object octokit.productheadervalue -ArgumentList "azure-function"
New-Variable -Name gitHubClient -Scope Global -Option AllScope -Force -Value $(new-object octokit.githubclient -ArgumentList $header, $inmem) 
$pr = $gitHubClient.Repository.PullRequest.GetAllForRepository("MicrosoftDocs/azure-docs", 108743)


$gitHubClient.Repository.PullRequest.GetAllForRepository("MicrosoftDocs", "azure-docs")
$gitHubClient.Repository.PullRequest | Get-Member | Format-Table -Wrap
#>