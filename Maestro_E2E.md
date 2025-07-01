## Mobile E2E testing with Maestro on ubuntu

Steps:

1. Download and install Android Studio
2. Pull the project code from vs code.
3. Setup your project. 
4. Install npm package and build apk on emulator.
5. setup e2e test with maestro and run the flow.
----------------------------------------------------------------------------------------------------------

### 1. Download and install Android Studio 
```

# To install android studio
sudo apt update
sudo apt install -y curl unzip libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

# Go to: https://developer.android.com/studio
# Download the .tar.gz file for Linux.

tar -xzvf android-studio-*.tar.gz
sudo mv android-studio /opt/

export ANDROID_HOME=/opt/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

source ~/.bashrc

sudo ln -s /opt/android-studio/bin/studio.sh /usr/bin/android-studio

```
----------------------------------------------------------------------------------------------------------

### 2. Pull the project code from vs code.
```
git clone <repo_ url>

```
----------------------------------------------------------------------------------------------------------

### 3. Copy env files and paste on root folder and change expo id of all environmet files,app.config.js

1. copy all environment variables to project root folder
2. update expo id of your environment files and app.config.js
----------------------------------------------------------------------------------------------------------------

### 4. Install npm package and build apk on emulator

```
npx expo prebuild
eas build -p android --profile development
emulator -list-avds # list the avd
emulator -avd testdevice -> terminal 1 # Run the emulator
npx expo run:android -> terminal 2 # It installs app on running emulator.
npx expo start -c -> terminal 3 # start the server for development profile

```
-------------------------------------------------------------------------------------------------------------------------
### 5. setup e2e test with maestro and run the flow.

Make e2e folder on root project folder and create login-flow.yaml.
```
# e2e/login-flow.yaml
appId: com.karmaleague.iamversemobileapp 
---
- launchApp
- tapOn: "Enter your email or username"
- inputText: "your@mail.com"
- tapOn: "Enter your password"
- inputText: "V1ckey@123"
- tapOn: "Sign In"
```
Install maestro and run the test.
```
curl -Ls "https://get.maestro.mobile.dev" | bash
export PATH="$HOME/.maestro/bin:$PATH"

# To test
maestro test e2e

```
