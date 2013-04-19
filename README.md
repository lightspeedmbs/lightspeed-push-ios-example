lightspeed-ios-demo
===================
This project is a simple demostration of the integration of Lightspeed SDK 2.0

You will have to prepare the following items before you can build and run the Lightspeed SDK on your device.
1. Go to Apple Developer Portal and create an App-ID and provisioning profile
2. Create a certificate with Apple Push Notification enabled for the corresponding App-ID and provisioning profile
3. Create a Lightspeed application
4. Provide your application a .p12 file based on the push-noficiation enabled certificate
5. Replace the app-key in LightspeedCredential.h with your own Lightspeed application's key
6. Last but not least, choose corresponding code-signing identity so you can deploy the application on your device

If you are including the Lightspeed SDK 2.0 into your own Xcode project, you will need the following settings:
1. Add Lightspeed library path into the "Header Search Paths" in your application's project setting
2. The Lightspeed SDK 2.0 requires iOS Security.framework and libArrownock.a
3. Add "-all_load" to "Other Linker Flags" in your project settings
4. Enable "Use Entitlements File" and check if "aps-environment" is setup with correct value (development or production)

You may also follow the instructions (Traditional Chinese) in this page:
http://docs.lightspeedmbs.com/