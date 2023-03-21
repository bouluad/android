FROM centos:7

# Install required packages
RUN yum -y update && \
    yum -y install wget unzip git java-1.8.0-openjdk-devel && \
    yum -y clean all

# Download and install Android SDK
ARG ANDROID_SDK_VERSION=7583922_latest
ARG ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}.zip
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q ${ANDROID_SDK_URL} -O android-sdk.zip && \
    unzip -q android-sdk.zip && \
    rm android-sdk.zip && \
    mv cmdline-tools/* . && \
    rm -r cmdline-tools && \
    yes | ${ANDROID_SDK_ROOT}/bin/sdkmanager --licenses

ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/platform-tools

# Download and install Gradle
ENV GRADLE_VERSION=7.3.3
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -q /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip
ENV PATH=${PATH}:/opt/gradle-${GRADLE_VERSION}/bin

# Create a directory for the project
RUN mkdir /app
WORKDIR /app

# Copy the app source code into the container
COPY . /app

# Build the app
RUN ./gradlew assembleDebug
