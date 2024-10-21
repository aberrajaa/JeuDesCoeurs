# Jeu des Coeurs avec Intelligence Artificielle

## Description

Ce projet consiste en la création du jeu des **Cœurs** en utilisant **Flutter** pour le client, avec une intelligence artificielle (IA) basée sur **Monte Carlo Tree Search (MCTS)** et un réseau de neurones hébergé sur un serveur Python. L'application est adaptée pour fonctionner aussi bien sur **mobile** que sur **web**, offrant une expérience de jeu fluide et accessible sur plusieurs plateformes.

## Fonctionnalités

- **Interface utilisateur fluide** : Développée en Flutter, offrant une expérience utilisateur agréable sur mobile et web.
- **Intelligence Artificielle** : Utilise l'algorithme MCTS pour prendre des décisions stratégiques pendant le jeu.
- **Communication Client-Serveur** : Les interactions entre le client Flutter et le serveur Python permettent un jeu en temps réel.

## Prérequis

- **Flutter** : Assurez-vous d'avoir Flutter installé sur votre machine. Vous pouvez suivre les instructions [ici](https://flutter.dev/docs/get-started/install).
- **Python** : Installez Python 3.6 ou supérieur pour exécuter le serveur.
- **Bibliothèques Python** : Assurez-vous d'installer les bibliothèques nécessaires (à définir dans `requirements.txt` ou manuellement).

## Installation

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/votre_nom_utilisateur/coeurs.git

## Etape 1 : Lancer le serveur

1. Aller dans le dossier ./serveur/ia_server/src :
   ```bash
   cd serveur/ia_server/src
2. Lancer le serveur :
    ```bash
    py coeurs_serveur.py
   
## Etape 2 : Lancer le client

1. Aller dans le dossier ./client :
   ```bash
   cd client
2. Lancer le client :
   ```bash
   flutter run
3. Choisir le navigateur souhaité :
   1- Windows
   2- Chrome
   3- Edge

## Etape 3 : Jouez !

Vous pouvez ainsi jouer au jeu contre deux types d'intelligences artificielles (MCTS et réseaux de neuronnes). Les règles du jeu sont situées en haut à droite de la page d'accueil !



   
