#!/bin/sh
#
# fix_mounts.sh - ensures autofs mounts are mounted by a user and not 'root'
#
# copyright 2016 scot.mcphee@gmail.com 
#
# GPL 3.0 LICENCE https://www.gnu.org/licenses/gpl.txt
#
# This file should be run by 'root' as the 'sudo' should execute without stopping
# to ask for your password, unless you run this manually. See the
# org.autonomous.fixmounts.plist file which accompanies it. This plist executes 
# the script every 15 seconds. I put mine in /Library/LaunchDaemons  where it will 
# be run as root whether there is a user logged in or not.
#
# autofsname   - the name of the file in /etc/ that is specified in auto_master
#                e.g. 
#                /- auto_nas -nosuid
#                then it's 'auto_nas'
#
# mnt_usr  - the userid of the user (you) that you want the mounts for
# mnt_pnt  - the directory in the user dir where the mounts are
# t_mnt    - using $mnt_usr and $mnt_pnt; the full path to the mounts
# mounts   - space-separated list of mounts expected in $t_mnt

autofsname=auto_nas
mnt_usr=smcphee
mnt_pnt=Mounts
t_mnt=/Users/${mnt_usr}/${mnt_pnt}
mounts="special media Erato"

# don't change below here unless you know what you are doing with shell scripts.

all_mounts=`/sbin/mount | /usr/bin/grep $t_mnt | /usr/bin/grep -v "map $autofsname on $t_mnt"`

d=`/bin/date`
echo "fix_mounts [$d] checking $t_mnt for $mounts"
for mt in $mounts;
do
	full_mount=${t_mnt}/${mt}
	if [[ $all_mounts == *"$full_mount"* ]]; 
	then
		# it is mounted, let us see if it mounted by the user.
		mm=`/bin/echo "$all_mounts" | /usr/bin/grep $full_mount` 
		if [[ ! $mm =~ on.$full_mount.*mounted.by.$mnt_usr ]]; then
			echo "fix_mounts [$d] Remounting: $full_mount - because $mnt_usr not mounted $mm"
			/usr/bin/sudo /sbin/umount $full_mount 
			# if resource is busy force unmount with diskutil DANGER
			if [ ! $? ]; then /usr/sbin/diskutil unmount force $full_mount; fi
	        /usr/bin/sudo -u $mnt_usr cd $full_mount 
		fi
	else
		echo "fix_mounts [$d] Not mounted: $full_mount - ignoring"
	fi
done

