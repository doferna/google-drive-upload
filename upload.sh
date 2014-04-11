#!/bin/bash

# Faz o upload de um arquivo para o Google Drive
#
# Uso: upload.sh upload <arquivo> [nome do arquivo no drive] [id do diretorio no drive] [tipo mime do arquivo]

set -e

ACCESS_TOKEN="`./google-oauth2.sh refresh`"
BOUNDARY=`cat /dev/urandom | head -c 16 | xxd -ps`
MIME_TYPE=${5:-"application/octet-stream"}

( echo "--$BOUNDARY
Content-Type: application/json; charset=UTF-8

{ \"title\": \"$3\", \"parents\": [ { \"id\": \"$4\" } ] }

--$BOUNDARY
Content-Type: $MIME_TYPE
" \
&& cat $2 && echo "
--$BOUNDARY--" ) \
	| curl "https://www.googleapis.com/upload/drive/v2/files/?uploadType=multipart" \
	--header "Authorization: Bearer $ACCESS_TOKEN" \
	--header "Content-Type: multipart/related; boundary=\"$BOUNDARY\"" \
	--data-binary "@-"

