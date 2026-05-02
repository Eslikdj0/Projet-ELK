# Gestion de Projet — Projet ELK Movies

Ce document décrit l'organisation du travail en équipe, les choix de 
workflow Git adoptés et la répartition des responsabilités entre les membres.

## 1. Organisation de l'équipe

Le projet a été réalisé en équipe de trois membres. Un lead technique a été 
désigné en début de projet afin de coordonner les décisions d'architecture, 
de valider les Pull Requests et de s'assurer de la cohérence globale du 
dépôt. Chaque membre a été responsable d'un périmètre fonctionnel clair, 
défini lors de la session de planning poker documentée dans 
`docs/planning_poker.md`.

## 2. Workflow Git (Gitflow)

Le dépôt est organisé autour de trois niveaux de branches. La branche 
`main` représente la version stable et finale du projet, celle qui sera 
évaluée. La branche `dev` est la branche d'intégration sur laquelle les 
features terminées et validées sont mergées au fil du projet. Enfin, chaque 
feature est développée sur sa propre branche nommée selon la convention 
`feat/F<numéro>-<slug>`, par exemple `feat/F1-bootstrap-stack`.

Aucun push direct sur `main` ou `dev` n'est autorisé. Tout ajout de code 
passe obligatoirement par une Pull Request, relue et approuvée par au moins 
un membre de l'équipe avant d'être mergée.

## 3. Pull Requests et reviews

Chaque Pull Request suit une structure commune : un titre explicite 
reprenant le nom de la feature, une description des changements réalisés, 
et les étapes pour tester le résultat. Le reviewer vérifie que la feature 
fonctionne, que le code est lisible et que la documentation associée est à 
jour avant d'approuver.

Cette pratique permet de garder un historique Git lisible et de s'assurer 
qu'aucune régression n'est introduite lors de l'intégration d'une nouvelle 
feature dans `dev`.

## 4. Ordre de réalisation des features

Les features ont été réalisées dans un ordre dicté par leurs dépendances 
techniques. La stack Docker devait être opérationnelle avant toute ingestion 
de données, et les données devaient être ingérées avant de pouvoir écrire 
des requêtes ou construire un dashboard. Le détail des dépendances et de 
l'ordre d'exécution est documenté dans `docs/planning_poker.md`.

En pratique, deux flux de travail ont été menés en parallèle une fois la 
stack fonctionnelle : d'un côté le nettoyage et le mapping des données, de 
l'autre le développement du moteur de recherche, celui-ci étant 
indépendant du reste de la chaîne.

## 5. Répartition des responsabilités

**Membre 1 Lead** a pris en charge la mise en place de l'environnement Docker 
(F1) et l'ingestion brute des données dans `movies_raw` (F2). Ces deux 
features constituent la fondation technique du projet et ont été les 
premières à être développées et mergées dans `dev`.

**Membre 2** a été responsable du nettoyage et de la normalisation des 
données (F3), de la définition du mapping Elasticsearch et du contrôle 
qualité (F4), ainsi que du développement du moteur de recherche (F8). Ces 
features représentent le cœur du traitement des données du projet.

**Membre 3** a pris en charge les requêtes analytiques DSL (F5) et la 
construction du dashboard Kibana (F6). Ces features constituent la couche 
de restitution et d'analyse de la plateforme.

La documentation finale (F7) a été produite collectivement, chaque membre 
contribuant à la partie correspondant à son périmètre fonctionnel.

## 6. Estimation de l'effort

L'effort global du projet a été estimé à **21 points** selon l'échelle 
utilisée lors du planning poker. La feature la plus complexe s'est révélée 
être la documentation finale (F7, estimée à 5 points), en raison de 
l'étendue des éléments à couvrir et du travail de synthèse que cela 
implique. Le nettoyage des données (F3) et les requêtes analytiques (F5) 
ont également été identifiés comme des features à effort significatif, 
estimées à 3 points chacune.

## 7. Retour d'expérience

Le principal point de friction rencontré en début de projet a été la 
configuration de l'environnement Docker sur Windows, notamment la gestion 
des chemins avec espaces et la synchronisation du démarrage des services 
via les healthchecks. Une fois la stack stabilisée, le travail en parallèle 
sur les branches a bien fonctionné grâce au découpage clair des 
responsabilités défini en amont.