apt-get install -y dnsmasq

echo "interface=wlan0" > dnsmasq.conf
echo "dhcp-range=172.16.20.10,172.16.20.250,12h" >> dnsmasq.conf
echo "dhcp-option=3,172.16.20.1" >> dnsmasq.conf
echo "dhcp-option=6,172.16.20.1" >> dnsmasq.conf
echo "server=8.8.8.8" >> dnsmasq.conf
echo "log-queries" >> dnsmasq.conf
echo "log-dhcp" >> dnsmasq.conf

apt-get install hostapd
