# Script de démonstration — Projet ELK Movies

## Objectif
Démontrer le fonctionnement complet de la stack ELK :
lancement de l'environnement, ingestion des données films,
dashboard Kibana et moteur de recherche.

## Prérequis
- Docker Desktop installé et lancé
- Le fichier movies.csv placé dans Notebook/data/
  (lien de téléchargement disponible dans le README.md)

## Étapes

### 1. Ouverture du projet dans VSCode
- Ouvrir VSCode avec le dossier racine Projet-ELK
- Montrer la structure complète du projet :
  - docs/ : data_cleaning.md, data_dictionary.md,
    planning_poker.md, project_management.md, runbook.md
  - Notebook/dashboard/ : dashboard_projet_elk.ndjson
  - Notebook/data/ : movies.csv (dataset de 81 194 films)
  - Notebook/docs/ : queries.md
  - Notebook/logstash/pipeline/ : logstash.conf
  - search-engine/ : index.html
  - docker-compose-manager.bat
  - docker-compose.yml
  - DocumentSynthese.pdf

### 2. README
- Ouvrir README.md à la racine du projet
- Montrer la section téléchargement du fichier movies.csv
  (lien Kaggle vers le dataset Millions of Movies)

### 3. Lancement de la stack Docker
- Faire un clic droit sur docker-compose-manager.bat
- Copier le chemin (Copy Path)
- Ouvrir le terminal dans VSCode
- Coller le chemin et appuyer sur Entrée
- La stack démarre avec 4 containers :
  - elasticsearch (port 9200)
  - kibana (port 5601)
  - logstash (ingestion du CSV)
  - jupyter (port 8888)
- Logstash lit movies.csv et indexe les données dans :
  - movies_raw : données brutes
  - movies_clean : données nettoyées et typées

### 4. Kibana — Vérification des données
- Ouvrir le navigateur sur http://localhost:5601
- Attendre que Kibana charge complètement

### 5. Kibana — Import du dashboard
- Aller dans Stack Management > Saved Objects
- Cliquer sur Import
- Sélectionner le fichier :
  Notebook/dashboard/dashboard_projet_elk.ndjson
- Cliquer sur Import puis Done

### 6. Kibana — Dashboard
- Aller dans le menu > Dashboard
- Ouvrir Dashboard_Projet_ELK
- Scroller pour montrer les 6 visualisations :
  1. Metric : nombre total de films (81 194)
  2. Pie chart : répartition des films par langue
     → l'anglais domine largement le dataset
  3. Bar chart : top genres les plus fréquents
     → Drama, Comedy et Action en tête
  4. Line chart : évolution du nombre de films par année
     → forte croissance à partir des années 2000
  5. Bar chart horizontal : distribution des notes
     → majorité des films entre 5 et 7
  6. Tableau : top 5 films les plus populaires
     → The Northman en tête avec 3 669 points

### 7. Moteur de recherche — VSCode
- Revenir dans VSCode
- Ouvrir le dossier search-engine
- Montrer le fichier index.html

### 8. Moteur de recherche — Navigateur
- Ouvrir le navigateur sur http://localhost:8080
- Tester les fonctionnalités dans l'ordre :
  1. Recherche par nom : taper "Batman"
     → affiche tous les films Batman
  2. Filtre par note : mettre 7 minimum
     → affiche uniquement les films bien notés
  3. Filtre par date : mettre 2010
     → affiche les films sortis à partir de 2010
  4. Filtre par langue : taper "fr"
     → affiche les films en français

## Résultat attendu
La stack démarre sans erreur, les données sont bien
indexées, le dashboard affiche des visualisations
exploitables et le moteur de recherche retourne
des résultats pertinents.