# Auto updates
On Ubuntu auto updates are turned on by default and we can verify it by checking the status of the unattended upgrade by running the following command:
```bash
systemctl status unattended-upgrades
```

If they are active we can also check them from the `/etc/apt/apt.conf.d/20auto-upgrades` file. If the `APT::Periodic::Unattended-Upgrade` has its value sets as "1" it is active and we can turn it off by setting the value to "0".

Most of security upgrades even if auto update requires the system to be rebooted to take affect which Ubuntu will not do automatically. We can set the auto update by modifying the `/etc/apt/apt.conf.d/50unattended-upgrades` file in which the following config should be uncommented and we can define a time as well:
`/etc/apt/apt.conf.d/50unattended-upgrades`
```apt
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
```

If we want to check if there are any security-related update available we can use the following command. We can also use the second command to install only the security-related updates.
```bash
sudo unattended-upgrade --dry-run -d
sudo unattended-upgrade -d
```