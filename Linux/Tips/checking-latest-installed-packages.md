# Checking Latest Installed Packages
To check command line installs:
```bash
grep "Commandline : apt" /var/log/apt/history.log
```

For the actual package installation in all rotated and compressed logs:
```bash
zgrep -A2 -B1 "Install:" /var/log/apt/history.log*
```

For a more precise output:
```bash
awk '
/^Start-Date:/ { date=$0 }
/^Commandline:/ { command=$0 }
/^Install:/ {
    print date "\n" command "\n" $0 "\n"
}
```

For latest installs from `dpkg`:
```bash
grep " install " /var/log/dpkg.log | tail -1 
```