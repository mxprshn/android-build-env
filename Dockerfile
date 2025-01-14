FROM archlinux

ENV SDK_CLI_VERSION 6858069
ENV BUILD_TOOLS_VERSION 29.0.2
ENV PLATFORM_TOOLS_VERSION 29

ENV SDK_CLI_PATH /home/sdk-tools
ENV ANDROID_SDK_ROOT /home/android-sdk

ENV PATH ${PATH}:${SDK_CLI_PATH}/bin
ENV JAVA_HOME /usr/lib/jvm/default

# Update distro & download dependencies
RUN pacman -Sy --noconfirm \
    && pacman -S unzip jdk-openjdk gradle wget git python python-pip --noconfirm

# Install http requests python library
RUN pip install urllib3

# Download android sdk tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_CLI_VERSION}_latest.zip -O ${SDK_CLI_PATH}.zip \
    && unzip -qq ${SDK_CLI_PATH}.zip -d ${SDK_CLI_PATH} \
    && rm ${SDK_CLI_PATH}.zip \
    && mv ${SDK_CLI_PATH}/cmdline-tools/* ${SDK_CLI_PATH} \
    && rm -rf ${SDK_CLI_PATH}/cmdline-tools

# Install build-tools and platform-tools
RUN mkdir -p "${ANDROID_SDK_ROOT}/licenses" \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "${ANDROID_SDK_ROOT}/licenses/android-sdk-license" \
    && sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "build-tools;${BUILD_TOOLS_VERSION}" \
    && sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platforms;android-${PLATFORM_TOOLS_VERSION}"