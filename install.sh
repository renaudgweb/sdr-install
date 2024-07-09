#!/usr/bin/env bash

#
#
# Script d'installation de paquets & configuration SDR
#
# Version : 0.1
#
#
# Quitte le programme si une commande échoue
set -o errexit
# Quitte le programme si variable non definie
set -o nounset
# Quitte le programme si une commande échoue dans un pipe
set -o pipefail

clear
cat << "EOF"
Renaud G.
Version : 0.1

				         _nnnn_                      
				        dGGGGMMb     ,"""""""""""""".
				       @p~qp~~qMb    | Linux SDR 📡 |
				       M|@||@) M|   _;..............'
				       @,----.JM| -'
				      JS^\__/  qKL
				     dZP        qKRb
				    dZP      📦  qKKb
				   fZP       📥   SMMb
				   HZM            MMMM
				   FqM            MMMM
				 __| ".        |\dS"qML
				 |    `.       | `' \Zq
				_)      \.___.,|     .'
				\____   )MMMMMM|   .'
				     `-'       `--'


EOF
