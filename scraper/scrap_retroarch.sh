#!/bin/sh
#echo $0 $*    # for debugging

## Externel arg. variables
current_system=$1
current_rom="$2"

## External (imported) variables
test -z "${ScraperConfigFile}" && \
	ScraperConfigFile=/mnt/apps/scraper/.scraper.cfg
test -z ${ROMS} && \
    ROMS=/roms

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
	FBA)					remoteSystem="FBNeo_-_Arcade_Games" ;; # ARCADE
	MAME)					remoteSystem="MAME" ;; # ARCADE
	NEOGEO)					remoteSystem="SNK_-_Neo_Geo" ;; # ARCADE
	CPC)					remoteSystem="Amstrad_-_CPC" ;;
	CPC)					remoteSystem="Amstrad_-_GX4000" ;;
	ARDUBOY)				remoteSystem="Arduboy_Inc_-_Arduboy" ;;
	800)					remoteSystem="Atari - 8-bit Family" ;;
	2600)					remoteSystem="Atari - 2600" ;;
	5200)					remoteSystem="Atari - 5200" ;;
	7800)					remoteSystem="Atari - 7800" ;;
	#Atari Jaguar
	LYNX)					remoteSystem="Atari - Lynx" ;;
	ST)						remoteSystem="Atari - ST" ;;
	#Atomiswave
	WSWAN)					remoteSystem="Bandai_-_WonderSwan" ;;
	WSWAN)					remoteSystem="Bandai_-_WonderSwan_Color" ;;
	#CHIP-8 - no remoteSystem=""
	MSX)					remoteSystem="Casio_-_Loopy" ;;
	#Casio PV-1000
	#Cave Story - single purpouse game
	CHAILOVE)				remoteSystem="ChaiLove" ;;
	#Cannonball - single purpouse game
	COLECOVISION)			remoteSystem="Coleco_-_ColecoVision" ;;
	C64)					remoteSystem="Commodore_-_64" ;;
	AMIGA)					remoteSystem="Commodore_-_Amiga" ;;
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
	CHANNELF)				remoteSystem="Fairchild_-_Channel_F" ;;
	FLASHBACK)				remoteSystem="Flashback" ;;
	VECTREX)				remoteSystem="GCE_-_Vectrex" ;;
	"G&W")					remoteSystem="Handheld_Electronic_Game" ;;
	GB)						remoteSystem="Nintendo_-_Game_Boy" ;;
	GB)						remoteSystem="Nintendo_-_Game_Boy_Color" ;;
	GBA)					remoteSystem="Nintendo_-_Game_Boy_Advance" ;;
	#GamePark GP32
	#Hartung Game Master
	#LeapFrog Leapster Learning Game System
	JUMPNBUMP)				remoteSystem="Jump_'n_Bump" ;;
	LOWRESNX)				remoteSystem="LowRes_NX" ;;
	LUTRO)					remoteSystem="Lutro" ;;
	ODYSSEY2)				remoteSystem="Mattel_-_Intellivision" ;;
	INT)					remoteSystem="Lutro" ;;
	#MicroW8 - no remoteSystem=""
	MSX)					remoteSystem="Microsoft_-_MSX" ;;
	MSX)					remoteSystem="Microsoft_-_MSX2" ;;
	#MrBoom - single purpouse game
	PCE)					remoteSystem="NEC_-_PC_Engine_-_TurboGrafx_16" ;;
	PCE)					remoteSystem="NEC_-_PC_Engine_-_TurboGrafx_CD" ;;
	PCE)					remoteSystem="NEC_-_PC_Engine_SuperGrafx" ;;
	PC_88)					remoteSystem="NEC_-_PC-8001_-_PC-8801" ;;
	#NEC - PC-98
	#NEC - PC-FX
	NES)					remoteSystem="Nintendo_-_Nintendo_Entertainment_System" ;;
	NES)					remoteSystem="Nintendo_-_Family_Computer_Disk_System" ;;
	POKEMINI)				remoteSystem="Nintendo_-_Pokemon_Mini" ;;
	SNES)					remoteSystem="Nintendo_-_Super_Nintendo_Entertainment_System" ;;
	#Nintendo 64
	#Nintendo DS
	#Nintendo GC
	SNES)					remoteSystem="Nintendo_-_Satellaview" ;;
	SNES)					remoteSystem="Nintendo - Sufami Turbo" ;;
	#Nintendo Wii
	#Nintendo Wii U
	#Philips CD-i
	ODYSSEY2)				remoteSystem="Philips_-_Videopac+" ;;
	PS1)					remoteSystem="Sony_-_PlayStation" ;;
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
	SHARP_X1)				remoteSystem="Sharp_-_X1" ;;
	#Sharp X68000
	SCUMMVM)				remoteSystem="ScummVM" ;;
	SMS)					remoteSystem="Sega_-_SG-1000" ;;
	SMS)					remoteSystem="Sega_-_Game_Gear" ;;
	SMS)					remoteSystem="Sega_-_Master_System_-_Mark_III" ;;
	SMD)					remoteSystem="Sega_-_Mega_Drive_-_Genesis" ;;
	SMD)					remoteSystem="Sega_-_Mega-CD_-_Sega_CD" ;;
	SMD)					remoteSystem="Sega_-_32X" ;;
	SMD)					remoteSystem="SEGA_-_PICO" ;;
	#SEGA Saturn
	#SEGA Dreamcast
	#SEGA Naomi
	#SEGA Naomi2
	#SEGA VMU - no remoteSystem=""
	Z80)					remoteSystem="Sinclair_-_ZX_Spectrum" ;;
	ZX81)					remoteSystem="Sinclair_-_ZX_81" ;;
	#SNK Neo Geo CD
	NGP)					remoteSystem="SNK_-_Neo_Geo_Pocket" ;;
	NGP)					remoteSystem="SNK_-_Neo_Geo_Pocket_Color" ;;
	MSX)					remoteSystem="Spectravideo_-_SVI-318_-_SVI-328" ;;
	#Texas Instruments - no remoteSystem=""
	#The 3DO
	TIC80)					remoteSystem="TIC-80" ;;
	THOMSON)				remoteSystem="Thomson_-_MOTO" ;;
	#Tiger Game.com
	#Tomb Raider - TODO
	#VTech CreatiVision
	#VTech V.Smile
	#Vircon32
	WASM4)					remoteSystem="WASM-4" ;;
	SUPERVISION)			remoteSystem="Watara_-_Supervision" ;;
	WOLFENSTEIN3D)			remoteSystem="Wolfenstein_3D" ;;
	#VaporSpec - no remoteSystem=""
	*)
		echo "unknown system, exiting."
		exit
		;;
esac
}

#Retroarch system folder name
get_ra_alias $current_system
mkdir -p $HOME${ROMS}/$current_system/.images &> /dev/null
clear
echo -e "\n*****************************************************"
echo -e "*******************   RETROARCH   *******************"
echo -e "*****************************************************\n\n"

if test -f "${ScraperConfigFile}"; then
	media_type="$(sed -n 's:^Retroarchmedia_type = ::p' "${ScraperConfigFile}" | tr -d '"')"
else
	media_type="Named_Boxarts"
fi
if [ -z "$media_type" ] && [ "$media_type" != "Named_Boxarts" ] && [ "$media_type" != "Named_Titles" ] || [ "$media_type" != "Named_Snaps" ]; then
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

## Debug
#eval echo "find $HOME${ROMS}/$current_system -maxdepth 2 -type f ! -name '.*' ! -name '*.xml' ! -name '*.db' ! -path '*/.images/*' ! -path '*/.*/*' $romfilter"
for file in $(eval "find $HOME${ROMS}/$current_system -maxdepth 2 -type f \
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
			
		FILE=$HOME${ROMS}/$current_system/.images/$romNameNoExtension.png
		if [ -f "$FILE" ]; then
			echo -e "${YELLOW}already Scraped !${NONE}"
			scrap_notrequired=$((scrap_notrequired + 1))
		else
			wget -q --spider "http://thumbnails.libretro.com/$remoteSystemNoSpace/${media_type}/$romNameNoExtensionNoSpace.png" 2>&1
			WgetResult=$?
	
			if [ $WgetResult = 0 ] ; then
				wget -q  "http://thumbnails.libretro.com/$remoteSystemNoSpace/${media_type}/$romNameNoExtensionNoSpace.png" -O "$HOME${ROMS}/$current_system/.images/$romNameNoExtension.png"

				## Resizing :
				#magick "$HOME${ROMS}/$current_system/.images/$romNameNoExtension.png" -resize 250x360 "$HOME${ROMS}/$current_system/.images/$romNameNoExtension-resized.png"
				#mv "$HOME${ROMS}/$current_system/.images/$romNameNoExtension-resized.png"  "$HOME${ROMS}/$current_system/.images/$romNameNoExtension.png"
				
				#pngScale "$HOME${ROMS}/$current_system/.images/$romNameNoExtension.png" "$HOME${ROMS}/$current_system/.images/$romNameNoExtension.png"

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