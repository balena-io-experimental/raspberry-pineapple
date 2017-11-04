set -e

# Sleep a second just to let local push connect to the output
sleep 1

# Pick some hotspot settings
HOTSPOT_CONNECTION_NAME=hotspot-conn
HOTSPOT_NAME=${HOTSPOT_NAME:-intercepting-wifi}
OUT_INTERFACE=${OUT_INTERFACE:-eth0}

# Start up the hotspot using network manager
echo "Starting hotspot $HOTSPOT_NAME..."
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
nmcli --nocheck connection add type wifi ifname '*' con-name $HOTSPOT_CONNECTION_NAME autoconnect no ssid $HOTSPOT_NAME >/dev/null 2>&1
nmcli --nocheck connection modify $HOTSPOT_CONNECTION_NAME 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared >/dev/null 2>&1
nmcli --nocheck connection up $HOTSPOT_CONNECTION_NAME >/dev/null 2>&1

# Make sure DNS keeps working
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
echo 'nameserver 8.8.4.4' >> /etc/resolv.conf

echo "Intercepting traffic..."
sysctl -w net.ipv4.ip_forward=1

iptables -F
iptables -F --table nat
iptables -P FORWARD ACCEPT
iptables -A PREROUTING --table nat -i wlan0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables --table nat -A POSTROUTING -o $OUT_INTERFACE -j MASQUERADE

echo "Starting proxy..."
npm start