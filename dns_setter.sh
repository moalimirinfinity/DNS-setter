
DNS_SERVER_1="8.8.8.8"
DNS_SERVER_2="8.8.8.8"


echo "Attempting to set DNS servers to $DNS_SERVER_1 and $DNS_SERVER_2 for the active Wi-Fi connection."

WIFI_SERVICE=$(networksetup -listallnetworkservices | grep -i "Wi-Fi" | head -n 1)

if [ -z "$WIFI_SERVICE" ]; then
    echo "Error: Could not find a Wi-Fi network service. Please ensure Wi-Fi is enabled."
    exit 1
fi

echo "Found Wi-Fi service: '$WIFI_SERVICE'"

sudo networksetup -setdnsservers "$WIFI_SERVICE" "$DNS_SERVER_1" "$DNS_SERVER_2"

if [ $? -eq 0 ]; then
    echo "DNS servers successfully set for '$WIFI_SERVICE'."
    echo "To verify, you can run: networksetup -getdnsservers '$WIFI_SERVICE'"
else
    echo "Error: Failed to set DNS servers."
    echo "You may be prompted for your password if it's the first time you're running sudo or after a certain period."
fi

echo "Flushing DNS cache..."
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "DNS cache flushed."
echo "Script finished."