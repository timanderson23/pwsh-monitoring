#############################
# Import all custom modules #
#############################

#Target the directory containing all custom modules to import
$CustomModuleDirectory = "D:\git\pwsh-modules\modules"

#Import all modules within the specified directory
try {
    
    Import-Module (Get-ChildItem $CustomModuleDirectory | Where-Object {$_.Name -match "psm1"}) -Force -ErrorAction Stop

}
catch {
    
    Write-Host -ForegroundColor Red "ERROR: Unable to import modules`n"
    exit

}

#####################
# Print Script Name #
#####################

Show-ScriptName

#####################################
# Validate and Import Manifest File #
#####################################

#Provide the name of the manifest file. Assumes the manifest is located in the same directory as the executing script
$ManifestFileName = "pki-health-check.psd1"

#Check the AuthenticodeSignature status of the manifest
$ManifestFileLocation = $PSScriptRoot + "\" + $ManifestFileName
$ManifestFileValidityCheck = Get-AuthenticodeSignature $ManifestFileLocation
$ManifestFileValidityStatus = $ManifestFileValidityCheck.Status

#If the status does not match "Valid", post an error to the console and terminate scripte execution
if ($ManifestFileValidityStatus -notlike "Valid") {
    
    Write-Host -ForegroundColor Red "Manifest File is not Valid ($ManifestFileValidityStatus)`n"
    exit

}
#If the status does match "Valid", import the manifest file to the $ManifestData variable
else {
    
    $ManifestData = Import-PowerShellDataFile $ManifestFileLocation

}

################################
# Initialize HTML Email Report #
################################

#Notify the console if sending of the email report is disabled
$SendReportEnabled = $ManifestData.SendReportEnabled
$SendReportOverride = $ManifestData.SendReportOverride

if (!$SendReportEnabled) {

    Write-Host -ForegroundColor Yellow "WARNING: The Email Report feature is currently disabled."

}
if ($SendReportOverride) {

    Write-Host -ForegroundColor Yellow "WARNING: Email Report Override has been enabled."

}

#Initiate $Global:HTMLTop
New-HTMLTop

#Initiate $Global:HTMLTable with the specified columns (and headers)
New-HTMLTable "Test Type,Target,Result"

##################################
# Import Variables from Manifest #
##################################

$CDPDNSPaths = $ManifestData.CDPDNSPaths
$HTTPShare = $ManifestData.HTTPShare
$AIACertificates = $ManifestData.AIACertificates
$CRLFiles = $ManifestData.CRLFiles
$CRLPublishIntervalDaysFull = $ManifestData.CRLPublishIntervalDaysFull
$CRLPublishIntervalDaysDelta = $ManifestData.CRLPublishIntervalDaysDelta

#Pull the current Datetime
$CurrentDateTime = Get-Date

#Set Error Counter
$Ei = 0

##########################
# Test each CDP location #
##########################

Write-Host -ForegroundColor White -BackgroundColor Blue "`nTesting CRL/AIA Retrieval"

foreach ($CDPDNSPath in $CDPDNSPaths) {

    #Build the base URL for the current CDP location (append http share)
    $CDPBaseURL = "http://" + $CDPDNSPath + "/" + $HTTPShare
    Write-Host -ForegroundColor Cyan "`nCRL Distribution Point: $CDPBaseURL"

    #############################
    # Test each AIA certificate #
    #############################

    Write-Host -ForegroundColor White "`n[Authority Information Access]"
    foreach ($AIACertificate in $AIACertificates) {

        #Build the Full AIA path
        $AIAFullURL = $CDPBaseURL + "/" + $AIACertificate
        Write-Host -ForegroundColor White "`t$AIAFullURL (" -NoNewline

        #Invoke a Web request against the specified URL
        try {

            $WebRequestResult = Invoke-WebRequest -Uri $AIAFullURL -ErrorAction Stop

            #Assign the specific return codes to variables
            $WebRequestResultStatusCode = $WebRequestResult.StatusCode
            $WebRequestResultStatusDescription = $WebRequestResult.StatusDescription

            #Make sure the expected return codes are returned
            $ExpectedStatusCode = "200"
            $ExpectedStatusDescription = "OK"

            #If the expected return codes are not returned, notify the console
            if ($WebRequestResultStatusCode -notlike $ExpectedStatusCode -and $WebRequestResultStatusDescription -notlike $ExpectedStatusDescription) {

                Write-Host -ForegroundColor Yellow "Unexpected Return Values: $WebRequestResultStatusCode | $WebRequestResultStatusDescription"
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "AIA (Reachable)",$AIAFullURL,"Unexpected Return Code ($WebRequestResultStatusCode|$WebRequestResultStatusDescription);color:yellow;value:Unexpected Return Code ($WebRequestResultStatusCode|$WebRequestResultStatusDescription)"
                $Ei++

            }
            #If the expected return codes are returned, the request was successful
            else {

                Write-Host -ForegroundColor green "Success" -NoNewline
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "AIA (Reachable)",$AIAFullURL,"Success;color:green;value:Success"

            }

        }
        catch {

            $Exception = $_.Exception
            Write-Host -ForegroundColor Red "Failed - $Exception" -NoNewline
            Write-Host -ForegroundColor White ")"
            New-HTMLRow "AIA (Reachable)",$AIAFullURL,"Failed;color:red;value:Failed"
            $Ei++

        }

    } #End of foreach AIA certificate

    #################
    # Test each CRL #
    #################

    Write-Host -ForegroundColor White "`n[CRL Distribution Point]"
    foreach ($CRLFile in $CRLFiles) {

        #Build the Full CDP path
        $CDPFullURL = $CDPBaseURL + "/" + $CRLFile
        Write-Host -ForegroundColor White "`t$CDPFullURL (" -NoNewline

        #Invoke a Web request against the specified URL
        try {

            $WebRequestResult = Invoke-WebRequest -Uri $CDPFullURL -ErrorAction Stop

            #Assign the specific return codes to variables
            $WebRequestResultStatusCode = $WebRequestResult.StatusCode
            $WebRequestResultStatusDescription = $WebRequestResult.StatusDescription

            #Make sure the expected return codes are returned
            $ExpectedStatusCode = "200"
            $ExpectedStatusDescription = "OK"

            #If the expected return codes are not returned, notify the console
            if ($WebRequestResultStatusCode -notlike $ExpectedStatusCode -and $WebRequestResultStatusDescription -notlike $ExpectedStatusDescription) {

                Write-Host -ForegroundColor Yellow "Unexpected Return Values: $WebRequestResultStatusCode | $WebRequestResultStatusDescription"
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "CDP (Reachable)",$CDPFullURL,"Unexpected Return Code ($WebRequestResultStatusCode|$WebRequestResultStatusDescription);color:yellow;value:Unexpected Return Code ($WebRequestResultStatusCode|$WebRequestResultStatusDescription)"
                $Ei++

            }
            #If the expected return codes are returned, the request was successful
            else {

                Write-Host -ForegroundColor green "Success" -NoNewline
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "CDP (Reachable)",$CDPFullURL,"Success;color:green;value:Success"

            }

        }
        catch {

            $Exception = $_.Exception
            Write-Host -ForegroundColor Red "Failed - $Exception" -NoNewline
            Write-Host -ForegroundColor White ")"
            New-HTMLRow "CDP (Reachable)",$CDPFullURL,"Failed;color:red;value:Failed"
            $Ei++

        }

    } #End of foreach CRL File

} #End of foreach CDP

##################
# Verify CRL Age #
##################

Write-Host -ForegroundColor White -BackgroundColor Blue "`nVerifying state of CRL files`n"

#Process through each CDP path that ISN'T the round-robin DNS entry
foreach ($CDPDNSPath in $CDPDNSPaths | Where-Object {$_ -notmatch "crl."}) {

    $CDPBaseShare = "\\$CDPDNSPath\$HTTPShare"

    #Process through each CRL file that IS NOT for the Root certificate. The Root CRL is seldom updated.
    foreach ($CRLFile in $CRLFiles | Where-Object {$_ -notmatch "ROOT"}) {

        #Build the full share path to the current CRL file
        $CDPFullShare = "$CDPBaseShare\$CRLFile"

        Write-Host -ForegroundColor White "$CDPFullShare (" -NoNewline

        #Get the current CRL file
        $CurrentCRL = Get-Item $CDPFullShare
        $CurrentCRLLastWriteTime = $CurrentCRL.LastWriteTime

        #Compare the LastWriteTime attribute of the current CRL file against the current timestamp
        $TimeDifference = New-TimeSpan $CurrentCRLLastWriteTime $CurrentDateTime
        $TimeDifferenceMetric = $TimeDifference.Days

        #Check if this is the "full" or delta CRL
        #If this is a full CRL
        if ($CRLFile -notmatch "\+") {

            if ($TimeDifferenceMetric -gt $CRLPublishIntervalDaysFull) {

                Write-Host -ForegroundColor Red "Past Due ($TimeDifferenceMetric days since last publish)" -NoNewline
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "Full CRL (Publish State)",$CDPFullShare,"Past Due;color:red;value:Past Due"
                $Ei++

            }
            else {

                Write-Host -ForegroundColor Green "OK (within $CRLPublishIntervalDaysFull days since last publish)" -NoNewline
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "Full CRL (Publish State)",$CDPFullShare,"Up to Date;color:green;value:Up to Date"

            }

        }
        else {

            if ($TimeDifferenceMetric -gt $CRLPublishIntervalDaysDelta) {

                Write-Host -ForegroundColor Red "Past Due ($TimeDifferenceMetric days since last publish)" -NoNewline
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "Delta CRL (Publish State)",$CDPFullShare,"Past Due;color:red;value:Past Due"
                $Ei++

            }
            else {

                Write-Host -ForegroundColor Green "OK (within $CRLPublishIntervalDaysDelta days since last publish)" -NoNewline
                Write-Host -ForegroundColor White ")"
                New-HTMLRow "Delta CRL (Publish State)",$CDPFullShare,"Up to Date;color:green;value:Up to Date"

            }

        }

    }

}

############################
# Complete HTML formatting #
############################

#Close the completed table
$Global:HTMLTable += "</table>"

#Specify any HTML content you want before (top) or after (bottom) of the HTML table data
#Can include links to input files, exceptions list, etc
$HTMLTextTop = "<p>Review the table below to see which tests failed.</p>"
#$HTMLTextBottom = "<p>A separate section of text which can be placed elsewhere in the report, i.e. under the table</p>"

#String the HTML variables together for export
#Since this is all basic HTML, you can add/remove text sections however you want
$EmailHTMLFinal = $Global:HTMLTop + $HTMLTextTop + $Global:HTMLTable
#$HTMLTextBottom

######################################################
# Specify final report variables and send the report #
######################################################

#Import the ToAddress from the Manifest
$SendReportEnabled = $ManifestData.SendReportEnabled
$EmailToAddress = $ManifestData.EmailToAddress

#Call the Send-EmailReport function to send the email report
#This also adds the default source footer at the bottom of the email reports
if ($SendReportEnabled -and $Ei -gt 0 -or $SendReportOverride) {

    #Specify the Email Subject
    $EmailSubject = "[PKI Health Check] Issues detected ($Ei)"

    Send-EmailReport $EmailToAddress,$EmailSubject,$EmailHTMLFinal

}
# SIG # Begin signature block
# MIIL2gYJKoZIhvcNAQcCoIILyzCCC8cCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUE75vXuPJcyA/La2h9y7bKezK
# Wk+gggnMMIIEyzCCA7OgAwIBAgIKcv7djAADAAAADTANBgkqhkiG9w0BAQsFADAY
# MRYwFAYDVQQDEw1DQS1ST09ULTAxLUNBMB4XDTE2MDgwNTE1MDYxOVoXDTM2MDIw
# ODE2NTk1MFowXTETMBEGCgmSJomT8ixkARkWA2NvbTEfMB0GCgmSJomT8ixkARkW
# D3RhbHF1aW5lbGVjdHJpYzElMCMGA1UEAxMcdGFscXVpbmVsZWN0cmljLUNBLVNV
# Qi0wMS1DQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPSiQY0Fhgpr
# kPMbzoYLxB/prHn4ESBcZbGAk7lfDluGlHotb0qV7/FcSSLWP5AZLnwUvsatsnuJ
# RkVDYA49kmFyD2YuL+v3LDBzggISj+4f7tHNkvzkiloXyr6uxPYyc2abTeeJDyfP
# 3r3f3Tf1TJ1NDFexdU7MkKmHDh7y6m2U2hiTKlxCrBOMChee8oDtxTNBW7/e4MNf
# 7XQEpR5DhEwKyegL3VmbiNxyxoJi+N+9pRMQ0EG3frdM13ZFdpRbPNyyI32rEC3l
# yvHAe4dV8vRiAp2DJKtpGzHl4eJJjU8/KwLuOGmMuy64LUcc19jOSoHlZytdApez
# xvW9wIa5cs0CAwEAAaOCAdAwggHMMBIGCSsGAQQBgjcVAQQFAgMCAAIwIwYJKwYB
# BAGCNxUCBBYEFNrdqAFJugRR0RNTi/AOIXZi7ypwMB0GA1UdDgQWBBQEtPfMlmwo
# DwkJSy5RNUFFJykv0TAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8E
# BAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBQRXtsQGM+NcGC0JPZy
# 7bSmmQsLxjBzBgNVHR8EbDBqMGigZqBkhjBodHRwOi8vY2Etc3ViLTAyL0NlcnRF
# bnJvbGwvQ0EtUk9PVC0wMS1DQSgzKS5jcmyGMGh0dHA6Ly9jYS1zdWItMDEvQ2Vy
# dEVucm9sbC9DQS1ST09ULTAxLUNBKDMpLmNybDCBogYIKwYBBQUHAQEEgZUwgZIw
# RwYIKwYBBQUHMAKGO2h0dHA6Ly9jYS1zdWItMDIvQ2VydEVucm9sbC9jYS1yb290
# LTAxX0NBLVJPT1QtMDEtQ0EoMykuY3J0MEcGCCsGAQUFBzAChjtodHRwOi8vY2Et
# c3ViLTAxL0NlcnRFbnJvbGwvY2Etcm9vdC0wMV9DQS1ST09ULTAxLUNBKDMpLmNy
# dDANBgkqhkiG9w0BAQsFAAOCAQEAUoseQ4sor5k0S+ob8ZvGMhUUDdf8jdyF7HLw
# DoaTp8SiHvsdght7mHfxPonTU9SM6MCIk6zGlaFuRydSQS5IiTCSmTKeIy3m1ae9
# oEThF6qtkQWVDYKmWmFzua1YYzDdXTUO33NDJ0mlfld+PXWN5hWZbuGJO+S5dmUU
# HjGojy2GNMpbM8bbpiL9Kf/ZM8dm/x9l1mqeh1JsekeimtD7yb8u0w1qOxaatyLi
# kUxayBM9BnZHbhGwUez0Bt/C7zsfQ2othn6XpvM8Kq94ggifKHOHzO7Y2aYdS1v5
# VqijxZK/dX6CWLdk6lkXAkJwWNOE+QcvnfPDc5yQKr7p7v6vkDCCBPkwggPhoAMC
# AQICEz8AAA85hmrnnFefNIoAAgAADzkwDQYJKoZIhvcNAQELBQAwXTETMBEGCgmS
# JomT8ixkARkWA2NvbTEfMB0GCgmSJomT8ixkARkWD3RhbHF1aW5lbGVjdHJpYzEl
# MCMGA1UEAxMcdGFscXVpbmVsZWN0cmljLUNBLVNVQi0wMS1DQTAeFw0xOTA3MjQx
# OTM2MzlaFw0yMTA3MjMxOTM2MzlaMIHDMRMwEQYKCZImiZPyLGQBGRYDY29tMR8w
# HQYKCZImiZPyLGQBGRYPdGFscXVpbmVsZWN0cmljMRkwFwYDVQQLExBURUMgT3Jn
# YW5pemF0aW9uMRQwEgYDVQQLEwtEZXBhcnRtZW50czEmMCQGA1UECxMdSVQgYW5k
# IENvbW11bmljYXRpb24gU2VydmljZXMxCzAJBgNVBAsTAklUMQ4wDAYDVQQLEwVV
# c2VyczEVMBMGA1UEAxMMVGltIEFuZGVyc29uMHYwEAYHKoZIzj0CAQYFK4EEACID
# YgAEEaGM3uwxVsLBTstY8WW4nh8GGVQW/yNwVgwR5Mq+n50dmWzpM63Hk6zI/F5W
# H+Uf+ybDGprtKUkp7oa1fC52QsaH503i7BC8ca7eDWUbUXO97iGic7jAur35VVhj
# Bpndo4IB9zCCAfMwPgYJKwYBBAGCNxUHBDEwLwYnKwYBBAGCNxUIhYq1UoGXmjuB
# zZcpga7ZdIWa4AmBQYLU7iCF9I5eAgFkAgESMBMGA1UdJQQMMAoGCCsGAQUFBwMD
# MA4GA1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMB0G
# A1UdDgQWBBRSnbVvRZkbu1UKpNz7O1Yv25Q1EjAfBgNVHSMEGDAWgBQEtPfMlmwo
# DwkJSy5RNUFFJykv0TBkBgNVHR8EXTBbMFmgV6BVhlNodHRwOi8vY2Etc3ViLTAx
# LnRhbHF1aW5lbGVjdHJpYy5jb20vQ2VydEVucm9sbC90YWxxdWluZWxlY3RyaWMt
# Q0EtU1VCLTAxLUNBKDIpLmNybDCBjgYIKwYBBQUHAQEEgYEwfzB9BggrBgEFBQcw
# AoZxaHR0cDovL2NhLXN1Yi0wMS50YWxxdWluZWxlY3RyaWMuY29tL0NlcnRFbnJv
# bGwvY2Etc3ViLTAxLnRhbHF1aW5lbGVjdHJpYy5jb21fdGFscXVpbmVsZWN0cmlj
# LUNBLVNVQi0wMS1DQSgyKS5jcnQwOAYDVR0RBDEwL6AtBgorBgEEAYI3FAIDoB8M
# HVRBbmRlcnNvbkB0YWxxdWluZWxlY3RyaWMuY29tMA0GCSqGSIb3DQEBCwUAA4IB
# AQByIs5Ab17EuL1TJJIwGlAZCzbZE5S1iRSYvnGVv7MIUfM4qrng9uAxkBRukXy5
# CkuyBKRqYQ8OGAD+6uPbvMbnKOQ+icPaNtek7MC109WS5mjt48i+FZoSjm9iB+Z+
# lpS5oLdP8ZoyB3MoxxPOGMZ5mwePNx2j6I0r5AZ+1O4B7rKCkj2EUOkPt+W2/E5R
# dKAsDXnkavPZ9XBeCGjK81U77ygi7fCOLrCfW4661DlZamOFma8VCuK3Lxt4X13x
# 68CHiBq4hE8fGsqcE0CQvRE5XFndJbQbIiA6kZAj55IosSBZG66xrux+Y3L/LX1D
# fSLAAq3jdV0UVeLtUHMIZSXzMYIBeDCCAXQCAQEwdDBdMRMwEQYKCZImiZPyLGQB
# GRYDY29tMR8wHQYKCZImiZPyLGQBGRYPdGFscXVpbmVsZWN0cmljMSUwIwYDVQQD
# Exx0YWxxdWluZWxlY3RyaWMtQ0EtU1VCLTAxLUNBAhM/AAAPOYZq55xXnzSKAAIA
# AA85MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqG
# SIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3
# AgEVMCMGCSqGSIb3DQEJBDEWBBT2iF/aP+ws8hl076LFkXHZNdwFFjALBgcqhkjO
# PQIBBQAEZzBlAjEApmj3EvdIohFoGUThNCjH9YpAoTZ9J8xj+cGlgmZuFSTuo8ij
# clUwLUAjqWYbvEL0AjBjhUDiQHbrXFeskwPBwpHtotHA+83FFrfaXkRj8jfYipXs
# IXlYsa75j8ZeURHYRrw=
# SIG # End signature block
