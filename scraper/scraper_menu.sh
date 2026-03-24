#!/bin/sh
#echo $0 $*    # for debugging

#external (imported) variables:
#DEBUG=yes
! test -z ${PC_DEBUG} && \
    DEBUG="yes"
test -z ${ROMS} && \
    ROMS=/roms

#internal (exported) variables
if test -z "${PC_DEBUG}"; then
    export ScraperConfigFile=/mnt/apps/scraper/.scraper.cfg
    export ShellectApp=/usr/bin/shellect
    export ScraperApp=/mnt/apps/scraper/scrap_retroarch.sh
else
    export ScraperConfigFile=${HOME}/.scraper.cfg
    export ShellectApp=/usr/bin/shellect
    export ScraperApp=/usr/bin/scrap_retroarch.sh
fi

#internal variables
romname=$(basename "$1")
CurrentSystem=$(echo "$(realpath $1)" | grep -o "/$(basename ${ROMS})/[^/]*" | cut -d'/' -f3)
romNameNoExtension=${romname%.*}
romimage="${ROMS}/$CurrentSystem/.images/$romNameNoExtension.png"

#global funcitons
wait_msg() {
    if ! test -z ${PC_DEBUG}; then
        sleep 3
    else
    ## read is different in POSIX shell (should work on BusyBox)
        read -n 1 -s -r -p "Press A to continue"
    fi
}
#export wait_msg # POSIX doesn't allow exporting func.

# Check if the configuration file exists
if [ ! -f "$ScraperConfigFile" ]; then
    echo "Warning: configuration file not found, creating default in ${ScraperConfigFile}"
    wait_msg
    echo "Retroarchmedia_type = \"Named_Boxarts\"" > ${ScraperConfigFile}
fi

# for debugging
if test x"${DEBUG}" = xyes; then
    echo "CurrentSystem : $CurrentSystem"
    echo "romname : $romname"
    echo "romimage : $romimage"
    echo "romNameNoExtension : $romNameNoExtension"
    wait_msg
fi

##########################################################################################

Menu_Config() {
    Option1="Media preferences"
    Option2="Back to Main Menu"
    
    Mychoice=$( echo "$Option1\n$Option2" | ${ShellectApp} -t "      --== CONFIGURATION MENU ==--" -b "Press A to validate your choice.")

    [ "$Mychoice" = "$Option1" ] && Menu_Config_MediaType
	[ "$Mychoice" = "$Option2" ] && Menu_Main
}

Menu_Config_MediaType() {
    # Display Welcome
    clear
    echo -e 
    echo -e "====================================================\n\n"
    echo -e " The media types\n\n"
    echo -e "	RA = Retroarch\n\n"
  
    echo -e "====================================================\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	
    # retrieve current media settings
    RetroarchMediaType="$(sed -n 's:^Retroarchmedia_type = ::p' "${ScraperConfigFile}" | tr -d '"')"

    clear

    # Screenscreaper.fr
    Option01="Box Art                    (RA)"
    Option02="Screenshot - Title Screen  (RA)"
    Option03="Screenshot - In Game       (RA)"
	Option04="Back to Configuration Menu"

    Mychoice=$( echo "$Option01\n$Option02\n$Option03\n$Option04\n" | ${ShellectApp} -t\ "Current media type : $RetroarchMediaType" -b "Press A to validate your choice.")
    
    [ "$Mychoice" = "$Option01" ]  && RAmediaType="Named_Boxarts"  
    [ "$Mychoice" = "$Option02" ]  && RAmediaType="Named_Titles"  
    [ "$Mychoice" = "$Option03" ]  && RAmediaType="Named_Snaps"  
	[ "$Mychoice" = "$Option04" ]  && Menu_Config && return
					  
    clear

    sed -i "s:^Retroarchmedia_type.*:Retroarchmedia_type = \"${RAmediaType}\":g" "${ScraperConfigFile}"
    sync
    Menu_Config
}

##########################################################################################

Launch_Scraping() {
	if [ "$(ip r)" = "" ]; then 
		echo "You must be connected to wifi to use Scraper"
		wait_msg
		exit
	fi
    wait_msg
    [ "$onerom" = "1" ] && onerom="$romname" || onerom=""
    
    # run the RA script
    ${ScraperApp} $CurrentSystem "$onerom"

    if [ -f "$romimage" ] && ! [ "$onerom" = "" ] ; then
        echo "exiting $romimage"
        sleep 4 
        pkill st
    fi  # exit if only one rom must be scraped and is already found

	pkill st
}

Delete_Rom_Cover() {
    clear
    rm "${romimage}"
    echo -e "$romNameNoExtension.png\nRemoved\n"
    wait_msg
    clear
    Menu_Main
}

##########################################################################################

Menu_Main() {
    clear
    Option1="Scrape all $(basename "$CurrentSystem") roms"
    [ -f "$romimage" ] && Option2="" || Option2="Scrape current rom: $romname"
    [ -f "$romimage" ] && Option3="Delete cover: $romNameNoExtension.png" || Option3=""
    Option4="Configuration"
    Option5="Exit"

    clear
    Mychoice=$( echo "$Option1\n$Option2\n$Option3\n$Option4\n$Option5" | ${ShellectApp} -t "           --== MAIN MENU ==--" -b "                     Menu : Exit        A : Validate ")

    [ "$Mychoice" = "$Option1" ] && (onerom=0; Launch_Scraping;)
    [ "$Mychoice" = "$Option2" ] && (onerom=1; Launch_Scraping;)
    [ "$Mychoice" = "$Option3" ] && Delete_Rom_Cover
    [ "$Mychoice" = "$Option4" ] && Menu_Config
    [ "$Mychoice" = "$Option5" ] && exit
}

Menu_Main