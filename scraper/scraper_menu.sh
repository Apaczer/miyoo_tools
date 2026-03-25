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
    export ScraperApp=/mnt/apps/scraper/scraper_libretro.sh
else
    export ScraperConfigFile=${HOME}/.scraper.cfg
    export ShellectApp=/usr/bin/shellect
    export ScraperApp=/usr/bin/scraper_libretro.sh
fi

#global funcitons
## POSIX doesn't allow exporting func. !!
wait_msg() {
    if ! test -z ${PC_DEBUG}; then
        sleep 3
    else
    ## read is different in POSIX shell (should work on BusyBox)
        read -n 1 -s -r -p "Press START to continue"
    fi
}

echo_psx() {
    if ! test -z ${PC_DEBUG}; then
        #echo in real POSIX shell does't use opt parameters like `-e` (only \n in [string])
        echo "$1"
    else
        #echo with in BUSYBOX is more like dash, need to use `-e` opt and add escape operands like \n
        echo -e "$1"
    fi
}

if [ -z "$1" ]; then
    #for PC_DEBUG run e.g. ROMS=/home/roms PC_DEBUG=1 ./scraper_menu.sh ./roms/NES/Battletoads\ \(USA\).nes
    echo_psx "\nusage : scraper_menu.sh [ROM_PATH]\nexample : scraper_menu.sh /roms/NES/Battletoads\ \(USA\).nes\n"
    exit
fi

#internal variables
romname=$(basename "$1")
CurrentSystem=$(echo "$(realpath $1)" | grep -o "/$(basename ${ROMS})/[^/]*" | cut -d'/' -f3)
romNameNoExtension=${romname%.*}
romimage="${ROMS}/$CurrentSystem/.images/$romNameNoExtension.png"

# Check if the configuration file exists
if [ ! -f "$ScraperConfigFile" ]; then
    echo "Warning: configuration file not found, creating default in ${ScraperConfigFile}"
    wait_msg
    echo "LibretroMedia_type = \"Named_Boxarts\"" > ${ScraperConfigFile}
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
    
    Mychoice=$( echo_psx "$Option1\n$Option2" | ${ShellectApp} -t "      --== CONFIGURATION MENU ==--" -b "Press Start/Y/Right to select.")

    [ "$Mychoice" = "$Option1" ] && Menu_Config_MediaType
    [ "$Mychoice" = "$Option2" ] && Menu_Main
}

Menu_Config_MediaType() {
    # Display Welcome
    clear
    echo_psx 
    echo_psx "====================================================\n\n"
    echo_psx " The media types\n\n"
    echo_psx "	LR = Libretro\n\n"
  
    echo_psx "====================================================\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    sleep 1.5 # display shortly above screen

    # retrieve current media settings
    LibretroMediaType="$(sed -n 's:^LibretroMedia_type = ::p' "${ScraperConfigFile}" | tr -d '"')"

    clear

    # thumbnails.libretro.com
    Option01="Box Art                    (LR)"
    Option02="Screenshot - Title Screen  (LR)"
    Option03="Screenshot - In Game       (LR)"
    Option04="Back to Configuration Menu"

    Mychoice=$( echo_psx "$Option01\n$Option02\n$Option03\n$Option04\n"\
                 | ${ShellectApp} -t\ "Current media type : $LibretroMediaType" -b "Press Start/Y/Right to select.")
    
    [ "$Mychoice" = "$Option01" ]  && LRmediaType="Named_Boxarts"  
    [ "$Mychoice" = "$Option02" ]  && LRmediaType="Named_Titles"  
    [ "$Mychoice" = "$Option03" ]  && LRmediaType="Named_Snaps"  
    [ "$Mychoice" = "$Option04" ]  && Menu_Config && return

    clear

    sed -i "s:^LibretroMedia_type.*:LibretroMedia_type = \"${LRmediaType}\":g" "${ScraperConfigFile}"
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

    # run the Libretro Scraper script
    ${ScraperApp} $CurrentSystem "$onerom"

    if [ -f "$romimage" ] && ! [ "$onerom" = "" ] ; then
        echo "exiting $romimage"
        sleep 4 
        exit
    fi  # exit if only one rom must be scraped and is already found

    exit
}

Delete_Rom_Cover() {
    clear
    rm "${romimage}"
    echo_psx "$romNameNoExtension.png\nRemoved\n"
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
    Mychoice=$( echo_psx "$Option1\n$Option2\n$Option3\n$Option4\n$Option5"\
                 | ${ShellectApp} -t "           --== MAIN MENU ==--" -b "   Select(hold): Exit        Start/Y/Right: Choose.  ")
    case "$Mychoice" in
        "$Option1")
            onerom=0
            Launch_Scraping
            ;;
        "$Option2")
            test -z "$Option2" && exit # sanity check for Escape press
            onerom=1
            Launch_Scraping
            ;;
        "$Option3")
            test -z "$Option3" && exit # sanity check for Escape press
            Delete_Rom_Cover;;
        "$Option4") 
            Menu_Config;;
        *) exit;;
    esac
}

Menu_Main
