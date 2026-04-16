#!/bin/busybox sh

# Requires ShellectApp=/usr/bin/shellect
if ! command -v shellect > /dev/null; then
	echo "ERROR: Missing dependence! Please install \"shellect\" script in your PATH from https://github.com/huijunchen9260/shellect !"
	sleep 2
	exit
fi

content="$1"

wait_msg_func() {
	## read is different in POSIX shell (should work on BusyBox)
	echo
	read -n 1 -s -r -p "Press any key to continue"
	echo
}

consent_msg_func() {
	option1="Continue"
	option2="Show DOSBOX.BAT" 
	option3="Exit/Abort"

	top_msg="This launcher creates DOSBOX.BAT in ${content}"
	bottom_msg="   Select(hold): Exit        Start/Y/Right: Choose.  "

	my_choice=$( echo -e "$option1\n$option2\n$option3" \
				 | shellect -t "$top_msg" -b "$bottom_msg")
	case "$my_choice" in
		"$option1")
			return;
			;;
		"$option2")
			show_bat=yes
			return;
			;;
		*) exit;;
	esac
}

# shellcheck disable=SC2120 #doesn't detect piping in func.
sellect_file_func() {
	top_msg="Select a file to be called from the DOSBOX.BAT"
	bottom_msg="   Select(hold): Exit        Start/Y/Right: Choose.  "

	my_choice=$(shellect -t "$top_msg" -b "$bottom_msg" "$1")
	#Sanity check for Escape press (thus empty output)
	if ! test -z "${my_choice}"; then
		echo "$my_choice"
	else
		exit
	fi
}

consent_msg_func

write_success=false
read_success=false
if test -d "$content"; then
	#Directory path
	if test x"$show_bat" = "xyes"; then
		cat DOSBOX.BAT \
		 && read_success=true
	else
		find "${content}" -printf '%P\n' | shellect | sed 's:/:\\:g' | tee "${content}"/DOSBOX.BAT \
		 && write_success=true
	fi
elif test -f "$content"; then
	#test
	if zip -T "$content" >/dev/null 2>&1; then #BusyBox v1.35.0 bug: calling zip -T calls also uznzip with bad opt
		#ZIP archive
		if test x"$show_bat" = "xyes"; then
			#BusyBox bug: the -p opt always return 0;
			read_content="$(unzip -p "${content}" DOSBOX.BAT)"
			! test -z "$read_content" \
			 && { read_success=true ; echo "$read_content" ; }
		else
			unzip -l "${content}" | tr -s ' ' | cut -d' ' -f5 | grep -Ei "EXE|BAT|COM" | sellect_file_func | sed 's:/:\\:g' | tee DOSBOX.BAT && zip -m "${content}" DOSBOX.BAT >/dev/null \
			 && write_success=true
		fi
	elif 7zr t -bb0 -ba "${content}" >/dev/null 2>&1; then
		#7Z archive (exclude -f5 column with 0 size calculated?)
		if test x"$show_bat" = "xyes"; then
			7zr e -so "${content}" DOSBOX.BAT \
			 && read_success=true
		else
			7zr l -ba "${content}" | sed 's/ \+/\t/g' | cut -f6 | grep -Ei "EXE|BAT|COM" | sellect_file_func | sed 's:/:\\:g' | tee DOSBOX.BAT && 7z a -sdel "${content}" DOSBOX.BAT >/dev/null \
			 && write_success=true
		fi
	else
		echo -en "\nWARNING: The provided ${content} should be either directory or 7Z|ZIP archive file to generate/add DOSBOX.BAT"
		wait_msg_func
		exit
	fi
fi

if $write_success; then
	echo -en "\nSuccesfuly generated DOSBOX.BAT in ${content}"
elif $read_success; then
	echo
else
	echo -en "\nERROR: there was an issue generating/reading DOSBOX.BAT in ${content}..."
fi
wait_msg_func