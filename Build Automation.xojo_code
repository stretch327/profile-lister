#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyBundleContents
					AppliesTo = 0
					Architecture = 0
					Target = 0
					Destination = 4
					Subdirectory = 
					FolderItem = Li4vX0Fzc2V0cy9IZWxwZXJzLw==
				End
				Begin SignProjectStep Sign
				  DeveloperID=
				End
				Begin CopyFilesBuildStep CopyResources
					AppliesTo = 0
					Architecture = 0
					Target = 0
					Destination = 4
					Subdirectory = 
					FolderItem = Li4vUmVzb3VyY2VzLw==
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
