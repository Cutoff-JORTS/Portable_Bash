This repo contains portable, ready-to-run bash scripts.

I will update further documentation as I populate this repository.

For now, it includes:
- SensorLog: this script is designed to run as a background task (temporarily) or an ongoing systemd service (for logging purposes). It pulls quick snapshot information including OS details, current users logged in, thermal sensors (if applicable), network statistics/connections, filesystem occupancy & directory sizes, and more. By default, this script will log to the home directory for user 1000 (often the default administrator account). Log locations & filesystems to be scanned can be adjusted and are clearly indicated in the script via comments.

Thanks for coming, and please reach out via https://jorts.tech/contact (or email the team at jorts.tech@gmail.com) with any questions or feedback.