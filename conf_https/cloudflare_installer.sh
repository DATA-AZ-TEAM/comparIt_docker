#!/bin/sh

# Check if user has root privileges
if [[ $EUID -ne 0 ]]; then
echo "You must run the script as root or using sudo"
   exit 1
fi

## Reconfigure Dash
echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure -f noninteractive dash > /dev/null 2>&1

apt-get update && apt install lsb-release bash debhelper apt-transport-https -y

# get requirements for certbot to grab certs through cloudflare
apt-get install python-pip python-virtualenv python-dev build-essential libssl-dev libffi-dev -y

echo "# certbot with acme v2
deb     http://ftp.de.debian.org/debian/    sid main contrib non-free
deb-src http://ftp.de.debian.org/debian/    sid main contrib non-free" >> /etc/apt/sources.list

apt-get -t sid install certbot -y
sleep 3
cd /root
git clone https://github.com/certbot/certbot.git
cd certbot
python setup.py install
cd certbot-dns-cloudflare
python setup.py install
# check if it worked
sleep 1
echo  
echo Et voila:
sleep 1
certbot --version

# and now, to install wildcard certs via cloudflare dns-001, do this in one line:
#
# certbot certonly --server https://acme-v02.api.letsencrypt.org/directory --rsa-key-size 4096 --dns-cloudflare --dns-cloudflare-credentials ~/.ssh/certapi --dns-cloudflare-propagation-seconds 90 -d exampledomain.org,*.exampledomain.org
#
# Note that --dns-cloudflare-credentials ~/.ssh/certapi is just the file-location I gave as an example.
# /root/.ssh/certapi looks like this:
# #Cloudflare API creds
# dns_cloudflare_email = your@cloudflare.login
# dns_cloudflare_api_key = look-for-this-key-in-your-account-settings-at-cloudflare
#
# Note that you have to add the naked domain too if you want to have that secured as well (usually you do),
# I don't know why they haven't defaulted with that for wildcard issuance.
#
#    !!! P.S. Be sure to comment the "sid" entries out in /etc/apt/sources.list
#        or you'll cause dependency hell with future python installs !!!
