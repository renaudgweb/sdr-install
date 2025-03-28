# 📡 sdr-install

<p align="center">
  <img src="ham-tux.jpg" alt="Ham Tux logo" width="300"/>
</p>

<p align="center">
  <a href="https://github.com/renaudgweb/server-install/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg" alt="made-with-bash"></a>
</p>

sdr linux installation

## 🚀 Utilisation

1. 🛠️ Donnez les permissions d'exécution au script :

`sudo chmod +x install.sh`

2. Exécutez le script d'installation :

`./install.sh`

## 📦 Paquets Installés

Voici la liste des paquets qui seront installés par le script :

- `rtl-sdr` : Outils pour utiliser des clés USB DVB-T Realtek comme récepteurs radio définis par logiciel (SDR). Permet de recevoir et de traiter des signaux radio.
- `rtl-433` : Décodeur de signaux radio numériques reçus par un récepteur SDR, supportant de nombreux protocoles utilisés par des dispositifs sans fil.
- `gqrx-sdr` : Application SDR conviviale pour recevoir et décoder divers signaux radio, comme la radio FM et les communications radioamateurs.
- `acarsdec` : Décodeur de messages ACARS utilisés par les avions pour communiquer avec les stations au sol.
- `multimon-ng` : Décodeur universel pour divers protocoles de communication numérique, comme POCSAG et FLEX.
- `kalibrate_rtl` : Outil de calibration des récepteurs SDR utilisant les signaux GSM pour déterminer la dérive de fréquence.
- `pifmrds` : Décodeur de données RDS des stations FM, permettant de recevoir des informations comme le nom de la station et le titre de la chanson.
- `gr-gsm` : Module pour GNU Radio permettant de recevoir et de décoder les signaux GSM. Il est utilisé pour analyser les communications mobiles GSM.
- `gnu-radio` : Plateforme de développement pour les systèmes de communication radio définis par logiciel (SDR). Elle permet de créer des flux de traitement de signaux radio personnalisés.
- `dump1090` : Outil de décodage pour les signaux ADS-B (Automatic Dependent Surveillance-Broadcast) utilisés par les avions pour transmettre leur position et d'autres informations. Il permet de suivre les avions en temps réel.
- `stratux` : Système de surveillance du trafic aérien basé sur Raspberry Pi, utilisant des récepteurs SDR pour recevoir les signaux ADS-B et UAT. Il fournit des informations sur le trafic aérien aux pilotes.
- `radiosonde_auto_rx ` : Outil automatisé pour recevoir et décoder les données des radiosondes météorologiques. Il permet de suivre et d'analyser les données météorologiques transmises par les ballons-sondes.

## ⚠️ Avertissement

Ce script est destiné à un usage éducatif et de développement uniquement.

---

👤 **Auteur :** Renaud G.

📌 **Version :** 1.0
