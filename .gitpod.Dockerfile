#Para que actualice
#tomado desde https://github.com/vtorres/gitpod-flutter/blob/master/.gitpod.dockerfile como referencia

FROM gitpod/workspace-full:latest

USER root

RUN apt-get update -y
RUN apt-get install -y gcc make build-essential wget curl unzip apt-utils xz-utils libkrb5-dev gradle libpulse0 android-tools-adb android-tools-fastboot

USER gitpod

RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk install java 8.0.292-open"
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk env init"

RUN java -version
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk env"
RUN sed -ri -e 's/java=11.0.11.fx-zulu/java=8.0.292-open/g' "/home/gitpod/.sdkmanrc"

# Android
# ENV JAVA_HOME="/home/gitpod/.sdkman/candidates/java/current/bin/"
ENV ANDROID_HOME="/home/gitpod/.android"
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_SDK_ARCHIVE="${ANDROID_HOME}/archive"
ENV ANDROID_STUDIO_PATH="/home/gitpod/"

RUN cd "${ANDROID_STUDIO_PATH}"
RUN wget -qO android_studio.tar.gz https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.2.1.0/android-studio-ide-202.7351085-linux.tar.gz
RUN tar -xvf android_studio.tar.gz
RUN rm -f android_studio.tar.gz

RUN mkdir -p "${ANDROID_HOME}"
RUN touch $ANDROID_HOME/repositories.cfg
RUN wget -q "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
RUN unzip -q -d "${ANDROID_HOME}" "${ANDROID_SDK_ARCHIVE}"
RUN echo y | "${ANDROID_HOME}/tools/bin/sdkmanager" "platform-tools" "platforms;android-29" "build-tools;29.0.2"
RUN rm "${ANDROID_SDK_ARCHIVE}"

# Flutter
ENV FLUTTER_HOME="/home/gitpod/flutter"
RUN git clone https://github.com/flutter/flutter $FLUTTER_HOME
RUN $FLUTTER_HOME/bin/flutter channel master
RUN $FLUTTER_HOME/bin/flutter upgrade
RUN $FLUTTER_HOME/bin/flutter precache
RUN $FLUTTER_HOME/bin/flutter config --enable-web --no-analytics
 RUN yes "y" | $FLUTTER_HOME/bin/flutter doctor --android-licenses -v
ENV PUB_CACHE=/workspace/.pub_cache

# Env
RUN echo 'export PATH=${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PUB_CACHE}/bin:${FLUTTER_HOME}/.pub-cache/bin:$PATH' >>~/.bashrc
