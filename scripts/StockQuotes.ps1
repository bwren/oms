param (
    [Parameter (Mandatory=$false)]
    [string[]] $symbols = ('MSFT','AAPL','INTC','GOOG'),

    [Parameter (Mandatory=$false)]
    [string] $customerId,

    [Parameter (Mandatory=$true)]
    [string] $sharedKey
)

$logType = "Stocks"
$fields = "sl1d1t1c1ohgv"
$uri = "http://finance.yahoo.com/d/quotes.csv?s=" + ($symbols -join '+') + "&f=$fields&e=.csv"

Write-Verbose "Symbols: $symbols"


try {
    $response = Invoke-RestMethod -Uri $uri
}
Catch
{
    $ErrorMessage = $_.Exception.Message
	Write-Error "Error retrieving quotes: $ErrorMessage"
    Exit
}

$header = "Symbol","LastTrade","LastTradeDate","LastTradeTime","Change","Open","DayHigh","DayLow","Volume"

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
        Symbol = [string]$quote.Symbol
        LastTrade = [Single]$quote.LastTrade
        Change = [Single]$quote.Change
        Open = [Single]$quote.Open
        DayHigh = [Single]$quote.DayHigh
        DayLow = [Single]$quote.DayLow
        Volume = [Single]$quote.Volume
        LastTradeDateTime = (Get-Date -Date ($quote.LastTradeDate + ' ' + $quote.LastTradeTime)).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    }

    Write-Verbose "Quote: $d"
    $data += $d 

}


$body = ConvertTo-Json  $data 
Write-Verbose "Body: $body"

try {
    #Send-OMSAPIIngestionFile -customerId $customerId -sharedKey $sharedKey -body $body -logType $logType -TimeStampField LastTradeDateTime 
}
Catch
{
    $ErrorMessage = $_.Exception.Message
	Write-Error "Error submitting data: $ErrorMessage"
    Exit
}