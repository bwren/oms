param ( 
    [Parameter(Mandatory=$true)]
    [string]$scheduleName,

    [Parameter(Mandatory=$true)]
    [bool]$enable
)

$ResourceGroupName = Get-AutomationVariable -Name 'Stocks-AutomationResourceGroup'
$AutomationAccountName = Get-AutomationVariable -Name 'Stocks-AutomationAccountName'


Write-Verbose "Logging into Azure"
$Conn = Get-AutomationConnection -Name AzureRunAsConnection 
try {
    Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Error "Error logging into Azure: $ErrorMessage"
    Exit
}


Write-Verbose "Selecting Azure subscription"
try {
    Select-AzureRmSubscription -SubscriptionId $Conn.SubscriptionID -TenantId $Conn.tenantid
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Error "Error selecting Azure subscription: $ErrorMessage"
    Exit
}

Write-Verbose "Setting isEnabled on $ScheduleName to $enable"
Set-AzureRmAutomationSchedule -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Name $scheduleName -IsEnabled $enable