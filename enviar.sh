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

# Divide em pedaços de 256Mb.
# Para unir: cat prefixo-* > arquivo.tar.bz2

ID_DIRETORIO_DRIVE="????"
TAMANHO_MAXIMO_SPLIT=268435456 #256M
TAMANHO_ARQUIVO=$(du -b "$1" | cut -f 1)
PREFIXO_SPLIT="$1-"

TAMANHO_ARQUIVO_ATUAL=0
QUANTIDADE_JA_ENVIADA=0

if [ $TAMANHO_ARQUIVO -ge $TAMANHO_MAXIMO_SPLIT ]; then
  echo "Dividindo arquivo $1 em pedaços de 256M..."
  split -d --bytes=$TAMANHO_MAXIMO_SPLIT $1 "$PREFIXO_SPLIT"

  # Content-Length: 524288
  # Content-Range: bytes 0-524287/2000000

  # Multipart de um arquivo de 1600 bytes, em pedaços de 500
  # bytes 0-499/1600
  # bytes 500-599/1600
  # bytes 1000-1499/1600
  # bytes 1500-1599/1600

  # Envia um a um os arquivos.
  for f in `ls $PREFIXO_SPLIT*`
  do
   echo "Enviando arquivo $f..."
   TAMANHO_ARQUIVO_ATUAL=$(du -b "$f" | cut -f 1)

   # FIXME Trocar INICIO/FIM/TOTAL ...
   ./upload.sh upload $f "$f" "$ID_DIRETORIO_DRIVE" "`file --mime-type -b $f`" $INICIO $FIM $TOTAL 1> $f.log 2>&1

   QUANTIDADE_JA_ENVIADA=$[$QUANTIDADE_JA_ENVIADA+$TAMANHO_ARQUIVO_ATUAL]
   # Outro exemplo de calculo: echo $[$[30-10]+5] == 25
   rm $f

  done

else
  PREFIXO_SPLIT="$1"
  echo "Enviando arquivo $f..."
  ./upload.sh upload $f "$f" "$ID_DIRETORIO_DRIVE" "`file --mime-type -b $f`" 1> $f.log 2>&1
  rm $f
fi


echo "Concluído."
