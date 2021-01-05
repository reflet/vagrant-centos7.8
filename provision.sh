# switch root user.
# sudo su

# locale
yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/glibc-common-2.17-317.el7.x86_64.rpm
yum -y reinstall glibc-common
localectl set-locale LANG=ja_JP.UTF-8
source /etc/locale.conf
localectl

# timezone
timedatectl set-timezone Asia/Tokyo
date

# disable selinux.
sed -i -e "s/^SELINUX=enforcing$/SELINUX=disabled/g" /etc/selinux/config
reboot
