#!/bin/bash -

. /opt/chambana/lib/common.sh

CHECK_VAR AMAVIS_MAILNAME

MSG "Setting mailname..."
echo "${AMAVIS_MAILNAME}" > /etc/mailname

if [[ ! -d /var/run/clamav ]]; then
	MSG "Create clamav runtime directory..."
	mkdir /var/run/clamav
	chown -R clamav:clamav /var/run/clamav
fi


MSG "Configuring Razor & Pyzor..."
su - amavis -c 'razor-admin -create'
su - amavis -c 'razor-admin -register'
su - amavis -c 'pyzor discover'

MSG "Starting Amavis..."
supervisord -c /etc/supervisor/supervisord.conf 
