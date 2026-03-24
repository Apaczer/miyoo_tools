#!/bin/sh
#echo $0 $*    # for debugging

## Externel arg. variables
current_system=$1
current_rom="$2"
#DEBUG=yes
#${PC_DEBUG}
! test -z ${PC_DEBUG} && \
	DEBUG="yes"

# global functions
wait_msg() {
	if ! test -z ${PC_DEBUG}; then
		sleep 3
	else
	## read is different in POSIX shell (should work on BusyBox)
		read -n 1 -s -r -p "Press START to continue"
	fi
}

## External (imported) variables
test -z "${ScraperConfigFile}" && \
	ScraperConfigFile=/mnt/apps/scraper/.scraper.cfg
test -z ${ROMS} && \
	ROMS=/roms

if test x"$DEBUG" = "xyes"; then
	echo "DEBUG=$DEBUG"
	echo "PC_DEBUG=$PC_DEBUG"
	echo "ROMS=$ROMS\n"
	echo "current_system=${current_system}"
	echo "current_rom=${current_rom}\n"
	wait_msg
fi

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

get_ra_alias(){
	# find the corresponding remoteSystem for Retroarch scraping
	case $1 in # in order from rascraper
		FBA)					remoteSystem="FBNeo - Arcade Games" ;; # ARCADE
		MAME)					remoteSystem="MAME" ;; # ARCADE
		NEOGEO)					remoteSystem="SNK - Neo Geo" ;; # ARCADE
		CPC)					remoteSystem="Amstrad - CPC" ;;
		CPC)					remoteSystem="Amstrad - GX4000" ;;
		ARDUBOY)				remoteSystem="Arduboy Inc - Arduboy" ;;
		800)					remoteSystem="Atari - 8-bit Family" ;;
		2600)					remoteSystem="Atari - 2600" ;;
		5200)					remoteSystem="Atari - 5200" ;;
		7800)					remoteSystem="Atari - 7800" ;;
		#Atari Jaguar
		LYNX)					remoteSystem="Atari - Lynx" ;;
		ST)						remoteSystem="Atari - ST" ;;
		#Atomiswave
		WSWAN)					remoteSystem="Bandai - WonderSwan" ;;
		WSWAN)					remoteSystem="Bandai - WonderSwan Color" ;;
		#CHIP-8 - no remoteSystem=""
		MSX)					remoteSystem="Casio - Loopy" ;;
		#Casio PV-1000
		#Cave Story - single purpouse game
		CHAILOVE)				remoteSystem="ChaiLove" ;;
		#Cannonball - single purpouse game
		COLECOVISION)			remoteSystem="Coleco - ColecoVision" ;;
		C64)					remoteSystem="Commodore - 64" ;;
		AMIGA)					remoteSystem="Commodore - Amiga" ;;
		#Commodore CD32
		#Commodore CDTV
		#Commodore PET
		#Commodore Plus-4
		#Commodore VIC-20
		DOOM)					remoteSystem="DOOM" ;;
		DOS)					remoteSystem="DOS" ;;
		#Dinothawr - single purpouse game
		#Emerson Arcadia 2001
		#Entex Adventure Vision
		#Epoch Super Cassette Vision
		#Elektronika BK - no remoteSystem=""
		CHANNELF)				remoteSystem="Fairchild - Channel F" ;;
		FLASHBACK)				remoteSystem="Flashback" ;;
		VECTREX)				remoteSystem="GCE - Vectrex" ;;
		"G&W")					remoteSystem="Handheld Electronic Game" ;;
		GB)						remoteSystem="Nintendo - Game Boy" ;;
		GB)						remoteSystem="Nintendo - Game Boy Color" ;;
		GBA)					remoteSystem="Nintendo - Game Boy Advance" ;;
		#GamePark GP32
		#Hartung Game Master
		#LeapFrog Leapster Learning Game System
		JUMPNBUMP)				remoteSystem="Jump 'n Bump" ;;
		LOWRESNX)				remoteSystem="LowRes NX" ;;
		LUTRO)					remoteSystem="Lutro" ;;
		ODYSSEY2)				remoteSystem="Mattel - Intellivision" ;;
		INT)					remoteSystem="Lutro" ;;
		#MicroW8 - no remoteSystem=""
		MSX)					remoteSystem="Microsoft - MSX" ;;
		MSX)					remoteSystem="Microsoft - MSX2" ;;
		#MrBoom - single purpouse game
		PCE)					remoteSystem="NEC - PC Engine - TurboGrafx 16" ;;
		PCE)					remoteSystem="NEC - PC Engine - TurboGrafx CD" ;;
		PCE)					remoteSystem="NEC - PC Engine SuperGrafx" ;;
		PC_88)					remoteSystem="NEC - PC-8001 - PC-8801" ;;
		#NEC - PC-98
		#NEC - PC-FX
		NES)					remoteSystem="Nintendo - Nintendo Entertainment System" ;;
		NES)					remoteSystem="Nintendo - Family Computer Disk System" ;;
		POKEMINI)				remoteSystem="Nintendo - Pokemon Mini" ;;
		SNES)					remoteSystem="Nintendo - Super Nintendo Entertainment System" ;;
		#Nintendo 64
		#Nintendo DS
		#Nintendo GC
		SNES)					remoteSystem="Nintendo - Satellaview" ;;
		SNES)					remoteSystem="Nintendo - Sufami Turbo" ;;
		#Nintendo Wii
		#Nintendo Wii U
		#Philips CD-i
		ODYSSEY2)				remoteSystem="Philips - Videopac+" ;;
		PS1)					remoteSystem="Sony - PlayStation" ;;
		#PS2
		#PS3
		#PSP
		#PSVITA
		QUAKE_1)				remoteSystem="Quake" ;;
		#Quake II - TODO
		#Quake III
		#RCA Studio II
		#RPG Maker - TODO
		#Rick Dangerous - single purpouse game 
		SHARP_X1)				remoteSystem="Sharp - X1" ;;
		#Sharp X68000
		SCUMMVM)				remoteSystem="ScummVM" ;;
		SMS)					remoteSystem="Sega - SG-1000" ;;
		SMS)					remoteSystem="Sega - Game Gear" ;;
		SMS)					remoteSystem="Sega - Master System - Mark III" ;;
		SMD)					remoteSystem="Sega - Mega Drive - Genesis" ;;
		SMD)					remoteSystem="Sega - Mega-CD - Sega CD" ;;
		SMD)					remoteSystem="Sega - 32X" ;;
		SMD)					remoteSystem="SEGA - PICO" ;;
		#SEGA Saturn
		#SEGA Dreamcast
		#SEGA Naomi
		#SEGA Naomi2
		#SEGA VMU - no remoteSystem=""
		Z80)					remoteSystem="Sinclair - ZX Spectrum" ;;
		ZX81)					remoteSystem="Sinclair - ZX 81" ;;
		#SNK Neo Geo CD
		NGP)					remoteSystem="SNK - Neo Geo Pocket" ;;
		NGP)					remoteSystem="SNK - Neo Geo Pocket Color" ;;
		MSX)					remoteSystem="Spectravideo - SVI-318 - SVI-328" ;;
		#Texas Instruments - no remoteSystem=""
		#The 3DO
		TIC80)					remoteSystem="TIC-80" ;;
		THOMSON)				remoteSystem="Thomson - MOTO" ;;
		#Tiger Game.com
		#Tomb Raider - TODO
		#VTech CreatiVision
		#VTech V.Smile
		#Vircon32
		WASM4)					remoteSystem="WASM-4" ;;
		SUPERVISION)			remoteSystem="Watara - Supervision" ;;
		WOLFENSTEIN3D)			remoteSystem="Wolfenstein 3D" ;;
		#VaporSpec - no remoteSystem=""
	*)
		echo "unknown system, exiting."
		exit
		;;
esac
}

#Retroarch system folder name
get_ra_alias $current_system
mkdir -p ${ROMS}/$current_system/.images &> /dev/null
clear
echo -e "\n*****************************************************"
echo -e "*******************   RETROARCH   *******************"
echo -e "*****************************************************\n\n"

if test -f "${ScraperConfigFile}"; then
	media_type="$(sed -n 's:^Retroarchmedia_type = ::p' "${ScraperConfigFile}" | tr -d '"')"
else
	media_type="Named_Boxarts"
fi
if [ -z "$media_type" ] && [ "$media_type" != "Named_Boxarts" ] && [ "$media_type" != "Named_Titles" ] && [ "$media_type" != "Named_Snaps" ]; then
	echo -e " The currently selected media ($media_type)\n is not compatible with Retroarch scraper.\n\n\n\n\n\n\n\n\n\n\n\n Exiting."
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

test x"$DEBUG" = "xyes" && \
	eval echo "find ${ROMS}/$current_system -maxdepth 2 -type f ! -name '.*' ! -name '*.xml' ! -name '*.db' ! -path '*/.images/*' ! -path '*/.*/*' $romfilter"
for file in $(eval "find ${ROMS}/$current_system -maxdepth 2 -type f \
	! -name '.*' ! -name '*.xml' ! -name '*.cfg' ! -name '*.db' \
	! -path '*/.images/*' ! -path '*/.*/*' $romfilter"); do
	
	echo "-------------------------------------------------"
	romcount=$((romcount + 1))
	
	# Cleaning up names
	romName=$(basename "$file")
	romNameNoExtension=${romName%.*}	
	romNameNoExtensionNoSpace=$(echo $romNameNoExtension | sed 's/ /%20/g')
	
	echo $romNameNoExtension
	test x"$DEBUG" = "xyes" && \
		echo -e "$romNameNoExtension \n   ---- $romNameNoExtensionNoSpace"
	
	remoteSystemNoSpace=$(echo $remoteSystem | sed 's/ /%20/g')
	
	startcapture=true

	if [ $startcapture = true ]; then
			
		FILE=${ROMS}/$current_system/.images/$romNameNoExtension.png
		if [ -f "$FILE" ]; then
			echo -e "${YELLOW}already Scraped !${NONE}"
			scrap_notrequired=$((scrap_notrequired + 1))
		else
			test x"$DEBUG" = "xyes" && \
				echo "Calling: http://thumbnails.libretro.com/$remoteSystemNoSpace/${media_type}/$romNameNoExtensionNoSpace.png"
			wget -q --spider "http://thumbnails.libretro.com/$remoteSystemNoSpace/${media_type}/$romNameNoExtensionNoSpace.png" 2>&1
			WgetResult=$?
	
			if [ $WgetResult = 0 ] ; then
				wget -q  "http://thumbnails.libretro.com/$remoteSystemNoSpace/${media_type}/$romNameNoExtensionNoSpace.png" -O "${ROMS}/$current_system/.images/$romNameNoExtension.png"

				## Resizing :
				#magick "${ROMS}/$current_system/.images/$romNameNoExtension.png" -resize 250x360 "${ROMS}/$current_system/.images/$romNameNoExtension-resized.png"
				#mv "${ROMS}/$current_system/.images/$romNameNoExtension-resized.png"  "${ROMS}/$current_system/.images/$romNameNoExtension.png"
				
				#pngScale "${ROMS}/$current_system/.images/$romNameNoExtension.png" "${ROMS}/$current_system/.images/$romNameNoExtension.png"

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