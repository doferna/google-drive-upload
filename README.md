## Script para upload de arquivos para o Google Drive, via terminal/ssh no Ubuntu Linux


### Como configurar:

0. Obtenha os arquivos deste repositório usando `git clone https://github.com/rdeavila/google-drive-upload.git`.
0. Dê permissão de execução para os arquivos: `chmod a+x *.sh`.
1. Configure um novo projeto no [Google Developers Console]
2. Neste projeto, habilite o Drive API.
3. Ao acessar o Drive API, abra a opção "Credenciais" dentro de "APIs e autenticação".
4. Crie um novo ID do cliente, do tipo "Aplicativo instalado".
5. Copie o "ID do cliente" na variável `CLIENT_ID` dentro do arquivo `google-oauth2.sh`.
6. Copie a "Chave secreta do cliente" na variável `CLIENT_SECRET` dentro do arquivo `google-oauth2.sh`.
7. Execute o comando `./google-oauth2.sh create` e siga as instruções no terminal para obter um token de refresh.
8. Copie o Token de Refresh para a variável `REFRESH_TOKEN` do arquivo `google-oauth2.sh`.
9. Agora descubra o ID do diretório do Drive para onde vai os seus arquivos. Ele está na URL do diretório. Ex.: na URL `https://drive.google.com/a/example.com/#folders/0B43Qn3ksX-mMbUNyZXdSazZnU2M` o ID do diretório é o que vem depois de #folders; neste caso `0B43Qn3ksX-mMbUNyZXdSazZnU2M`. Copie esta ID na variável `ID_DIRETORIO_DRIVE` do arquivo `enviar.sh`.


### Como usar:

1. Copie o arquivo a ser transferido para dentro do diretório onde estão os scripts. Por enquanto os scripts não funcionam com arquivos que estão em outros diretórios.
2. Execute `./enviar.sh arquivo.txt`
3. Aguarde.
4. Confira na sua conta do Google Drive se os arquivos estão lá.

[Google Developers Console]: https://console.developers.google.com/project 
