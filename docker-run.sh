#!/bin/bash
# this is the script run inside the docker container....

function noop {
	# run while loop and do nothing
	while [ : ]
	do
		sleep 60
	done
}

if [ $1 == "add-user" ]; then
	VPN_USER="$2"

	if [ -z "$VPN_USER" ]; then
	  echo "Usage: $0 $1 username" >&2
	  echo "Example: $0 $1 talmai" >&2
	  exit 1
	fi

	case "$VPN_USER" in
	  *[\\\"\']*)
	    echo "VPN credentials must not contain any of these characters: \\ \" '" >&2
	    exit 1
	    ;;
	esac

	SHARED_SECRET=$(cut -d'"' -f2 /etc/ipsec.secrets)
	echo "Shared secret: $SHARED_SECRET"

    VPN_PASSWORD="$(LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 20)"
	VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
	echo "Password for user is: $VPN_PASSWORD"

	echo '"'$VPN_USER'"' l2tpd '"'$VPN_PASSWORD'"' '*' >> /etc/ppp/chap-secrets
	echo $VPN_USER:$VPN_PASSWORD_ENC:xauth-psk >> /etc/ipsec.d/passwd
	exit 1
elif [ $1 == "list-users" ]; then
	grep -v '^#' /etc/ppp/chap-secrets | cut -d' ' -f1 | cut -d'"' -f2
	exit 1
elif [ $1 == "remove-user" ]; then
	VPN_USER="$2"

	if [ -z "$VPN_USER" ]; then
	  echo "Usage: $0 $1 username" >&2
	  echo "Example: $0 $1 talmai" >&2
	  exit 1
	fi

	cp /etc/ppp/chap-secrets /etc/ppp/chap-secrets.bak
	sed "/\"$VPN_USER\" /d" /etc/ppp/chap-secrets.bak > /etc/ppp/chap-secrets
	cp /etc/ipsec.d/passwd /etc/ipsec.d/passwd.bak
	sed "/$VPN_USER:/d" /etc/ipsec.d/passwd.bak > /etc/ipsec.d/passwd
	exit 1
elif [ $EXEC == "run" ]; then
	/ipsec/start-ipsec.sh &
else
	echo docker-run.sh run with no parameter - "${@}"
	exit 1
fi

noop