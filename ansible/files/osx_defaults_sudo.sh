# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0

# Disable the sudden motion sensor as it’s not useful for SSDs
sudo pmset -a sms 0

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
# sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

###############################################################################
# Time Machine                                                                #
###############################################################################

# Disable local Time Machine backups
sudo tmutil disablelocal

###############################################################################
# Security                                                                    #
###############################################################################

# When macOS connects to new networks, it probes the network and launches a
# Captive Portal assistant utility if connectivity can't be determined.  An
# attacker could trigger the utility and direct a Mac to a site with malware
# without user interaction, so it's best to disable this feature and log in to
# captive portals using your regular Web browser, provided you have first disable
# any custom dns and/or proxy settings.
defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false
