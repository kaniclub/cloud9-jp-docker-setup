#!/bin/sh

cat .env.orig > .env
cat <<EOS >> .env
USER=$(id -u -n)
UID=$(id -u)
GID=$(id -g)
EOS

