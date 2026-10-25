# Securing Administrative User Accounts
Instead of logging in as `root` user it is better to use `sudo` since we can assign users certain full administrative privilages while assigning other only the privileges they should have. We can implement `sudo` and disable the `root` user login. What a user does with `sudo` can be tracked and logged. 

## Setting up sudo privilages for full administrative users
Let's first see how to setup a full access admin privilage even the ability to `su` to `root` user. 
1. Adding the user to the predefined admin group
Here we are going to add the admin account to the admin group, which is `wheel` in some distors and `root` in some other.
```bash
groups # see the available groups
usermod -a -G root admin
```
We must make sure the group has root access as well. We can use the following commnad to check the sudo policies:
```bash
sudo visudo
```
The following line should be uncommented in the file:
```text
%root ALL=(ALL) ALL
```
If we use this policy users can run every `sudo` command without entering their password, We can alter the policy in a way that prompts the users for their password when they are running the conmmands with `sudo`.
```text
%root ALL=(ALL) NOPASSWD:ALL
```
We can disable the `root` account by running the following command:
```bash
sudo passwwd -l root
```

2. Creating an entry in the sudo policy file
We can create an alias like admins and then give it sudo access or we can add a `visudo` entry for just single user. We can see either in the following example:
```sudo
User_Alias ADMINS = arian, frank
ADMINS ALL=(ALL) NOPASSWD:ALL
```
```sudo
frank ALL=(ALL) NOPASSWD:ALL
```

## Setting up sudo for users with delegated privileges
Doing this will allow us to delegate access to root commands based on the role of the user. We can create user grouping aliases with the `User_Alias` and command grouping alias with the `Cmnd_Alias`. We can create an alias of commands and give the access of running it to a user group alias.  We can see and example of it like this:
```text
# User aliases containing usernames
User_Alias SOFTWAREADMINS = vicky, cleopatra
# Command alias containing the realpath of the commands
Cmnd_Alias SOFTWARE = /bin/rpm, /usr/bin/up2date, /usr/bin/yum

SOFTWAREADMINS ALL=(ALL) SOFTWARE
```

We can also go further and list the commands with the allowed subcommands in the alias as well. Here we can see the `SERVICES` command alias that contains the sub command as well:
```text
Cmnd_Alias SERVICES = /sbin/service *, /sbin/chkconfig, /usr/bin/systemctl start *, /usr/bin/systemctl stop *, /usr/bin/systemctl reload *, /usr/bin/systemctl restart *, /usr/bin/systemctl status *, /usr/bin/systemctl enable *, /usr/bin/systemctl disable *
```
Only the commands that have the `*` can run any option or subcommand they want and if it is not used the user can run the exact command alone. We can also allow the options and subcommand by for one service or file like `/bin/systemctl/ * sshd`.

We are not limited to use the group aliases and we can define users and groups in the `visudo` config file.

```text
katelyn ALL=(ALL) STORAGE
gunther ALL=(ALL) /sbin/fdisk -l
%backup_admins ALL=(ALL) BACKUP
```

We can create aliases for machine hostnames and allow access to run sudo if the user was part of the hosted machines and this is in order to allow us to make one sudoers file for the whole enterprise suite and deploy it over the network. Here we create an alias for the host, one for the users and one for commands and assign them the machines and the commands:
```text
Host_Alias WEBSERVERS = webserver1, webserver2
User_Alias WEBADMINS = junior, kayla
Cmnd_Alias WEBCOMMANDS = /usr/bin/systemctl status httpd, /usr/bin/systemctl start httpd, /usr/bin/systemctl restart httpd

WEBADMINS WEBSERVERS=(ALL) WEBCOMMANDS
```

Now, when a user types a command into a server on the network, sudo will first look at the hostname of that server. If the user is authorized to perform that command on that server, then sudo allows it. Otherwise, sudo denies it

## Advanced tips
The sudo timer is 5 minutes meaning when a user runs a sudo command and enter their password they don't have to re-enter their password. If we want to reset the sudo timer we can run the following command:
```bash
sudo -k
```

We can view the `sudo` privileges by running the following command:
```bash
sudo -l
```

The default value of the `-k` option can be changed globally or per user. We can modify it by using the `visudo` command and modifying the values like the following. By setting the value to `0` the user is prompted a password every time they use `sudo` with a command:
```bash
Defaults timestamp_timeout = 0 # Global
Defaults:lionel timestamp_timeout = 0 # Per user
```

We shouldn't give commands like `/bin/sh`, `/bin/bash` or `/bin/vim` to the sudo access since the vim editor has the `:shell` that can give user root access. The following can be an example of this mistake:
```bash
frank ALL=(ALL) /bin/vim /etc/ssh/sshd_config
```

Instead when we want to give a user an access to edit a root owned file we can use the `sudoedit` command and change the sudoer action like this:
```bash
frank ALL=(ALL) sudoedit /etc/ssh/ssh_config
```

The following programs have shell escape features that allow them to escape to the root shell by using the `:shell` command:
- emacs
- less
- view
- more

In order to stop this behavior we need to set the `NOEXEC` option on the command like this:
```bash
vicky ALL=(ALL) NOEXEC: /usr/bin/less
```

## Letting users run as other users
The `(ALL)` tells the user can run the commands we issue its access to it as any user he wants. For example, the `sylvester ALL=(ALL) /usr/bin/systemctl status sshd` allows the user to run it's sudo command like this:
```bash
sudo -u database_user systemctl status sshd
```

We can set the `(ALL)` to the user that we want the sudoer to run the command as but the user needs to specify the `-u <user>` when running the sudo command.

## Preventing abuse via user's shell script
If a user create a shell script like the following and have an access like `frank ALL=(ALL) /home/frank/script.sh`:
```bash
echo "this is my script"
sudo -i
```

He can have a privilege escallation to the root shell. To remedy this we need to move the script to the `/usr/bin/script.sh` and change its owner to root so the user can't modify it.

We can enable more verbose logging in JSON format by putting the following config the `visudo` command.
```bash
Defaults log_format=json
```
