#tag Module
Protected Module Notes
	#tag Note, Name = MatchingProfilesToDevs
		
		Development profiles contain an array of DeveloperCertificates as base64 encoded data.
		
		These items match the public key portion of each developer that is allowed to use the profile,
		which can be obtained on the dev's computer by going to their keychain, selecting their dev
		certificate, selecting Export and chosing the ".cer" format (.p12 is overkill and potentially 
		dangerous as it includes the private key)
		
		We "might" be able to ask the user for access to their keychain, present a list of potential
		dev certificates and then extract just the portion we need, or if we can find the public part
		of the certificates on disk, that'd be easier. We should only show certs that are not expired 
		in this case.
	#tag EndNote


End Module
#tag EndModule
