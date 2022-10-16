# profile-lister
Apple Development Profile lister/maintainer

## Description
When diagnosing Xojo iOS issues, I find that the majority of issues involve expired, invalid or duplicate profiles. This tool will list the profiles currently installed on your computer. Items shown in Red expired in the past or have no corresponding item in your Apple Dev account while items that are Orange expire in less than a week.

You can remove expired items by selecting Edit > Profiles > Cleanup or pressing CMD-K.

To refresh the list, select Edit > Profiles > Refresh or press CMD-R.

Starting in version 1.5, there's an option for connecting to the App Store Connect API. To do this, go to your Apple Dev account under **Users and Access** and add a an App Store Connect API key. Currently the key only needs Developer access. You'll need three pieces of info from this screen:
* The Key ID: A 10 character Alphanumeric ID
* The Issuer ID: A GUID shown at the top of the key window
* The key itself: A .p8 certificate. Put this in a safe place!

Once you have those three items, go to the Preferences window and enter them into the corresponding fields. Refreshing the list will read the profiles from your computer and then compare them against the ones in the connected Apple Developer account. Currently there is only support for one dev account at a time, but I hope to add the ability to have more than one in the future.