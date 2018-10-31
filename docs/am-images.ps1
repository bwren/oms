$rootfolder = "C:\Users\bwren\Git\azure-docs-pr\articles\"
$services = @("azure-monitor","log-analytics","application-insights","monitoring-and-diagnostics","monitoring")

foreach ($service in $services)
{
    $images = get-childitem -path C:\Users\bwren\Git\azure-docs-pr\articles\$service\*.png -Recurse
    foreach ($image in $images)
    {
        '{0},{1},{2}' -f $service,$image.Directory.Name,$image.Name
    }
}

