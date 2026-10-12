# Proxying APT, Curl, DNF, Docker and Git requests through a proxy
Setting up a system-wide proxy on a service running a Socks5 tunnel running socks on port `10808`, IP of the port is considered to be `192.168.0.197`:

```bash
export http_proxy="http://192.168.0.197:10808"
export https_proxy="http://192.168.0.197:10808"
```

Testing to see if the IP is passing through proxy:
```bash
curl ipinfo.io
```

## APT
We can add the proxy for the APT package manager by adding to the `/etc/apt/apt.conf.d/99proxy` or use them inline with `-o`:

`/etc/apt/apt.conf.d/99proxy`
```conf
Acquire::http::Proxy "http://192.168.0.197:10808";
Acquire::https::Proxy "http://192.168.0.197:10808";
```

```bash
sudo apt update -o Acquire::http::Proxy="http://192.168.0.197:10808" -o Acquire::http:Proxy="http://192.168.0.197:10808"
```

## DNF
For RedHat based machines add the following config to the `/etc/dnf/dnf.conf` file:

```bash
proxy=http://192.168.0.197:10808
```
## Git

```bash
git config --global http.proxy "http://127.0.0.1:10808"
git config --global https.proxy "http://127.0.0.1:10808"
```

## Docker and Containerd
We need to place the following config in the `/etc/systemd/docker.service.d/http-proxy.conf` file:
```toml
[service]
Environment="HTTP_PROXY=http://192.168.0.197:10808"
Environment="HTTPS_PROXY=http://192.168.0.197:10808"
```
