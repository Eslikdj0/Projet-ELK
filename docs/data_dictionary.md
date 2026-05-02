# Data Dictionary - Movies Dataset

Ce document décrit la structure des données utilisées dans le projet ELK, plus particulièrement les champs indexés dans Elasticsearch après le nettoyage (`movies_clean`).

## Présentation du Dataset

Le dataset source (`Movies.csv`) contient 20 colonnes décrivant des informations détaillées sur des films. Lors de l'ingestion, un pipeline Logstash transforme ces données pour les rendre typées, requêtables et analysables dans Kibana.

## Dictionnaire des Champs (`movies_clean`)

| Champ | Type Elasticsearch attendu | Description | Transformations (Pipeline Logstash) |
| :--- | :--- | :--- | :--- |
| `id` | `keyword` / `text` | Identifiant unique du film. | Aucune. |
| `title` | `text` | Titre du film. | Exclusion des documents sans `title`. |
| `genres` | `text` (array) | Genres associés au film. | Éclaté en tableau (séparateur `-`). |
| `original_language` | `keyword` / `text` | Langue originale (ex: `en`, `fr`). | Mis en minuscules (`lowercase`). |
| `overview` | `text` | Synopsis détaillé du film. | Aucune. |
| `popularity` | `float` | Score de popularité. | Converti en `float`. |
| `production_companies` | `text` (array) | Sociétés de production. | Éclaté en tableau (séparateur `-`). |
| `release_date` | `date` | Date de sortie. | Exclusion si absente. Parsée format `yyyy-MM-dd`. |
| `budget` | `float` | Budget de production. | Converti en `float`. |
| `revenue` | `float` | Revenus générés. | Converti en `float`. |
| `runtime` | `float` | Durée du film (minutes). | Converti en `float`. |
| `status` | `keyword` / `text` | Statut de sortie (ex: *Released*). | Aucune. |
| `tagline` | `text` | Slogan ou phrase d'accroche. | Aucune. |
| `vote_average` | `float` | Note moyenne attribuée. | Converti en `float`. |
| `vote_count` | `integer` | Nombre total de votes. | Converti en `integer`. |
| `credits` | `text` (array) | Crédits (acteurs, équipe). | Éclaté en tableau (séparateur `-`). |
| `keywords` | `text` (array) | Mots-clés associés. | Éclaté en tableau (séparateur `-`). |
| `poster_path` | `text` | Chemin vers l'image de l'affiche. | Aucune. |
| `backdrop_path` | `text` | Chemin vers l'image de fond. | Aucune. |
| `recommendations` | `text` (array) | Films recommandés. | Éclaté en tableau (séparateur `-`). |

## Index : Différences `movies_raw` vs `movies_clean`

- **`movies_raw`** : Les données sont indexées sans modification à partir du `.csv` (quasi-totalité des champs en `text` brut). Les lignes non valides (en-tête, etc.) sont tout de même ignorées.
- **`movies_clean`** : Index principal pour l'analytique. Les types sont correctement castés (numérique, date), les textes normalisés, et les listes formatées en tableaux JSON exploitables pour des requêtes croisées ou des filtres Kibana pertinents.
