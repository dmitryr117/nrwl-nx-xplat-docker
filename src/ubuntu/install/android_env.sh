#!/bin/sh
export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')

export PATH=\"${PATH}:${ANDROID_HOME}tools/bin/
export PATH=\"${PATH}:${ANDROID_HOME}tools/:${ANDROID_HOME}platform-tools/

apt-get install lib32z1 lib32ncurses5 libbz2-1.0 libstdc++6 g++ openjdk-8-jdk -y


$ANDROID_HOME/tools/bin/sdkmanager "tools" "emulator" "platform-tools" "platforms;android-25" "build-tools;28.0.3" "extras;android;m2repository" "extras;google;m2repository"
cd $ANDROID_HOME/tools/bin && touch /root/.android/repositories.cfg \
    && ./sdkmanager --update \
    && yes | ./sdkmanager --licenses