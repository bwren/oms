# Stocks sample solution

This is a [management solution](https://docs.microsoft.com/azure/operations-management-suite/operations-management-suite-solutions-creating) designed as a sample for learning how to create solutions for Operations Management Suite.  

## What does it do?
The solution collects stock quotes from a public web service.  This obviously isn't a management scenario that OMS was designed to solve in your production environment, but it is effective for illustrating some core concepts that are used by production solutions. 

This sample includes various resources common to many solutions including the following:

- Azure Automation runbook that collects data and writes to Log Analytics repository.
- Azure Automation schedules to automatically start runbooks.
- Azure Automation variables to store values used by runbooks
- Log Analytics saved search to return collected data.
- Log Analytics saved search to analyze collected data.
- Log Analytics alert to send a notification.

## Any prerequisites?
The only prerequisite for installing this solution is a linked OMS workspace and Automation account.  You can link an Automation account to a workspace by going to the Solutions Gallery in the OMS portal for the workspace and configuring the Automation & Control offering.

## How do I install it?
The parameters file includes sample values for the parameters used by the solution.  The only values that aren't included in the parameter file are GUIDs, and we need two for each of the schedule runbook links.

You can use the following PowerShell commands to install the solution.

	$resourceGroupName =  'MyResourceGroup'
	$scheduleLinkGuidCollection = [guid]::NewGuid()
	$scheduleLinkGuidScheduleCollection = [guid]::NewGuid()
	New-AzureRmResourceGroupDeployment -Name Stocks  -resourceGroupName $resourceGroupName -TemplateFile C:\solutions\stocks.json -TemplateParameterFile C:\solutions\stocks.parameters.json -scheduleLinkGuidCollection $scheduleLinkGuidCollection -scheduleLinkGuidScheduleCollection $scheduleLinkGuidScheduleCollection 

## Are you going to update it?
Absolutely!  This is very much a work in progress.  In addition to adding to the solution itself, I'll continue to add notes here on how it works and how you can leverage the concepts for other solutions.

## How do I ask questions?
Please send me mail if you have any questions, comments, or suggestions.  My goal is to provide whatever information you need to solve your business problems with OMS so I'm always interested to here your requirements and requests.

## Known issues

- (1/5/17) There's a runbook that enables and disables the schedule to collect stock quotes at the start and end of the day.  It can't disable the schedule though because edits to the schedule are locked by the containment relationship with the solution.  Need an alternate strategy for the functionality to turn off collection when the market's closed (to save useless runbook processing).



Brian Wren<br>
bwren@microsoft.com<br>
@mpauthor