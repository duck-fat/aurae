#!/usr/bin/env bash

# Do not add GNU libraries here! Do not add GNU libraries here!
#
# Please (seriously please) be careful about adding commands here.
# This is our core way of validating that our binary is "healthy"
# If we need to install anything with the word "lib" in it to get
# the build to pass, we likely should be having other discussions
# instead of adding commands here.
#
# Do not add GNU libraries here! Do not add GNU libraries here!
#
# For example, we should NOT be adding libraries such as "libseccomp"
# or "libdbus".
#
# If in doubt, please ask in Discord in the build channel.
#
# Do not at GNU libraries here! Do not add GNU libraries here!
sudo apt-get update
sudo apt-get install -y musl-tools

# install buf 1.32.0
if ! hash buf
then
  PREFIX="/usr/local"
  VERSION="1.32.0"
  URL_BASE=https://github.com/bufbuild/buf/releases/download
  DOWNLOAD_SLUG="v${VERSION}/buf-$(uname -s)-$(uname -m).tar.gz"
  curl -sSL "${URL_BASE}/${DOWNLOAD_SLUG}" | \
    sudo tar -xvzf - -C "${PREFIX}" --strip-components 1
fi

if ! hash protoc-gen-doc
then
  URL_BASE=https://github.com/pseudomuto/protoc-gen-doc/releases/download
  DOWNLOAD_SLUG=v1.5.1/protoc-gen-doc_1.5.1_linux_amd64.tar.gz
  wget "${URL_BASE}/${DOWNLOAD_SLUG}"
  tar -xzf protoc-gen-doc_1.5.1_linux_amd64.tar.gz
  chmod +x protoc-gen-doc
  sudo mv protoc-gen-doc /usr/local/bin/protoc-gen-doc
  sudo apt-get update
  sudo apt-get install -y protobuf-compiler
  rm protoc-gen-doc_1.5.1_linux_amd64.tar.gz
  rm CHANGELOG.md
  rm LICENSE.md
fi
