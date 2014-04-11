#!/bin/bash

# Um autenticador simples que usa cURL e OAuth2
# Depende do módulo json do python para formatar a saída.
#
# Uso:
#	./google-oauth2.sh create - autentica o usuário.
#	./google-oauth2.sh refresh <refresh_token> - obtém um novo token
#
# Defina o CLIENT_ID e o CLIENT_SECRET com as info. do Drive API.
# Defina o REFRESH_TOKEN com o token informado quando roda
#	./google-oauth2.sh create
# pela primeira vez.

CLIENT_ID="??????"
CLIENT_SECRET="??????"

REFRESH_TOKEN="??????"

SCOPE=${SCOPE:-"https://docs.google.com/feeds"}

set -e

if [ "$1" == "create" ]; then
	RESPONSE=`curl --silent "https://accounts.google.com/o/oauth2/device/code" --data "client_id=$CLIENT_ID&scope=$SCOPE"`
	DEVICE_CODE=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'device_code"\s*:\s*"\K(.*)"' | sed 's/"//'`
	USER_CODE=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'user_code"\s*:\s*"\K(.*)"' | sed 's/"//'`
	URL=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'verification_url"\s*:\s*"\K(.*)"' | sed 's/"//'`

	echo -n "Acesse $URL e digite o codigo $USER_CODE para permitir o acesso desta aplicacao. Tecle enter quando estiver pronto..."
	read

	RESPONSE=`curl --silent "https://accounts.google.com/o/oauth2/token" --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&code=$DEVICE_CODE&grant_type=http://oauth.net/grant_type/device/1.0"`

	ACCESS_TOKEN=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'access_token"\s*:\s*"\K(.*)"' | sed 's/"//'`
	REFRESH_TOKEN=`echo "$RESPONSE" | python -mjson.tool | grep -oP 'refresh_token"\s*:\s*"\K(.*)"' | sed 's/"//'`

	echo "Token de acesso: $ACCESS_TOKEN"
	echo "Token de Refresh: $REFRESH_TOKEN"
elif [ "$1" == "refresh" ]; then
#	REFRESH_TOKEN=$2
	RESPONSE=`curl --silent "https://accounts.google.com/o/oauth2/token" --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&refresh_token=$REFRESH_TOKEN&grant_type=refresh_token"`

	ACCESS_TOKEN=`echo $RESPONSE | python -mjson.tool | grep -oP 'access_token"\s*:\s*"\K(.*)"' | sed 's/"//'`
#	ACCESS_TOKEN=`echo $RESPONSE`
	
	echo "$ACCESS_TOKEN"
fi
