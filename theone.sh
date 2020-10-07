#!/bin/bash	
url=$1
if [ ! -d "~/Desktop/TargetsBug/$url" ];then
	mkdir ~/Desktop/TargetsBug/$url
fi
if [ ! -d "~/Desktop/TargetsBug/$url/recon" ];then
	mkdir ~/Desktop/TargetsBug/$url/recon
fi
#if [ ! -d "~/Desktop/TargetsBug/$url/recon/scans" ];then
#	mkdir  ~/Desktop/TargetsBug/$url/recon/scans
#fi
if [ ! -d "~/Desktop/TargetsBug/$url/recon/httprobe" ];then
	mkdir ~/Desktop/TargetsBug/$url/recon/httprobe
fi
if [ ! -d "~/Desktop/TargetsBug/$url/recon/potential_takeovers" ];then
	mkdir ~/Desktop/TargetsBug/$url/recon/potential_takeovers
fi
if [ ! -f "~/Desktop/TargetsBug/$url/recon/httprobe/alive.txt" ];then
	touch ~/Desktop/TargetsBug/$url/recon/httprobe/alive.txt
fi
if [ ! -f "~/Desktop/TargetsBug/$url/recon/final.txt" ];then
	touch  ~/Desktop/TargetsBug/$url/recon/final.txt
fi
if [ ! -d '$url/recon/eyewitness' ];then
    mkdir $url/recon/eyewitness
fi

echo "[*] Harvesting subdomains using ASSETFINDER..."
/home/kali/Desktop/BugBounty/Recon/assetfinder $url >> ~/Desktop/TargetsBug/$url/recon/assets.txt
cat ~/Desktop/TargetsBug/$url/recon/assets.txt | grep $1 >> ~/Desktop/TargetsBug/$url/recon/final.txt

echo "[*] ASSETFINDER Harvest Completed"

echo "[*] Probe for alive domains..."
cat ~/Desktop/TargetsBug/$url/recon/final.txt | sort -u | ./httprobe -s -p http:443 | sed 's/https\?:\/\///' |tr -d ':443' >> ~/Desktop/TargetsBug/$url/recon/httprobe/alive.txt
 
echo "[+] Checking for possible subdomain takeover..."
 
if [ ! -f "~/Desktop/TargetsBug/$url/recon/potential_takeovers/potential_takeovers.txt" ];then
	touch ~/Desktop/TargetsBug/$url/recon/potential_takeovers/potential_takeovers.txt
fi

echo "[+] Running eyewitness against all compiled domains..."
python3 ~/Desktop/BugBounty/Recon/EyeWitness/Python/EyeWitness.py --web -f ~/Desktop/TargetsBug/$url/recon/httprobe/alive.txt -d ~/Desktop/TargetsBug/$url/recon/eyewitness --resolve