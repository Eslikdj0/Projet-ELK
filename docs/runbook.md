

Ce document décrit les étapes nécessaires pour lancer, vérifier et arrêter 
la plateforme ELK Movies sur une machine vierge.

## 1. Prérequis

Avant de lancer le projet, assurez-vous que les outils suivants sont 
installés sur votre machine :

- **Docker Desktop** (version 4.x ou supérieure) avec Docker Compose intégré
- **Git** pour cloner le dépôt
- Une connexion internet active pour le premier téléchargement des images Docker

La configuration minimale recommandée est de 8 Go de RAM disponible, 
Elasticsearch étant gourmand en mémoire au démarrage.

## 2. Récupérer le projet

Clonez le dépôt GitHub sur votre machine et placez-vous dans le bon dossier :

```bash
git clone https://github.com/votre-repo/Projet-ELK.git
cd Projet-ELK/Notebook
```

## 3. Ajouter le dataset

Le fichier `Movies.csv` n'est pas versionné dans Git en raison de son poids. 
Il doit être placé manuellement dans le dossier `data/` avant tout lancement 


## 4. Lancer la stack

Depuis le dossier `Notebook/`, lancez tous les services avec la commande 
suivante :

```bash
docker compose up -d --build
```

Le flag `--build` est nécessaire uniquement au premier lancement ou après 
une modification du `Dockerfile.jupyter`. Lors des lancements suivants, 
`docker compose up -d` suffit.

Le démarrage complet prend entre 2 et 5 minutes selon la puissance de la 
machine. Elasticsearch est le service le plus long à initialiser.

## 5. Vérifier que tout fonctionne

Une fois la stack lancée, vérifiez l'état des services :

```bash
docker compose ps
```

Les quatre services doivent afficher le statut `running` ou `healthy` :
- `elasticsearch` → healthy
- `kibana` → healthy
- `logstash` → running
- `jupyter` → healthy

Testez ensuite chaque service individuellement :

```bash
# Elasticsearch — doit retourner un JSON avec "cluster_name"
curl http://localhost:9200

# Kibana — ouvrir dans le navigateur
http://localhost:5601

# Jupyter — ouvrir dans le navigateur (mot de passe : movieslab)
http://localhost:8888
```

## 6. Vérifier l'ingestion des données

Après le démarrage, Logstash commence automatiquement à lire le fichier 
`Movies.csv` et à envoyer les données vers Elasticsearch. L'ingestion 
complète de 769 631 documents prend plusieurs minutes.

Pour vérifier que les index existent et sont alimentés :

```bash
# Vérifier que movies_raw est alimenté
curl http://localhost:9200/movies_raw/_count

# Vérifier que movies_clean est alimenté
curl http://localhost:9200/movies_clean/_count
```

Les résultats attendus sont :
- `movies_raw` : environ **769 631** documents
- `movies_clean` : environ **707 934** documents

Si les compteurs sont à 0, attendez quelques minutes et relancez les 
commandes. Logstash peut mettre du temps à traiter l'ensemble du fichier.

## 7. Accéder au dashboard Kibana

Une fois les données ingérées, le dashboard est accessible depuis Kibana :

1. Ouvrir `http://localhost:5601`
2. Aller dans **Analytics → Dashboard**
3. Sélectionner le dashboard **Movies Analytics**

Si le dashboard n'apparaît pas, importez le fichier d'export fourni dans 
le dossier `docs/` :

1. Aller dans **Stack Management → Saved Objects**
2. Cliquer sur **Import**
3. Sélectionner le fichier `docs/kibana_export.ndjson`

## 8. Arrêter la stack

Pour arrêter proprement tous les services sans supprimer les données :

```bash
docker compose down
```

Pour arrêter et supprimer également les volumes (repart de zéro) :

```bash
docker compose down -v
```

> ⚠️ La commande `down -v` supprime toutes les données indexées dans 
> Elasticsearch. Il faudra relancer l'ingestion complète au prochain 
> démarrage.

## 9. Résolution des problèmes fréquents

**Elasticsearch ne démarre pas (unhealthy)**
Ce problème survient généralement quand la machine n'a pas assez de mémoire 
disponible ou quand le délai de démarrage est trop court. Relancez simplement 
`docker compose up -d` et attendez 3 à 5 minutes.

**Les index sont vides après le démarrage**
Vérifiez que le fichier `Movies.csv` est bien présent dans `data/` et que 
le fichier `logstash/pipeline/logstash.conf` n'est pas vide. Consultez les 
logs Logstash avec `docker logs logstash` pour identifier l'erreur.

**Kibana n'affiche pas les données**
Vérifiez que le Data View `movies_clean` est bien configuré dans Kibana :
aller dans **Stack Management → Data Views** et vérifier que l'index pattern 
`movies_clean` existe.

