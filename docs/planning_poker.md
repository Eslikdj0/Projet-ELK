# Planning Poker

## 1) Participants
- Membre 1
- Membre 2
- Membre 3

## 2) Échelle utilisée
1,2,3,4,5,6,7,8,9,10

## 3) Stories estimées
| ID | User Story | Votes initiaux | Estimation finale | Hypothèses | Owner |
| --- | --- | --- | --- | --- | --- |
| F1 | Bootstrap stack (Docker) | 2, 1, 1 | 1 | | Membre 1 |
| F2 | Ingestion brute (movies_raw) | 1, 1, 1 | 1 | Dépend de F1 | Membre 1 |
| F3 | Nettoyage & Normalisation | 3, 3, 3 | 3 | Dépend de F2 | Membre 2 |
| F4 | Mapping & Qualité (explicite) | 3, 2, 2 | 2 | Dépend de F3 | Membre 2 |
| F5 | Requêtes analytiques (12 DSL) | 4, 3, 3 | 3 | Dépend de F4 | Membre 3 |
| F6 | Dataviz Kibana (Dashboard) | 2, 2, 2 | 2 | Dépend de F4 | Membre 3 |
| F7 | Documentation finale | 8, 5, 5 | 5 | En parallèle | Tous |
| F8 | Moteur de recherche | 4, 4, 4 | 4 | Indépendant | Membre 2 |

## 4) Décisions de découpage
- **Dépendances identifiées** : 
  - `F1` (Bootstrap) est requis pour `F2` (Ingestion).
  - `F2` est requis pour `F3` (Nettoyage).
  - `F3` est requis pour `F4` (Mapping).
  - `F4` débloque `F5` (Requêtes) et `F6` (Dataviz).
  - `F8` (Moteur de recherche) est totalement indépendant.
- **Ordre d'exécution prévu** :
  - Flux 1 : `F1` -> `F2` -> `F8`
  - Flux 2 : `F3` -> `F4` -> `F5`, `F6` 
  - `F7` (Documentation) : à réaliser en parallèle par tous les membres.

## 5) Répartition finale des features
- **Membre 1** : F1 (Bootstrap stack), F2 (Ingestion brute), F7 (Documentation partagée)
- **Membre 2** : F3 (Nettoyage & Normalisation), F4 (Mapping & Qualité), F8 (Moteur de recherche), F7 (Documentation partagée)
- **Membre 3** : F5 (Requêtes analytiques), F6 (Dataviz Kibana), F7 (Documentation partagée)
