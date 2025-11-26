# golang
GO_LATEST="1.25.4"
mkdir -p ~/Downloads/software
wget -O ~/Downloads/software/go${GO_LATEST}.linux-amd64.tar.gz https://go.dev/dl/go${GO_LATEST}.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf ~/Downloads/software/go${GO_LATEST}.linux-amd64.tar.gz
