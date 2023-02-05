Configure Google Cloud

1. Create a Google Cloud project for your app
2. Go to Credentials under APIs & Services
3. Create a OAuth client ID
  1. Make this a web application
  2. You will need from this page as settings in Pocketbase and your Flutter application:
    1. Client ID
    2. Client secret
  3. Add Authorized redirect URI. This URI must match the CallbackActivity configuration in the Flutter application's manifest file (instructions later in document)  

Host a Pocketbase instance

1. Run pocketbase instance at a known IP address/hostname. This host must be accessible from your Android device.
2. Configure Google authentication using the data from step 3.b above.  

Host well-known/assetlinks.json

You must be able to validate that you are authorized to deep link using the domain in the redirect URI. This means you must have a means to host a file on the public internet with a domain you control.

[https://developer.android.com/training/app-links/verify-android-applinks](https://developer.android.com/training/app-links/verify-android-applinks)  

Configure Flutter project  

1. Add dependencies:
  1. pocketbase
  2. flutter\_web\_auth
  3. pkce
2. Update Android application id to your application id
  1. I recommend using package change\_app\_package\_name on pub.dev to make this easy. Otherwise you will need to manually modify several files in your Android project
3. Declare uses-permission android.permission.INTERNET
4. Register CallbackActivity
  1. Modifications made in android/app/src/main
  2. You will need to replace the attributes on the <data\> element with those that are relevant to your application.
    1. If you only own one domain but want to use it for several app signin redirects, you can use a unique pathPrefix attribute for each app (still must match the redirect URI set up in Google Cloud)
5. Configure your pocketbase instance in main.dart
  1. Find the const declarations for the pocketbase settings and fill them in with the correct values from Google Cloud and your Pocketbase instance.
6. Run the app  

If all is configured correctly, you should be directed to the browser. If you are already authenticated to Google, you'll probably be immediately returned to the application. If not, you will be prompted to sign in.