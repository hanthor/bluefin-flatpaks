#!/bin/bash
set -ouex pipefail

# Fetch lists
/usr/bin/ghcurl https://raw.githubusercontent.com/ublue-os/bluefin/main/flatpaks/system-flatpaks.list > /tmp/system-flatpaks.list
/usr/bin/ghcurl https://raw.githubusercontent.com/ublue-os/bluefin/main/flatpaks/system-flatpaks-dx.list > /tmp/system-flatpaks-dx.list

# Combine lists
cat /tmp/system-flatpaks.list /tmp/system-flatpaks-dx.list > /tmp/all-flatpaks.list

# Install flatpaks
# We use xargs to process the list. 
# We need to strip 'app/' and 'runtime/' prefixes if they exist, as 'flatpak install' expects just the ID or 'remote ref'.
# However, the lists in bluefin seem to use 'app/ID' and 'runtime/ID'.
# 'flatpak install' usually handles 'app/ID' if we pass it correctly, or we might need to strip.
# Let's check the format. The lists have "app/com.example.App" or "runtime/org.example.Runtime".
# flatpak install flathub com.example.App works.
# flatpak install flathub app/com.example.App might not.
# Let's strip the prefix.

sed -i 's|^app/||g' /tmp/all-flatpaks.list
sed -i 's|^runtime/||g' /tmp/all-flatpaks.list

# Remove empty lines
sed -i '/^$/d' /tmp/all-flatpaks.list

# Install
# --system installs to /var/lib/flatpak
# --noninteractive assumes yes
xargs -a /tmp/all-flatpaks.list flatpak install --system --noninteractive flathub

# Clean up
rm /tmp/system-flatpaks.list /tmp/system-flatpaks-dx.list /tmp/all-flatpaks.list
