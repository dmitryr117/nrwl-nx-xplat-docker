#!/bin/sh

#export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')
#export PATH=\"${PATH}:${ANDROID_HOME}tools/bin/
#export PATH=\"${PATH}:${ANDROID_HOME}tools/:${ANDROID_HOME}platform-tools/
apt-get install lib32z1 lib32ncurses5 libbz2-1.0 libstdc++6 g++ openjdk-8-jdk -y

echo "export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')" >> $HOME/.bashrc
mkdir -p /root/.android/avd && touch /root/.android/repositories.cfg

ANDROID_SDK="system-images;android-${ANDROID_VERSION};default;${ANDROID_ARCH}"

$ANDROID_HOME/tools/bin/sdkmanager --update \
&& yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses \
&& $ANDROID_HOME/tools/bin/sdkmanager "tools" "emulator" "platform-tools" "platforms;android-${ANDROID_VERSION}" "build-tools;29.0.2" "extras;android;m2repository" "extras;google;m2repository" \
&& $ANDROID_HOME/tools/bin/sdkmanager $ANDROID_SDK

chmod a+x $ANDROID_HOME/tools/bin/avdmanager && chmod a+x $ANDROID_HOME/tools/emulator

echo no | $ANDROID_HOME/tools/bin/avdmanager create avd -n testAVD -k $ANDROID_SDK
mv /root/.android $HOME

# && echo no | $ANDROID_HOME/tools/bin/avdmanager create avd -n testAVD -k "system-images;android-25;default;x86_64"