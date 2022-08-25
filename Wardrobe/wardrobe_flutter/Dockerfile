#BUILD LINUX

#Stage 1 - Install dependencies and build the app
FROM debian:latest AS build-env

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl libgtk-3-0 libblkid1 liblzma5 cmake git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback 
RUN apt-get install -y ninja-build clang curl cmake libgtk-3-0 libblkid1 liblzma5 git pkg-config libsecret-1-dev libsecret-tools libsecret-1-0
RUN apt-get install -y libsecret-1-dev libjsoncpp-dev libsecret-1-0
RUN apt-get clean
# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"



# Run flutter doctor
RUN flutter doctor -v

# Build the app
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN flutter build linux --release
CMD ["flutter", "build", "linux", "--release"]

