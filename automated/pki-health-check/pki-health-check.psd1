#pki-health-check.psd1
#Configuration data

@{

    #Email Report Variables
    SendReportEnabled = $true
    SendReportOverride = $false
    EmailToAddress = "<script.reports.monitoring@talquinelectric.com>"

    #CDP/AIA Variables
    CDPDNSPaths = @("crl.talquinelectric.com", "ca-sub-01.talquinelectric.com", "ca-sub-02.talquinelectric.com")
    HTTPShare = "CertEnroll"
    AIACertificates = @("ca-root-01_CA-ROOT-01-CA(3).crt", "ca-sub-01.talquinelectric.com_talquinelectric-CA-SUB-01-CA(2).crt", "ca-sub-02.talquinelectric.com_talquinelectric-CA-SUB-02-CA(2).crt")
    CRLFiles = @("CA-ROOT-01-CA(3).crl", "talquinelectric-CA-SUB-01-CA(2).crl", "talquinelectric-CA-SUB-01-CA(2)+.crl", "talquinelectric-CA-SUB-02-CA(2).crl", "talquinelectric-CA-SUB-02-CA(2)+.crl")
    CRLPublishIntervalDaysFull = "7"
    CRLPublishIntervalDaysDelta = "1"

}

# SIG # Begin signature block
# MIIL2wYJKoZIhvcNAQcCoIILzDCCC8gCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZ2rcpS/0n7kC1O407aR7/sC5
# FNWgggnMMIIEyzCCA7OgAwIBAgIKcv7djAADAAAADTANBgkqhkiG9w0BAQsFADAY
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
# fSLAAq3jdV0UVeLtUHMIZSXzMYIBeTCCAXUCAQEwdDBdMRMwEQYKCZImiZPyLGQB
# GRYDY29tMR8wHQYKCZImiZPyLGQBGRYPdGFscXVpbmVsZWN0cmljMSUwIwYDVQQD
# Exx0YWxxdWluZWxlY3RyaWMtQ0EtU1VCLTAxLUNBAhM/AAAPOYZq55xXnzSKAAIA
# AA85MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqG
# SIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3
# AgEVMCMGCSqGSIb3DQEJBDEWBBS3HtPRBuiA5WZjMXxzz7t8UpgCrjALBgcqhkjO
# PQIBBQAEaDBmAjEAvxNL291LX0Y6P6ejIl0JFALOy/gk8G3uSfbUDRU1+Q/cLVCs
# YtnN4v0SqzdA86/cAjEA4ndhM6ePCyMa7sCQMvNbG/B/8Y+N32HmNrZ7aq97EWGN
# ozLcwsv3Z6aMBUr/2sOF
# SIG # End signature block