# Securing Normal User Accounts
There are multiple things we need to set to have a secure user environment on our servers.

## Locking Down User's Homw Directories
In RedHat family OS of the linux we can set a `umask` value for when we add a user to system which is originally has been set as `077` meaning when subtracted from the `777` it will create files with the `700` that give access to the home directory only to the owner of the account. This value can be changed in the `/etc/login.defs` file.  We can use either of the following two lines to achieve this:
```bash
CREATE_HOME yes
UMASK 077
# Or 
HOME_MODE 0700
```

This can be done in the same file on Debian family OS distros after 2024. If we use the Ubuntu's `adduser` we need to tune the following line in the `/etc/adduser.conf` file:
```bash
DIR_MODE=750
```

The `adduser` utility can encrypt a users home directory as you create the account and to make it work we to install the following package and use the `--encrypt-home` flag when defining the user. For example:
```bash
sudo apt install ecryptfs-utils
sudo adduser --encrypt-home jack
```

At the first login user has to run the following command to get a decryption passphrase:
```bash
ecryptfs-unwrap-passphrase ~/.ecryptfs/wrapped-passphares
```

## Enforcing Strong Password Criteria
We can use the `pwquality` module for a Pluggable Authentication Module (PAM). The configurations for PAM in linux sits in the `/etc/pam.d/` and we can use other types of authenticators such as google authenticator package and we would configure it in the same path. On debian and Ubuntu we can install `pwquality` with the following command:
```bash
sudo apt install libpam-pwquality
```

For the `pwquality` we can update the `/etc/security/pwquality.conf` and in this file we can set the minimum amount of characters, minimum amount of lowercase characters (can be set to 0 as well). The length is called credits in this module and we say how much each type of value can be counted as this credit. If we set something like `dcredit = 3`, it means each digit will count as three credit. We can also set the value to a negative number to indicate we need that amount of that character type in our password. We can say how many character type classe to have with the `minclass` directive.

```ini
minlen = 8 # minimum length
lcredit = 0 # Lowercase characters will not count as the credit
dcredit = 2
minclass = 3
maxclassrepeat = 5
```

## Account and Password Expiration
We can set unused accounts inactive. Password expiration date and account expiration are two different things and can be set seperately. If the account expires the user can set but if an account is expired the admin should unlock it. We can check our accounts expiry configurations using the following command:
```bash
chage -l <username>
```

The default values can be checked in `/etc/login.defs` configuration file and the values can be seen below:
```conf
PASS_MAX_DAYS 99999
PASS_MIN_DAYS 0
PASS_WARN_AGE 7
```

Now that we have set the password expiry data we can set the account expiry data at `/etc/default/useradd` file and set the `EXPIRE` field. The `INACTIVE=-1` line in this configuration means that the user account will not be automatically locked out after the user's password expires and if set to a positive number the user has to update their expired password before the account is expired. We can set it like this or run the following command with a date like `2026-10-31`:
```bash
sudo useradd -D -e 2026-10-31
```

Setting password expiry is more reasonable in the `/etc/login.defs` since the default value being set in the `/etc/default/useradd` which uses a number of days instead of the fixed date. We can use the `useradd -e` command and flag to set the expiry date per user account at the time of creation and the `-f` to set the inactive value. For example we can set the values for a newly created account:
```bash
useradd -m -s /bin/bash -f 5 -d /home/charlie -e 2026-04-31 charlie
```

We can use the `usermod -e` command to change the expiry date of the account:
```bash
usermod -e 2026-12-31 charlie
```

We can use the `chage` command to change the password attributes and account inactivation date. We can see the list of flags we can use with this command:
|Option|Explanation|
|:---:|:---:|
|`-d`|number of days the user has to change their password at. Set it to 0 to force a password change in the next login|
|`-E`|Equivalent of `usermod`'s `-e` to set the account expiration date|
|`-I`|equivalent of `usermod -f` to set the inactive days|
|`-m`|This sets the minimum number of days between password changes|
|`-M`|This sets the maximum number of days before a password expires must be bigger than `-m`|
|`-W`|To set the number of warning days|

```bash
sudo chage -E 2026-02-28 -I 4 -m 3 -M 90 -W 4 charlie
```

In order to set the user to change their password at the next login we can use either of the two options:
```bash
sudo chage -d 0 charlie
sudo passwd -e charlie
```

## Preventing brute-force password attacks
