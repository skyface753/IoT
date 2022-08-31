#BUILD LINUX

#Stage 1 - Install dependencies and build the app
FROM ubuntu:latest

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget unzip
RUN apt-get install -y ninja-build cmake clang pkg-config libgtk-3-dev
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
# RUN Bash
# RUN flutter build linux --release
# CMD ["/bin/bash"]
CMD ["flutter", "build", "linux", "--release"]