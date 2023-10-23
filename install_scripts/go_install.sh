#!/usr/bin/bash
extension="tar.gz"
source="go1.20.6.linux-"
arm="$source""arm64"'.'"$extension"
amd="$source""amd64"'.'"$extension"
to_install=""
if [ "$(uname -p)" = "aarch64" ]
then
    to_install=$arm
else
    to_install=$amd
fi
echo $to_install
exit 1
sudo -s -- <<INSTALL
curl -fsSLO https://go.dev/dl/$to_install
rm -rf /usr/local/go && tar -C /usr/local -xzf $to_install
rm -f $to_install
INSTALL
#Don't forget to add /usr/local/go/bin to the path
#export PATH="$PATH:/usr/local/go/bin"
