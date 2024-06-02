#!/bin/bash

if [[ ! -x "$(command -v go)" ]]; then
  gum style --margin "1 1" "Go not installed. Installing..."
  export GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
  tee -a $HOME/.profile > /dev/null << EOF
# GO
export GO_VERSION=$GO_VERSION
export PATH=$PATH:/usr/local/go/bin:$GOBIN
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$GOPATH/bin
export GO111MODULE=on
alias go-update="wget https://go.dev/dl/$GO_VERSION.linux-amd64.tar.gz; sudo rm -rf /usr/local/go; sudo tar -C /usr/local -xzf $GO_VERSION.linux-amd64.tar.gz; rm $GO_VERSION.linux-amd64.tar.gz; go version"
EOF
  wget https://go.dev/dl/$GO_VERSION.linux-amd64.tar.gz > /dev/null
  sudo rm -rf /usr/local/go > /dev/null
  sudo tar -C /usr/local -xzf $GO_VERSION.linux-amd64.tar.gz > /dev/null
  rm $GO_VERSION.linux-amd64.tar.gz > /dev/null
  source $HOME/.profile
