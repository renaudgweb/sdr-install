#!/usr/bin/env bash

#
#
# Script d'installation de paquets & configuration SDR
#
# Version : 0.2
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
Version : 0.2

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
	echo "Les paquets APT sont à jour ✅️\n"

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
	echo "Les paquets APT sont installés ✅️\n"
}

libacars_install() {
	# Définition des variables
	INSTALL_DIR="~/Documents/Perso/APPS/sdr/libacars"
	TMP_DIR="/tmp/libacars_install"
	ARCHIVE_NAME="libacars.tar.gz"

	# Création du répertoire temporaire
	mkdir -p "$TMP_DIR"
	cd "$TMP_DIR"

	# Récupération du lien de téléchargement de la dernière version
	TARBALL_URL=$(curl -s https://api.github.com/repos/szpajder/libacars/releases/latest | grep '"tarball_url"' | cut -d '"' -f 4)

	# Vérification si l'URL est bien récupérée
	if [[ -z "$TARBALL_URL" ]]; then
	    echo "Erreur : Impossible de récupérer le lien de téléchargement."
	    exit 1
	fi

	# Téléchargement de l'archive
	echo "Téléchargement de libacars..."
	wget -q "$TARBALL_URL" -O "$ARCHIVE_NAME"

	# Suppression de l'ancienne installation si elle existe
	if [[ -d "$INSTALL_DIR" ]]; then
	    echo "Suppression de l'ancienne installation..."
	    rm -rf "$INSTALL_DIR"
	fi

	# Extraction de l'archive
	echo "Extraction de l'archive..."
	tar -xzf "$ARCHIVE_NAME"

	# Trouver le dossier extrait (qui a un nom dynamique)
	EXTRACTED_DIR=$(ls -d libacars-*/ 2>/dev/null | head -n 1)

	# Vérification si l'extraction s'est bien déroulée
	if [[ -z "$EXTRACTED_DIR" ]]; then
	    echo "Erreur : Impossible de trouver le dossier extrait."
	    exit 1
	fi

	# Déplacement vers le répertoire d'installation
	mv "$EXTRACTED_DIR" "$INSTALL_DIR"

	cd "$INSTALL_DIR"

	mkdir build
	cd build
	cmake ../
	make
	sudo make install
	sudo ldconfig

	# Nettoyage des fichiers temporaires
	rm -rf "$TMP_DIR"

	echo "La libacars2 est installée ✅️\n"
}

acarsdec_install() {
	# Définition des variables
	INSTALL_DIR="~/Documents/Perso/APPS/sdr/acarsdec"
	TMP_DIR="/tmp/acarsdec_install"
	ARCHIVE_NAME="acarsdec.tar.gz"

	# Création du répertoire temporaire
	mkdir -p "$TMP_DIR"
	cd "$TMP_DIR"

	# Récupération du lien de téléchargement de la dernière version
	TARBALL_URL=$(curl -s https://api.github.com/repos/TLeconte/acarsdec/releases/latest | grep '"tarball_url"' | cut -d '"' -f 4)

	# Vérification si l'URL est bien récupérée
	if [[ -z "$TARBALL_URL" ]]; then
	    echo "Erreur : Impossible de récupérer le lien de téléchargement."
	    exit 1
	fi

	# Téléchargement de l'archive
	echo "Téléchargement de acarsdec..."
	wget -q "$TARBALL_URL" -O "$ARCHIVE_NAME"

	# Suppression de l'ancienne installation si elle existe
	if [[ -d "$INSTALL_DIR" ]]; then
	    echo "Suppression de l'ancienne installation..."
	    rm -rf "$INSTALL_DIR"
	fi

	# Extraction de l'archive
	echo "Extraction de l'archive..."
	tar -xzf "$ARCHIVE_NAME"

	# Trouver le dossier extrait (qui a un nom dynamique)
	EXTRACTED_DIR=$(ls -d acarsdec-*/ 2>/dev/null | head -n 1)

	# Vérification si l'extraction s'est bien déroulée
	if [[ -z "$EXTRACTED_DIR" ]]; then
	    echo "Erreur : Impossible de trouver le dossier extrait."
	    exit 1
	fi

	# Déplacement vers le répertoire d'installation
	mv "$EXTRACTED_DIR" "$INSTALL_DIR"

	cd "$INSTALL_DIR"

	mkdir build
	cd build
	cmake .. -Drtl=ON
	make
	sudo make install

	# Nettoyage des fichiers temporaires
	rm -rf "$TMP_DIR"

	echo "ACARSDec est installée ✅️\n"
}

multimon-ng_install() {
	# Définition des variables
	INSTALL_DIR="~/Documents/Perso/APPS/sdr/multimon-ng"
	TMP_DIR="/tmp/multimon-ng_install"
	ARCHIVE_NAME="multimon-ng.tar.gz"

	# Création du répertoire temporaire
	mkdir -p "$TMP_DIR"
	cd "$TMP_DIR"

	# Récupération du lien de téléchargement de la dernière version
	TARBALL_URL=$(curl -s https://api.github.com/repos/EliasOenal/multimon-ng/releases/latest | grep '"tarball_url"' | cut -d '"' -f 4)

	# Vérification si l'URL est bien récupérée
	if [[ -z "$TARBALL_URL" ]]; then
	    echo "Erreur : Impossible de récupérer le lien de téléchargement."
	    exit 1
	fi

	# Téléchargement de l'archive
	echo "Téléchargement de multimon-ng..."
	wget -q "$TARBALL_URL" -O "$ARCHIVE_NAME"

	# Suppression de l'ancienne installation si elle existe
	if [[ -d "$INSTALL_DIR" ]]; then
	    echo "Suppression de l'ancienne installation..."
	    rm -rf "$INSTALL_DIR"
	fi

	# Extraction de l'archive
	echo "Extraction de l'archive..."
	tar -xzf "$ARCHIVE_NAME"

	# Trouver le dossier extrait (qui a un nom dynamique)
	EXTRACTED_DIR=$(ls -d multimon-ng-*/ 2>/dev/null | head -n 1)

	# Vérification si l'extraction s'est bien déroulée
	if [[ -z "$EXTRACTED_DIR" ]]; then
	    echo "Erreur : Impossible de trouver le dossier extrait."
	    exit 1
	fi

	# Déplacement vers le répertoire d'installation
	mv "$EXTRACTED_DIR" "$INSTALL_DIR"

	cd "$INSTALL_DIR"

	mkdir build
	cd build
	cmake ..
	make
	sudo make install

	# Nettoyage des fichiers temporaires
	rm -rf "$TMP_DIR"

	echo "Multimon-ng est installée ✅️\n"
}

kalibrate-rtl_install() {
	cd ~/Documents/Perso/APPS/sdr/
	wget https://github.com/steve-m/kalibrate-rtl/archive/refs/heads/master.zip
	unzip master.zip
	cd kalibrate-rtl-master
	./bootstrap && CXXFLAGS='-W -Wall -O3' ./configure && make
	rm ~/Documents/Perso/APPS/sdr/master.zip
	echo "Kalibrate est installé ✅️\n"
}

all_install() {
	apt_install;
	mkdir ~/Documents/Perso/APPS/sdr/
	libacars_install;
	acarsdec_install;
	multimon-ng_install;
	kalibrate-rtl_install;
	sudo apt autoremove -y
	echo "Les mises à jour sont installés ✅️\n"

	while true
	do
	    echo "The script is finished ✅️\nMake your choice: [R]eboot🔄, or [Q]uit🚪 : "
	    read -r REPLY
	    case $REPLY in
	        [Rr]* ) sudo reboot; break;;
	        [Qq]* ) echo "Bye 👋"; exit;;
	        * ) echo "⛔️Enter one of these letters: R, or Q";;
	    esac
	done
}

while true
do
    echo "Make your choice: [Y]es✔️, or [N]o❌ : "
    read -r REPLY
    case $REPLY in
        [Yy]* ) all_install; break;;
        [Nn]* ) echo "Bye 👋"; exit;;
        * ) echo "⛔️Enter one of these letters: Y or N";;
    esac
done
