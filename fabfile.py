 #!/usr/bin/python
# -*- coding: utf-8 -*-

from fabric.api import *

APT_PACKAGES = "apache2 fail2ban mysql-server lamp-server^ php php-mysql php-curl php-apcu php-gd postfix libapache2-mod-php expect"

env.user = "root"


def clean_up():
    """
    Clean up remote machine before taking snapshot.
    """
    # Do cleanup tasks on build system
    run("rm -rf /tmp/* /var/tmp/*")
    run("history -c")
    run("cat /dev/null > /root/.bash_history")
    run("unset HISTFILE")
    run("apt-get -y autoremove")
    run("apt-get -y autoclean")
    run("find /var/log -mtime -1 -type f -exec truncate -s 0 {} \;")
    run("rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/*-????????")
    run("rm -rf /var/lib/cloud/instances/*")
    puts("Removing keys...")
    run("rm -f /root/.ssh/authorized_keys /etc/ssh/*key*")
    run("dd if=/dev/zero of=/zerofile; sync; rm /zerofile; sync")
    run("cat /dev/null > /var/log/lastlog; cat /dev/null > /var/log/wtmp")

def shut_down():
    # Shut down remote server on completion
    run("shutdown -h now & exit 0")

def install_files():
    """
    Install files onto remote machine.
    """
    # Clone Directus Suite
    run("git clone https://github.com/directus/directus.git /var/www/directus")
    # Enable mod_rewrite
    run("a2enmod rewrite")
    # Set File Permissions
    run("chown -R www-data: /var/log/apache2")
    run("chown -R www-data: /etc/apache2")
    run("chown -R www-data: /var/www")
    # Upload files to build system's filesystem
    put("files/etc/apache2/sites-available/000-default.conf","/etc/apache2/sites-available/000-default.conf")
    put("files/etc/update-motd.d/99-one-click","/etc/update-motd.d/99-one-click")
    run("chmod +x /etc/update-motd.d/99-one-click")
    put("files/var/lib/cloud/scripts/per-instance/001_onboot.sh","/var/lib/cloud/scripts/per-instance/001_onboot.sh")
    run("chmod +x /var/lib/cloud/scripts/per-instance/001_onboot.sh")

@task
def build_base():
    """
    Install and configure the LAMP stack.
    """
    #Postfix won't install without a prompt without setting some things
    run("debconf-set-selections <<< \"postfix postfix/main_mailer_type string 'No Configuration'\"")
    run("debconf-set-selections <<< \"postfix postfix/mailname string localhost.local\"")
    
    # Install apt packages listed in APT_PACKAGES
    run("apt-get -qqy update")
    run("apt-get -qqy upgrade")
    run("apt-get -qqy install {}".format(APT_PACKAGES))
    
    # Add 3rd paty repo and install certbot
    run("apt-get -qqy install software-properties-common")
    run("add-apt-repository ppa:certbot/certbot -y")
    run("apt-get -qqy update")
    run("apt-get -qqy install python-certbot-apache")
    install_files()


@task
def build_image():
    """
    Generate the LAMP One-Click Application image.
    """
    build_base()
    clean_up()
    shut_down()
