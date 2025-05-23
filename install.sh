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
Version : 1.0

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
        git autoconf libtool automake bmon cmake build-essential 
        libusb-1.0-0-dev rtl-sdr librtlsdr-dev zlib1g-dev gnuradio
        libsndfile1-dev libxml2-dev lame libsox-fmt-mp3 rtl-433
        udev lsof gqrx-sdr libjansson-dev ffmpeg sox oggfwd
        pkg-config libcppunit-dev swig doxygen liblog4cpp5-dev
        gnuradio-dev gr-osmosdr libosmocore-dev
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
    tar -xzf "$tmp_dir/$tarball_name" -C "$tmp_dir"

    # Trouver le nom du dossier extrait
    local extracted_dir=$(find "$tmp_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)

    if [[ -z "$extracted_dir" ]]; then
        echo "Erreur : Impossible d'extraire l'archive."
        exit 1
    fi

    # Supprimer l'ancien répertoire d'installation et déplacer les fichiers extraits
    rm -rf "$install_dir"
    mv "$extracted_dir" "$install_dir"
    cd "$install_dir"
    # Nettoyage après installation
    rm -rf "$tmp_dir"
}

install_libacars() {
	local install_dir="$HOME/Documents/sdr/libacars"
    download_and_install "szpajder/libacars" "$install_dir" "libacars.tar.gz"

	mkdir build && cd build
	cmake ../
	make
	sudo make install
	sudo ldconfig

	if command -v decode_acars_apps &>/dev/null; then
        echo -e "libacars2 est installée ✅️ (version: $(decode_acars_apps -v))\n"
    else
        echo -e "libacars2 est installée ✅️ (commande decode_acars_apps non trouvée)\n"
    fi
}

install_acarsdec() {
	local install_dir="$HOME/Documents/sdr/acarsdec"
    download_and_install "TLeconte/acarsdec" "$install_dir" "acarsdec.tar.gz"

	mkdir build && cd build
	cmake .. -Drtl=ON
	make
	sudo make install

    if command -v decode_acars_apps &>/dev/null; then
        echo -e "ACARSDec est installée ✅️ (version: $(acarsdec --version))\n"
    else
        echo -e "libacars2 est installée ✅️ (commande acarsdec non trouvée)\n"
    fi
}

install_multimon_ng() {
	local install_dir="$HOME/Documents/sdr/multimon-ng"
    download_and_install "EliasOenal/multimon-ng" "$install_dir" "multimon-ng.tar.gz"

	mkdir build && cd build
	cmake ..
	make
	sudo make install

    if command -v decode_acars_apps &>/dev/null; then
        echo -e "Multimon-ng est installée ✅️ (version: $(multimon-ng -V))\n"
    else
        echo -e "libacars2 est installée ✅️ (commande multimon-ng non trouvée)\n"
    fi
}

install_kalibrate_rtl() {
    local install_dir="$HOME/Documents/sdr/kalibrate-rtl"
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

    if command -v decode_acars_apps &>/dev/null; then
        echo -e "Kalibrate est installé ✅️ (version: $(kal -v))\n"
    else
        echo -e "libacars2 est installée ✅️ (commande kal non trouvée)\n"
    fi
}

install_pifmrds() {
    cd $HOME/Documents/sdr && git clone https://github.com/ChristopheJacquet/PiFmRds.git
    cd PiFmRds/src
    make clean
    make
    echo -e "PiFMRDS est installé ✅️\n"
}

install_gr_gsm() {
    cd $HOME/Documents/sdr && git clone https://gitea.osmocom.org/sdr/gr-gsm
    cd gr-gsm
    mkdir build
    cd build
    cmake ..
    mkdir $HOME/.grc_gnuradio/ $HOME/.gnuradio/
    make
    sudo make install
    sudo ldconfig
    echo -e "gr-gsm est installées ✅️\n"
}

install_dump1090() {
    cd $HOME/Documents/sdr && git clone https://github.com/MalcolmRobb/dump1090.git
    cd dump1090
    make
    echo -e "Dump1090 est installées ✅️\n"
}

install_radiosonde() {
    cd $HOME/Documents/sdr && git clone https://github.com/projecthorus/radiosonde_auto_rx.git
    cd radiosonde_auto_rx
    pip install -r requirements.txt
    cp config/station.cfg.example config/station.cfg
    echo -e "Radiosonde est installées ✅️\n"
}

install_stratux() {
    cd $HOME/Documents/sdr && git clone https://github.com/cyoung/stratux.git
    cd stratux
    make all
    sudo make install
    echo -e "Stratux est installées ✅️\n"
}

udev_install() {
    sudo wget -O /etc/udev/rules.d/rtl-sdr.rules https://raw.githubusercontent.com/osmocom/rtl-sdr/master/rtl-sdr.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    usermod -aG plugdev ${SUDO_USER:-$USER}
    echo -e "rtl-sdr rules installées ✅️\n"
}

main_install() {
    install_packages
    mkdir -p $HOME/Documents/sdr
    install_libacars
    install_acarsdec
    install_multimon_ng
    install_kalibrate_rtl
    install_pifmrds
    install_gr_gsm
    install_dump1090
    install_radiosonde
    install_stratux
    udev_install

    sudo apt update && sudo apt -y autoremove && sudo apt -y clean
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
    echo "Installation terminée 🚀. [R]ebooter ou [Q]uitter ?"
    read -r REPLY
    case $REPLY in
        [Rr]* ) sudo reboot; break;;
        [Qq]* ) echo "Bye 👋"; exit;;
        * ) echo "⛔️Entrez R ou Q";;
    esac
done
