This repo contains portable, ready-to-run bash scripts.

I will update further documentation as I populate this repository.

For now, it includes:
- **SensorLog**: this script is designed to run as a background task (temporarily) or an ongoing systemd service (for logging purposes). It pulls quick snapshot information including OS details, current users logged in, thermal sensors (if applicable), network statistics/connections, filesystem occupancy & directory sizes, and more. By default, this script will log to the home directory for user 1000 (often the default administrator account). Log locations & filesystems to be scanned can be adjusted and are clearly indicated in the script via comments.

- **ManualBkup**: This is meant to be installed/left on a backup media, and requires the user to configure the "destination" upon setup. Beyond setup, any additional source folders for backup can be added to a self-contained target file. When run, it will back up all directories listed in the sources.list file (included) to a **user-defined** destination folder. **THIS SCRIPT WILL NOT FUNCTION WITHOUT A USER-DEFINED DESTINATION FOLDER.**
	>> open /ManualBkup/manual.bkup.sh with your favorite text editor, and add your desired destination to the script. 


Thanks for coming, and please reach out via https://jorts.tech/contact (or email the team at jorts.tech@gmail.com) with any questions or feedback.

*Special credit & shoutouts to: Chelsea Z. (alpha tester), Josuas A. (alpha tester)