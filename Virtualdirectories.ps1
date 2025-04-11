<#
=============================================================================================
Name:           Setup virtual directories 2019 Exchange server
Author:         Kirti Behera
Description:    This script helps to configure Exchange Server virtual directories in an AD environment.
Version:        1.0
Website:        https://o365forum.blogspot.com/
                https://www.electrowander.in.net/

Script Highlights: 
~~~~~~~~~~~~~~~~~
A single script allows you to Setup virtual directories in $servername Server. 

For detailed execution: 
=============================================================================================
#>

# Define the header text
$header = "Setup virtual directories using CLI for Exchange Server 2016/2019 Script"

# Create a border line
$border = "*" * $header.Length

# Display the header with formatting
Write-Host $border -ForegroundColor Cyan
Write-Host $header -ForegroundColor Yellow
Write-Host $border -ForegroundColor Cyan

# Get Exchange server hostname from user
$servername = $env:COMPUTERNAME

Write-Host "`nInitiating Virtual Directory details for Exchange Server..." -ForegroundColor Green

# Show current virtual directory configuration
Get-EcpVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-OWAVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-OABVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-ActiveSyncVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-WebServicesVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-MapiVirtualDirectory -Server $servername | Select DisplayName, *URL*

# Get new URL base from user
$Newurl = Read-Host "Type your new base URL (e.g., https://mail.office365concepts.com)"

Write-Host "`nUpdating virtual directories..." -ForegroundColor Green

# ECP Virtual Directory
Get-EcpVirtualDirectory -Server $servername | Set-EcpVirtualDirectory `
    -InternalURL "$Newurl/ecp" `
    -ExternalURL "$Newurl/ecp"

# OWA Virtual Directory
Get-OWAVirtualDirectory -Server $servername | Set-OWAVirtualDirectory `
    -InternalURL "$Newurl/owa" `
    -ExternalURL "$Newurl/owa"

# OAB Virtual Directory
Get-OABVirtualDirectory -Server $servername | Set-OABVirtualDirectory `
    -InternalURL "$Newurl/oab" `
    -ExternalURL "$Newurl/oab"

# ActiveSync Virtual Directory
Get-ActiveSyncVirtualDirectory -Server $servername | Set-ActiveSyncVirtualDirectory `
    -InternalURL "$Newurl/Microsoft-Server-ActiveSync" `
    -ExternalURL "$Newurl/Microsoft-Server-ActiveSync"

# EWS Virtual Directory
Get-WebServicesVirtualDirectory -Server $servername | Set-WebServicesVirtualDirectory `
    -InternalURL "$Newurl/EWS/Exchange.asmx" `
    -ExternalURL "$Newurl/EWS/Exchange.asmx"

# MAPI Virtual Directory
Get-MapiVirtualDirectory -Server $servername | Set-MapiVirtualDirectory `
    -InternalURL "$Newurl/mapi" `
    -ExternalURL "$Newurl/mapi"

Write-Host "`nAll virtual directories updated successfully!" -ForegroundColor Cyan

Write-host "Restarting IIS"

iisreset /noforce

Write-Host "New Virtual directories after update"

Get-EcpVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-OWAVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-OABVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-ActiveSyncVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-WebServicesVirtualDirectory -Server $servername | Select DisplayName, *URL*
Get-MapiVirtualDirectory -Server $servername | Select DisplayName, *URL*