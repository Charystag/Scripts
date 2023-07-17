sudo -s -- <<INSTALL
curl -fsSLO https://go.dev/dl/go1.20.6.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.6.linux-amd64.tar.gz
INSTALL
#Don't forget to add /usr/local/go/bin to the path
#export PATH="$PATH:/usr/local/go/bin"
