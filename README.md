<!-- scot mcphee -->
# shell_scripts

This project is just a collection of useful shell scripts that I have written.

This is licenced to you with the GPL 3 licence. See here - [https://www.gnu.org/licenses/gpl.txt] This licence means if you use and modify any of these files you are obliged to publish and licence your now-open-source code as GPL 3 too. Feel free to borrow and modify. If you do what you think is a good modification, please return it to me (i.e. pull request).

Thanks.
Scot

## contents

* README.md - this file
* LICENCE.txt - GPL v3
* fix_mounts.sh - ensures autofs mounts are mounted by a user and not 'root'
* org.autonomous.fixmounts.plist - a macOS plist which runs the fix_mounts every 15 secs

## fix mounts

Put the fix_mounts.sh file somewhere safe. /Users/<yourusername>/bin is a good spot. Edit the top part of the shell file to customise it to your environment. See the comments in the file.

Put the org.autonomous.fixmounts.plist file in /Libraries/LaunchDaemons:

    sudo cp org.autonomous.fixmounts.plist /Libraries/LaunchDaemons

    sudo chmod 644 /Libraries/LaunchDaemons/org.autonomous.fixmounts.plist

    sudo vi /Libraries/LaunchDaemons/org.autonomous.fixmounts.plist

        #(edit the 'ProgramArguments' string value /path/to/fix_mounts.sh to point to the path where you put the shell script, e.g. /Users/<yourusername>/bin/fix_mounts.sh)

    sudo launchctl load /Library/LaunchDaemons/org.autonomous.fixmounts.plist 

    sudo tail -F /var/log/fixmounts.log

    	#(or view the log in /var/log/fixmounts.log with the Console)
    

