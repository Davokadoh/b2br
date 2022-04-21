#!/bin/bash

apt install sudo openssh-server ufw libpam-pwquality vim net-tools
adduser jleroux sudo

#SUDO
mkdir /var/log/sudo
echo '
Defaults	passwd_tries=3
Defaults	badpass_message="Wrong password"
Defaults	logfile="/var/log/sudo/sudolog"
Defaults	log_input,log_output
Defaults	iolog_dir="/var/log/sudo"
Defaults	requiretty
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"' > /etc/sudoers.d/config

#SSH
sed -i -e 's/#Port 22/Port 4242/g' /etc/ssh/sshd_config
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
service ssh restart
#service ssh status

#UFW
ufw enable
ufw allow 4242
#ufw status

#PASSWORDS POLICY
sed -i -e 's/PASS_MAX_DAYS 99999/PASS_MAX_DAYS 30/g' /etc/pam.d/common-password
sed -i -e 's/PASS_MIN_DAYS 0/PASS_MIN_DAYS 2/g' /etc/pam.d/common-password
sed -i -e 's/password	requisite pam_pwquality.so retry=3/password	requisite pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root/g' /etc/pam.d/common-password

#USER MANAGEMENT
addgroup user42
adduser jleroux user42

#CRON
wget monitoring.sh
touch tmpfile
echo '*/10 * * * * sh /usr/local/monitoring.sh' > tmpfile
crontab -u root tmpfile
rm tmpfile

#CLEANUP
rm install.sh

reboot now
