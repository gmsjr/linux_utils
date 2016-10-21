#!/bin/bash
#AUTOR: Gilson Maia
#Equipe de aplicacao DET2

# Ingressando no dominio PS: e necessaria autenticacao do usuario adm_gilsonjunior para realizar a integracao

domainjoin-cli join --assumeDefaultDomain yes incra.gov.br adm_gilsonjunior

#Habilitando o acesso via ssh para os usuarios do AD

domainjoin-cli configure --enable ssh

#Configurando prefixo do dominio para a autenticacao dos usuarios

/opt/pbis/bin/config UserDomainPrefix incra-sede

#Configurando dominio existente como padrao

/opt/pbis/bin/config AssumeDefaultDomain true 

#Configurando shell padrao para os usuarios do AD
/opt/pbis/bin/config LoginShellTemplate /bin/bash 

#Configurando permissao do diretorio /home dos usuarios AD

/opt/likewise/bin/lwconfig HomeDirUmask "077"

#Configurando layout de criacao do diretorio /home dos usuarios do AD

/opt/likewise/bin/lwconfig HomeDirTemplate "%H/%D/%U"

#Configurando permissao acesso de sudo para os usuarios da equipe de aplicacao

echo "%adm_aplicacao ALL=(ALL) ALL" >> /etc/sudoers

#Desabilitando acesso de root via ssh

if ! grep -q 'b\#PermitRootLogin yes\b' /etc/ssh/sshd_config; then

echo "$(sed 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config)" > /etc/ssh/sshd_config

fi

if ! grep -q 'b\PermitRootLogin yes\b' /etc/ssh/sshd_config; then

echo "$(sed 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config)" > /etc/ssh/sshd_config

fi

if ! grep -q 'b\#PermitRootLogin no\b' /etc/ssh/sshd_config; then

echo "$(sed 's/#PermitRootLogin no/PermitRootLogin no/g' /etc/ssh/sshd_config)" > /etc/ssh/sshd_config

fi

#Restart do servico ssh

#/etc/init.d/ssh restart

#E necessario o reboot do servidor

reboot
