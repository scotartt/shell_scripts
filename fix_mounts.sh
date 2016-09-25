#!/bin/sh
#
# this file should be run by 'root'. put it in your root crontab.
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
# echo "$all_mounts"

for mt in $mounts;
do
	full_mount=${t_mnt}/${mt}
	if [[ $all_mounts == *"$full_mount"* ]]; 
	then
		# it is mounted, let us see if it mounted by the user.
		mm=`/bin/echo "$all_mounts" | /usr/bin/grep $full_mount` 
		if [[ ! $mm =~ on.$full_mount.*mounted.by.$mnt_usr ]]; then
			# echo "it is NOT mounted: $mm"
			/usr/bin/sudo /sbin/umount $full_mount 
			# if resource is busy force unmount with diskutil DANGER
			if [ ! $? ]; then /usr/sbin/diskutil unmount force $full_mount; fi
	        /usr/bin/sudo -u $mnt_usr cd $full_mount 
		fi
	fi
done