# IPsec VPN Server on Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/talmai/docker-ipsec-vpn-server.svg)](https://hub.docker.com/r/talmai/docker-ipsec-vpn-server/)
[![Docker Stars](https://img.shields.io/docker/stars/talmai/docker-ipsec-vpn-server.svg)](https://hub.docker.com/r/talmai/docker-ipsec-vpn-server/)

Docker image to run a multi-user, IPsec VPN server with support for both `IPsec/L2TP` and `IPsec/XAuth ("Cisco IPsec")`. Based on [Lin Song's IPsec VPN Server on Docker](https://github.com/hwdsl2/docker-ipsec-vpn-server) and forked from [mobilejazz](https://github.com/mobilejazz/docker-ipsec-vpn-server).

## Install Docker

Follow [these instructions](https://docs.docker.com/engine/installation/) to get Docker running on your server.


### Available on Docker Hub (prebuilt) or built from source

```
git clone https://github.com/talmai/docker-ipsec-vpn-server.git
docker pull talmai/docker-ipsec-vpn-server
cd docker-ipsec-vpn-server
./helper.sh
```

Or build from source

```
git clone https://github.com/talmai/docker-ipsec-vpn-server.git
cd docker-ipsec-vpn-server
docker build -t talmai/docker-ipsec-vpn-server .
./helper.sh
```

## Run the helper script

```
./helper.sh

    -b, --begin			  start ipsec server
    -s, --status          get status
    -a, --add <user>      creates new user
    -l, --list            lists all users
    -r, --remove <user>   removes user

```

### Adding a new user

Create a new VPN user with the add command. This will generate an individual password for this user (user specific, usually called "password") and also display the shared key of the server (same for all users, usually called "PSK" or "Pre-Shared Key").

The user will be available immediately, there is no need to restart the server.

**IMPORTANT**: Due to a limitation in the IPSec protocol design, several devices can not connect to the same server behind the same NAT router. We recommend creating a separate account **for each device** a user owns. This will also make revocation of credentials easier if a user lost a device.

### Check server status

To check the status of your IPsec VPN server, you can use the status command.

## Next steps

Get your computer or device to use the VPN. Please refer to:

[Configure IPsec/L2TP VPN Clients](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients.md)   
[Configure IPsec/XAuth ("Cisco IPsec") VPN Clients](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-xauth.md)

If you get an error when trying to connect, see [Troubleshooting](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients.md#troubleshooting).

## Technical details

There are two services running: `Libreswan (pluto)` for the IPsec VPN, and `xl2tpd` for L2TP support.

Clients are configured to use [Google Public DNS](https://developers.google.com/speed/public-dns/) when the VPN connection is active.

The default IPsec configuration supports:

* IKEv1 with PSK and XAuth ("Cisco IPsec")
* IPsec/L2TP with PSK

The ports that are exposed for this container to work are:

* 4500/udp and 500/udp for IPsec

## Extending the configuration

The default configuration will work out of the box in most cases. However, you might want to tweak some little settings, like the routing table, or maybe something specific to your environment. If you you mount a `/pre-up.sh` script, it will be executed before starting the VPN.

## Backing up your VPN configuration

The `etc` directory is created with the helper script. You can back up this directory.

## See also

* [IPsec VPN Server on Ubuntu, Debian and CentOS](https://github.com/hwdsl2/setup-ipsec-vpn)
* [IKEv2 VPN Server on Docker](https://github.com/gaomd/docker-ikev2-vpn-server)