# Setting system locale
## APT
We need a system locale for installation of some services such as zabbix, we can use `locales` package and use the `locale-gen` to create the locale and use it:
```bash
sudo apt update
sudo apt install locales -y
sudo locale-gen en_US.UTF-8
```
We can set the system default locale by running the following command:
```bash
sudo update-locale LANG=en_US.UTF-8
```

## DNF
We can set the locale by running the following commands:
```bash
sudo dnf install glibc-langpack-en
sudo localectl set-locale LANG=en_US.UTF-8
```
## Verification
```bash
locale -a | grep -i en_us
```
