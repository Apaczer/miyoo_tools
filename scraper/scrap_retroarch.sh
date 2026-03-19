#!/bin/sh
#echo $0 $*    # for debugging

## Externel variables
# current_system=${1}
# current_rom="${2}"
# ss_media_type="${ss_media_type}"

if [ -z "$1" ]
then
  echo -e "\nusage : scrap_retroarch.sh emu_folder_name [rom_name]\nexample : scrap_retroarch SFC\n"
  exit
fi

NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\x1b[5m'

romcount=0
scrap_success=0
scrap_fail=0
scrap_notrequired=0

current_system=$1
current_rom="$2"

get_ra_alias(){
	# find the corresponding remoteSystem for Retroarch scraping
case $1 in
	2600)					remoteSystem="Atari - 2600" ;;
	*)
		echo "unknown system, exiting."
		exit
		;;
esac

}



#Retroarch system folder name
get_ra_alias $current_system
mkdir -p $HOME/roms/$current_system/.images &> /dev/null
clear
echo -e "\n*****************************************************"
echo -e "*******************   RETROARCH   *******************"
echo -e "*****************************************************\n\n"

#media_type="$(sed -n 's:^Retroarchmedia_type = ::p' "${config}" | tr -d '"')"
media_type="Named_Boxarts"
if [ -z "$media_type" ]; then
	echo -e " The currently selected media ($ss_media_type)\n is not compatible with Retroarch scraper.\n\n\n\n\n\n\n\n\n\n\n\n Exiting."
	sleep 5
	exit
fi
echo "Media Type: $media_type"
echo -e "Scraping $current_system...\n"
			
			
# =================
#this is a trick to manage spaces from find command, do not indent or modify
IFS='
'
set -f
# =================


#Roms loop
if ! [ -z "$current_rom" ]; then
	romfilter="-name \"*$(echo "$current_rom" | sed -e 's_\[_\\\[_g' -e 's_\]_\\\]_g')*\""
fi

## Debug
#eval echo "find $HOME/roms/$current_system -maxdepth 2 -type f ! -name '.*' ! -name '*.xml' ! -name '*.db' ! -path '*/.images/*' ! -path '*/.*/*' $romfilter"
for file in $(eval "find $HOME/roms/$current_system -maxdepth 2 -type f \
	! -name '.*' ! -name '*.xml' ! -name '*.cfg' ! -name '*.db' \
	! -path '*/.images/*' ! -path '*/.*/*' $romfilter"); do
	
	echo "-------------------------------------------------"
	romcount=$((romcount + 1))
	
	# Cleaning up names
	romName=$(basename "$file")
	romNameNoExtension=${romName%.*}	
	romNameNoExtensionNoSpace=$(echo $romNameNoExtension | sed 's/ /%20/g')
	
	echo $romNameNoExtension
	## Debug
	#echo -e "$romNameNoExtension \n   ---- $romNameNoExtensionNoSpace"
	
	remoteSystemNoSpace=$(echo $remoteSystem | sed 's/ /%20/g')
	
	startcapture=true
	 
	
	if [ $startcapture = true ]; then
			
		FILE=$HOME/roms/$current_system/.images/$romNameNoExtension.png
		if [ -f "$FILE" ]; then
			echo -e "${YELLOW}already Scraped !${NONE}"
			scrap_notrequired=$((scrap_notrequired + 1))
		else
			wget -q --spider "http://thumbnails.libretro.com/$remoteSystemNoSpace/${media_type}/$romNameNoExtensionNoSpace.png" 2>&1
			WgetResult=$?
	
			if [ $WgetResult = 0 ] ; then
				wget -q  "http://thumbnails.libretro.com/$remoteSystemNoSpace/${media_type}/$romNameNoExtensionNoSpace.png" -O "$HOME/roms/$current_system/.images/$romNameNoExtension.png"

				## Resizing :
				#magick "$HOME/roms/$current_system/.images/$romNameNoExtension.png" -resize 250x360 "$HOME/roms/$current_system/.images/$romNameNoExtension-resized.png"
				#mv "$HOME/roms/$current_system/.images/$romNameNoExtension-resized.png"  "$HOME/roms/$current_system/.images/$romNameNoExtension.png"
				
				#pngScale "$HOME/roms/$current_system/.images/$romNameNoExtension.png" "$HOME/roms/$current_system/.images/$romNameNoExtension.png"

				echo -e "${GREEN}Scraped!${NONE}"
				scrap_success=$((scrap_success + 1));
			else
				echo -e "${RED}No match found${NONE}"
				scrap_fail=$((scrap_fail + 1));
			fi
		fi
	
	
	fi
done

echo -e "\n--------------------------"
echo "Total scanned roms	: $romcount"
echo "--------------------------"
echo "Successfully scraped	: $scrap_success"
echo "Alread present		: $scrap_notrequired"
echo "Failed or not found	: $scrap_fail"
echo -e "--------------------------\n"
sleep 2
echo "**********   Retroarch scraping finished   **********"
