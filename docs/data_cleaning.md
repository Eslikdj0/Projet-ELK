# Documentation du Nettoyage des Données (Data Cleaning)

Ce document décrit le processus de nettoyage et de normalisation appliqué au dataset `Movies.csv` lors de l'ingestion vers Elasticsearch (`movies_clean`).

## 1. Contexte et Dataset

Le fichier source utilisé est le dataset complet de films contenant 20 colonnes :
- `id`, `title`, `genres`, `original_language`, `overview`
- `popularity`, `production_companies`, `release_date`
- `budget`, `revenue`, `runtime`, `status`, `tagline`
- `vote_average`, `vote_count`, `credits`, `keywords`
- `poster_path`, `backdrop_path`, `recommendations`

## 2. Anomalies Observées et Traitements

| Anomalie / Problème | Traitement Logstash | Justification |
| :--- | :--- | :--- |
| **Ligne d'en-tête** dans les données | Exclusion conditionnelle : `if [id] == "id" { drop {} }` | Évite l'indexation de l'en-tête du .csv comme un document. |
| **Documents incomplets** (Titre ou Date manquante) | Filtrage : `if ![title] or ![release_date] { drop {} }` | Les données sans titre ou date de sortie n'ont pas de plus value pour l'analyse. |
| **Champs techniques** parasites | `mutate { remove_field => ["@version", "host", ...] }` | Allège les index. |

## 3. Règles de Normalisation et de Typage

Les opérations suivantes ont été réalisées pour garantir l'exploitabilité dans Kibana :

### Conversions de types numériques
* `popularity`, `vote_average`, `budget`, `revenue` et `runtime` castés en `float`.
* `vote_count` casté en `integer`.
* Permet d'effectuer des agrégations (somme, moyenne, etc.) et des tris dans Kibana.

### Parsing des dates
* `release_date` : format converti de `yyyy-MM-dd` vers un format reconnu par Elasticsearch (via le filtre `date`).

### Normalisation de texte
* `original_language` : forcé en lettres minuscules (`lowercase`).
* Assure la cohérence des filtres (ex: éviter d'avoir "EN" et "en" séparés).

### Traitement des listes
* Les champs `genres`, `production_companies`, `credits`, `keywords` et `recommendations` sont séparés par le délimiteur `-`.
* Ils ont été convertis en véritables tableaux (arrays) Elasticsearch grâce au filtre `mutate { split => ... }` pour permettre des recherches croisées précises.

## 4. Impact du nettoyage

Le pipeline Logstash clone désormais l'événement pour indexer simultanément vers deux destinations :

1. **`movies_raw` (Avant)** : Les champs sont majoritairement des chaînes de caractères (`text`), avec la présence de métadonnées ou d'éventuelles lignes vides partielles. La date n'est qu'un simple texte (`"06-06-2023"`). Le volume brut testé est de **769 631 documents**.
2. **`movies_clean` (Après)** :
   - Volumes de données réduits suite au nettoyage : **707 934 documents** (soit 61 697 lignes anormales ou inutiles ignorées).
   - Les dates sont du type `date` Elasticsearch (`"2023-06-06T00:00:00.000Z"`).
   - Les indicateurs de popularité et votes sont identifiés en tant que `number` dans le Kibana Data View.
   - Les filtres sur la langue de diffusion sont uniformisés.

## 5. Tests et Validation

### **Commandes Kibana**   

```bash
# Vérification du mapping
GET /movies_clean/_mapping

# Nombre total brut
GET /movies_raw/_count

# Nombre total nettoyé
GET /movies_clean/_count


# Echantillon brut (Date en texte, chiffres en texte)
GET /movies_raw/_search
{
  "size": 1
}

# Echantillon propre (chiffres sans guillemets, langue en minuscule)
GET /movies_clean/_search
{
  "size": 1
}

# Vérification si le filtrage est fonctionnel. Devrait être 0
GET /movies_clean/_count
{
  "query": {
    "bool": {
      "should": [
        { "bool": { "must_not": { "exists": { "field": "title.keyword" } } } },
        { "bool": { "must_not": { "exists": { "field": "release_date" } } } }
      ],
      "minimum_should_match": 1
    }
  }
}

# Vérification si les opérations sont possible (donc que le typage a fonctionné)
GET /movies_clean/_search
{
  "query": {
    "range": {
      "popularity": {
        "gte": 2000
      }
    }
  },
  "_source": ["title", "popularity"]
}

# Nombre de film avec la langue en Majuscule (Devrait être 0)
GET /movies_clean/_count
{
  "query": {
    "regexp": {
      "original_language.keyword": ".*[A-Z].*"
    }
  }
}
```


