#!/bin/busybox sh

# Requires ShellectApp=/usr/bin/shellect
if ! command -v shellect > /dev/null; then
	echo "ERROR: Missing dependence! Please install \"shellect\" script in your PATH from https://github.com/huijunchen9260/shellect !"
	sleep 2
	exit
fi

content="$1"

consent_msg_func() {
	Option1="Continue"
	Option2="Exit/Abort"

	top_msg="This launcher creates DOSBOX.BAT in ${content}"
	bottom_msg="   Select(hold): Exit        Start/Y/Right: Choose.  "

	Mychoice=$( echo -e "$Option1\n$Option2\n$Option3\n$Option4\n$Option5"\
				 | shellect -t "$top_msg" -b "$bottom_msg")
	case "$Mychoice" in
		"$Option1")
			return;
			;;
		*) exit;;
	esac
}

wait_msg_func() {
	## read is different in POSIX shell (should work on BusyBox)
	echo
	read -n 1 -s -r -p "Press START to continue"
	echo
}

consent_msg_func

write_success=false
if test -d "$content"; then
	#Directory path
	find "${content}" -printf '%P\n' | shellect | sed 's:/:\\:g' | tee "${content}"/DOSBOX.BAT \
	 && write_success=true
elif test -f "$content"; then
	#test
	if zip -T "$content" >/dev/null ; then
		#ZIP archive
		unzip -l "${content}" | tr -s ' ' | cut -d' ' -f5 | grep -Ei "EXE|BAT|COM" | shellect | sed 's:/:\\:g' | tee DOSBOX.BAT && zip -m "${content}" DOSBOX.BAT >/dev/null \
		 && write_success=true
	elif 7zr t -bb0 -ba "${content}" >/dev/null 2>&1 ; then
		#7Z archive (exclude -f5 column with 0 size calculated?)
		7zr l -ba "${content}" | sed 's/ \+/\t/g' | cut -f6 | grep -Ei "EXE|BAT|COM" | shellect | sed 's:/:\\:g' | tee DOSBOX.BAT && 7z a -sdel "${content}" DOSBOX.BAT >/dev/null \
		 && write_success=true
	else
		echo -en "\nWARNING: The provided ${content} should be either directory or 7Z|ZIP archive file to generate/add DOSBOX.BAT"
		wait_msg_func
		exit
	fi
fi

if $write_success; then
	echo -en "\nSuccesfuly generated DOSBOX.BAT in ${content}"
else
	echo -en "\nERROR: there was an issue generating DOSBOX.BAT in ${content}..."
fi
wait_msg_func