lightspeed-ios-demo
===================
This project is a simple demostration of the integration of Lightspeed SDK 2.0<br />

You will have to prepare the following items before you can build and run the Lightspeed SDK on your device.<br />
1. Go to Apple Developer Portal and create an App-ID and provisioning profile<br />
2. Create a certificate with Apple Push Notification enabled for the corresponding App-ID and provisioning profile<br />
3. Create a Lightspeed application<br />
4. Provide your application a .p12 file based on the push-noficiation enabled certificate<br />
5. Replace the app-key in LightspeedCredential.h with your own Lightspeed application's key<br />
6. Last but not least, choose corresponding code-signing identity so you can deploy the application on your device<br />

If you are including the Lightspeed SDK 2.0 into your own Xcode project, you will need the following settings:<br />
1. Add Lightspeed library path into the "Header Search Paths" in your application's project setting<br />
2. The Lightspeed SDK 2.0 requires iOS Security.framework and libArrownock.a<br />
3. Add "-all_load" to "Other Linker Flags" in your project settings<br />
4. Enable "Use Entitlements File" and check if "aps-environment" is setup with correct value (development or production)<br />

You may also follow the instructions (Traditional Chinese) in this page:
http://docs.lightspeedmbs.com/
