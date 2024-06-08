#!/bin/bash

# Criado por: Defallt
# Versão:     1.0
# Data:       03/06/2024
# Revisão:    03/06/2024

# https://github.com/Def4llt?tab=repositories

#-------------------

banner="""
   ___    ___ __  __ __  __ __   __
  /   \  / _// | / // / / // |  / /
 /     |/ _// /|/ // /_/ //  |_/ /
/_____//__//_/ |_//_____//_/\_/_/

"""

print_banner() {
    printf "$banner"
}

print_banner

#-------------------

header="\n\e[1;97m---------- [ \e[1;96m %s \e[1;97m ] ----------\e[0m\n\n"
marker="\n\e[1;97m[ \e[1;92m+ \e[1;97m] %s \e[0m\n"
topics="\033[32m"
response="\033[37m %s \033[0m"
reset="\033[0m"

host(){
    printf "${header}" "INFORMAÇÕES DA MÁQUINA"
    name=$(hostname)
    kernel=$(uname -a | cut -d " " -f 3)
    so=$(cat /etc/os-release | head -n 1 | cut -d "=" -f 2 | sed 's/"//g')
}

user(){
   printf "${header}" "USUÁRIOS"
   whoami=$(whoami)
   id=$(id)
   usuario=$(w)
   usuarios=$(cat /etc/passwd)
}

crontab(){
   printf "${header}" "ATIVIDADES AGENDADAS"
   crontab=$(cat /etc/crontab)
}

exports(){
    printf "${header}" "DIRETÓRIOS COMPARTILHADOS"
    exports=$(cat /etc/exports 2>/dev/null)
    if [ -z $exports ];
    then
        printf "Não há diretórios compartilhados"
    else
        printf "${topics}Diretórios compartilhados:${reset}\n%s" "$exports"
    fi
}

gravable(){
printf "${header}" "DIRETÓRIOS GRAVAVEIS"
    gravable=$(find / -writable -type d 2>/dev/null | grep "/home/kali/Desktop/THM/Scripts")
    # Remover o grep ou alterá-lo conforme a necessidade
    if [ -z $gravable ];
    then
        printf "Não há diretórios graváveis"
    else
        printf "${topics}Diretórios graváveis:${reset}\n%s\n" "$gravable"
    fi
}

suid(){
printf "${header}" "SUID ATIVOS"
    suid=$(find / -perm -u=s -type f 2>/dev/null)
    if [[ -z $suid ]];
    # aspas duplas ou [[]] para que a variável não quebre na leitura e o script não retorne
    # erro de que há muitos argumentos.
    then
        printf "Não há SUID ativos"
    else
        printf "${topics}SUID ativos:${reset}\n%s\n" "$suid"
    fi
}

# Chama a função e exibe informações da máquina
host
printf "${topics}Máquina:${reset} $name
${topics}Kernel:${reset} $kernel
${topics}Sistema Operacional:${reset} $so
"

user
printf "${topics}Sessão:${reset}\n$whoami\n$id\n
${topics}Usuário Atual:${reset} $usuario\n
${topics}Usuários:${reset}\n$usuarios\n
"

crontab
printf "${topics}Atividades agendadas:${reset}\n%s" "$crontab"

exports
printf "\n"
gravable

suid

# Para as funções crontab e exportfs as variáveis de cores não seguiram o padrão das funções host e user
# por se tratarem de saídas menores já que somente em uma linha é possível passar a saída.
