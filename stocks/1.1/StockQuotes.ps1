$VerbosePreference = "Continue"

$customerId = Get-AutomationVariable -Name 'Stocks-WorkspaceID'
$sharedKey  = Get-AutomationVariable -Name 'Stocks-WorkspaceKey'

$logType = "StockQuote"
$fields = "sl1d1t1c1p2ohgvp"
$symbols = Get-AutomationVariable -Name 'Stocks-SymbolList'
Write-Verbose "Symbols: $symbols"

$uri = "http://finance.yahoo.com/d/quotes.csv?s=" + ($symbols -join '+') + "&f=$fields&e=.csv"

try {
    $response = Invoke-RestMethod -Uri $uri
    Write-Verbose "response: $response"
}
Catch
{
    $ErrorMessage = $_.Exception.Message
	Write-Error "Error retrieving quotes: $ErrorMessage"
    Exit
}

$header = "Symbol","LastTrade","LastTradeDate","LastTradeTime","Change", "PercentChange","Open","DayHigh","DayLow","Volume","PreviousClose"

try {
    $quotes = ConvertFrom-Csv -InputObject $response -Header $header
}
Catch
{
    Write-Error $Error[0].Exception.Message
    Exit
}


$data = @()
foreach ($quote in $quotes)
{
    $d = New-Object PSObject -Property @{
        Symbol =        [string]$quote.Symbol
        LastTrade =     [Single]$quote.LastTrade
        Change =        [Single]$quote.Change
        PercentChange = [single]$quote.PercentChange.Replace("%","")/100
        Open =          [Single]$quote.Open
        DayHigh =       [Single]$quote.DayHigh
        DayLow =        [Single]$quote.DayLow
        Volume =        [Single]$quote.Volume
        PreviousClose = [Single]$quote.PreviousClose
        LastTradeDate = [String]$quote.LastTradeDate
        LastTradeTime = [String]$quote.LastTradeTime
        LastTradeDateTime = ((Get-Date -Date ($quote.LastTradeDate + ' ' + $quote.LastTradeTime)).AddHours(5)).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    }

    Write-Verbose "Quote: $d"
    $data += $d 

}


$body = ConvertTo-Json  $data 
Write-Verbose "Body: $body"

try {
    Send-OMSAPIIngestionFile -customerId $customerId -sharedKey $sharedKey -body $body -logType $logType -TimeStampField LastTradeDateTime 
}
Catch
{
    $ErrorMessage = $_.Exception.Message
	Write-Error "Error submitting data: $ErrorMessage"
    Exit
}
