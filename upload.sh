#!/bin/bash
#Copyright 2014 Rodrigo de Avila
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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

