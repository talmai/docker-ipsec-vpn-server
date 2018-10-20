#!/bin/sh

usage="$(basename "$0") [-h] [-a name] [-l] [-r name] -- helper function to interact with docker-ipsec-vpn-server

where:
    -h, --help                  show this help text
    -b, --begin			start ipsec server
    -s, --status                get status
    -a, --add <user>            creates new user
    -l, --list                  lists all users
    -r, --remove <user>         removes user"

while :
do
    case "$1" in
      -h | --help)
          echo "$usage"
          exit 0
          ;;
      -b | --begin)
          mkdir -p etc/ipsec.d etc/ppp
          touch etc/ipsec.d/passwd
          touch etc/ppp/chap-secrets
          touch etc/ipsec.secrets
          # EXTRA_ARGS=
          # if [ -f etc/pre-up.sh ]; then
          #     EXTRA_ARGS="-v $PWD/etc/pre-up.sh:/pre-up.sh"
          # fi
          export EXTRA_ARGS
          docker-compose up -d
          exit 0
          ;;
      -s | --status)
          docker exec -it ipsec ipsec status -d
          exit 0
          ;;
      -a | --add)
          if [ $# -ne 0 ]; then
            name="$2"   # we do not check validity of $2
          fi
          docker exec -it ipsec /ipsec/docker-run.sh add-user "$name"
          exit 0
          ;;
      -l | --list)
          docker exec -it ipsec /ipsec/docker-run.sh list-users
          exit 0
           ;;
      -r | --remove)
          if [ $# -ne 0 ]; then
            name="$2"   # we do not check validity of $2
          fi
          docker exec -it ipsec /ipsec/docker-run.sh remove-user "$name"
          exit 0
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          exit 1 
          ;;
      *)  # No more options
          echo "$usage"
          break
          ;;
    esac
done
