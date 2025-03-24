#!/usr/bin/env bash

#
# Script d'installation de paquets & configuration SDR
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
Version : 0.4

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

install_packages() {
    sudo apt update && sudo apt upgrade
    echo "Les paquets APT sont à jour ✅️"

    local packages=(
        git autoconf libtool automake ccze bmon cmake build-essential 
        libusb-1.0-0-dev rtl-sdr librtlsdr-dev zlib1g-dev libxml2-dev 
        sox rtl-433 udev lsof gqrx-sdr htop libjansson-dev
    )

    sudo apt install -y "${packages[@]}"
    echo "Les paquets APT sont installés ✅️"
}

download_and_install() {
    local repo=$1
    local install_dir=$2
    local tarball_name=$3

    # Créer le répertoire d'installation s'il n'existe pas
    if [ ! -d "$install_dir" ]; then
        mkdir -p "$install_dir"
    fi

    local tmp_dir=$(mktemp -d)
    local tarball_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tarball_url"' | cut -d '"' -f 4)

    if [[ -z "$tarball_url" ]]; then
        echo "Erreur : Impossible de récupérer le lien de téléchargement."
        exit 1
    fi

    # Télécharger le fichier tarball
    if ! wget -q "$tarball_url" -O "$tmp_dir/$tarball_name"; then
        echo "Erreur : échec du téléchargement du tarball."
        exit 1
    fi

    # Extraire l'archive
    local extracted_dir=$(tar -xzf "$tmp_dir/$tarball_name" -C "$tmp_dir" | grep -o '^[^/]*' | head -n 1)

    if [[ -z "$extracted_dir" ]]; then
        echo "Erreur : Impossible d'extraire l'archive."
        exit 1
    fi

    # Supprimer l'ancien répertoire d'installation et déplacer les fichiers extraits
    rm -rf "$install_dir"
    mv "$tmp_dir/$extracted_dir" "$install_dir"
    cd "$install_dir"

    # Nettoyage après installation
    rm -rf "$tmp_dir"
}

install_libacars() {
	local install_dir="~/Documents/Perso/APPS/sdr/libacars"
    download_and_install "szpajder/libacars" "$install_dir" "libacars.tar.gz"

	mkdir build && cd build
	cmake ../
	make
	sudo make install
	sudo ldconfig

	echo "La libacars2 est installée ✅️ (version: $(libacars --version))\n"
}

install_acarsdec() {
	local install_dir="~/Documents/Perso/APPS/sdr/acarsdec"
    download_and_install "TLeconte/acarsdec" "$install_dir" "acarsdec.tar.gz"

	mkdir build && cd build
	cmake .. -Drtl=ON
	make
	sudo make install

	echo "ACARSDec est installée ✅️ (version: $(libacars --version))\n"
}

install_multimon_ng() {
	local install_dir="~/Documents/Perso/APPS/sdr/multimon-ng"
    download_and_install "EliasOenal/multimon-ng" "$install_dir" "multimon-ng.tar.gz"

	mkdir build && cd build
	cmake ..
	make
	sudo make install

	echo "Multimon-ng est installée ✅️ (version: $(libacars --version))\n"
}

install_kalibrate_rtl() {
    local install_dir="$HOME/Documents/Perso/APPS/sdr/kalibrate-rtl"
    
    # Créer le répertoire s'il n'existe pas
    mkdir -p "$install_dir"
    cd "$install_dir"
    
    # Télécharger le fichier zip
    if ! wget https://github.com/steve-m/kalibrate-rtl/archive/refs/heads/master.zip -O "$install_dir/master.zip"; then
        echo "Erreur : échec du téléchargement."
        exit 1
    fi
    
    unzip master.zip
    cd kalibrate-rtl-master
    ./bootstrap && CXXFLAGS='-W -Wall -O3' ./configure && make
    rm "$install_dir/master.zip"

    echo "Kalibrate est installé ✅️ (version: $(libacars --version))\n"
}

main_install() {
    install_packages
    mkdir -p ~/Documents/Perso/APPS/sdr
    install_libacars
    install_acarsdec
    install_multimon_ng
    install_kalibrate_rtl

    sudo wget -O /etc/udev/rules.d/rtl-sdr.rules https://raw.githubusercontent.com/osmocom/rtl-sdr/master/rtl-sdr.rules
    sudo udevadm control --reload-rules
	sudo udevadm trigger
	usermod -aG plugdev ${SUDO_USER:-$USER}

    sudo apt autoremove -y
    echo "Installation terminée ✅️"
}

prompt_choice() {
    local prompt=$1
    local choice
    while true; do
        echo "$prompt"
        read -r choice
        case $choice in
            [Yy]* ) return 0;;
            [Nn]* ) echo "Bye 👋"; exit;;
            * ) echo "⛔️Entrez Y ou N";;
        esac
    done
}

# Demande initiale pour commencer l'installation
prompt_choice "Voulez-vous continuer ? [Y]es✔️, ou [N]o❌ : " && main_install

# Demande pour reboot ou quitter
while true; do
    echo "Installation terminée ✅️. [R]ebooter ou [Q]uitter ?"
    read -r REPLY
    case $REPLY in
        [Rr]* ) sudo reboot; break;;
        [Qq]* ) echo "Bye 👋"; exit;;
        * ) echo "⛔️Entrez R ou Q";;
    esac
done
