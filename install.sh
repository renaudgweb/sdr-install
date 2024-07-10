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

apt_install() {
	# Mise à jour APT
	sudo apt update && sudo apt upgrade -y
	printf "Les paquets APT sont à jour ✅️\n"

	# Liste des paquets APT à installer
	packages_apt="git \
		          autoconf \
		          libtool \
		          automake \
		          ccze \
		          bmon \
		          cmake \
		          build-essential \
		          libusb-1.0-0-dev \
		          rtl-sdr \
		          librtlsdr-dev \
		          zlib1g-dev \
		          libxml2-dev \
		          sox \
		          rtl-433 \
		          udev \
		          lsof \
		          gqrx-sdr \
		          htop"

	# Installation des paquets APT
	sudo apt install $packages_apt -y
	printf "Les paquets APT sont installés ✅️\n"
}

all_install() {
	# Appel de la Fn d'install APT
	apt_install;

	mkdir ~/Documents/Perso/APPS/sdr/

	# Installation de la libacars2
	cd ~/Documents/Perso/APPS/sdr/
	wget https://github.com/szpajder/libacars/archive/refs/tags/v2.2.0.tar.gz
	tar xfvz v2.2.0.tar.gz
	cd libacars-2.2.0/
	mkdir build
	cd build
	cmake ../
	make
	sudo make install
	sudo ldconfig
	rm ~/Documents/Perso/APPS/sdr/v2.2.0.tar.gz
	printf "La libacars2 est installée ✅️\n"

	# Installation d'ACARSDEC
	cd ~/Documents/Perso/APPS/sdr/
	wget https://github.com/TLeconte/acarsdec/archive/refs/tags/acarsdec-3.7.tar.gz
	tar xfvz acarsdec-3.7.tar.gz
	cd acarsdec-acarsdec-3.7/
	mkdir build
	cd build
	cmake .. -Drtl=ON
	make
	sudo make install
	rm ~/Documents/Perso/APPS/sdr/acarsdec-3.7.tar.gz
	printf "ACARSDec est installé ✅️\n"

	# Installation de Multimon-ng
	cd ~/Documents/Perso/APPS/sdr/
	wget https://github.com/EliasOenal/multimon-ng/archive/refs/tags/1.3.1.tar.gz
	tar xfvz 1.3.1.tar.gz
	cd multimon-ng-1.3.1/
	mkdir build
	cd build
	cmake ..
	make
	sudo make install
	rm ~/Documents/Perso/APPS/sdr/1.3.1.tar.gz
	printf "Multimon-ng est installé ✅️\n"

	# Installation de Kalibrate
	cd ~/Documents/Perso/APPS/sdr/
	wget https://github.com/steve-m/kalibrate-rtl/archive/refs/heads/master.zip
	unzip master.zip
	cd kalibrate-rtl-master
	./bootstrap && CXXFLAGS='-W -Wall -O3' ./configure && make
	rm ~/Documents/Perso/APPS/sdr/master.zip
	printf "Kalibrate est installé ✅️\n"

	# Mise à jour APT & Autoremove
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
	printf "Les mises à jour sont installés ✅️\n"
}

while true
do
    printf "Fais ton choix: [Y]es✔️, or [N]o❌ : "
    read -r REPLY
    case $REPLY in
        [Yy]* ) all_install; break;;
        [Nn]* ) printf "Bye 💨\n"; exit;;
        * ) printf "⛔️Entre une de ces lettre: Y or N\n";;
    esac
done
