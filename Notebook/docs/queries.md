# F5 — Requêtes Elasticsearch

## (Q1) Compter tous les films dans movies_clean
GET /movies_clean/_count

## (Q2) Voir un échantillon de 5 films
GET /movies_clean/_search
{
  "size": 5,
  "query": { "match_all": {} }
}

## (Q3) Rechercher un film par titre
GET /movies_clean/_search
{
  "query": {
    "match": {
      "title": "Batman"
    }
  }
}

## (Q4)  Rechercher par description
GET /movies_clean/_search
{
  "query": {
    "match": {
      "overview": "space adventure"
    }
  }
}

## (Q5) Top 10 films les plus populaires
GET /movies_clean/_search
{
  "size": 10,
  "sort": [{ "popularity": { "order": "desc" } }],
  "query": { "match_all": {} }
}

## (Q6 BOOL) Films en anglais avec note > 7
GET /movies_clean/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "original_language": "en" } }
      ],
      "filter": [
        { "range": { "vote_average": { "gte": 7 } } }
      ]
    }
  }
}

## (Q7 BOOL) Films Action sortis après 2010
GET /movies_clean/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "genres": "Action" } }
      ],
      "filter": [
        { "range": { "release_date": { "gte": "2010-01-01" } } }
      ]
    }
  }
}

## (Q8 BOOL) Films populaires mais PAS en anglais
GET /movies_clean/_search
{
  "query": {
    "bool": {
      "must": [
        { "range": { "popularity": { "gte": 50 } } }
      ],
      "must_not": [
        { "term": { "original_language": "en" } }
      ]
    }
  }
}

## (Q9 BOOL) Films avec gros budget ET gros revenu
GET /movies_clean/_search
{
  "query": {
    "bool": {
      "filter": [
        { "range": { "budget": { "gte": 100000000 } } },
        { "range": { "revenue": { "gte": 200000000 } } }
      ]
    }
  }
}

## (Q10 BOOL) — Films Drama ou Comedy bien notés
GET /movies_clean/_search
{
  "query": {
    "bool": {
      "should": [
        { "match": { "genres": "Drama" } },
        { "match": { "genres": "Comedy" } }
      ],
      "filter": [
        { "range": { "vote_average": { "gte": 7.5 } } }
      ],
      "minimum_should_match": 1
    }
  }
}

## (Q11) Nombre de films par langue
GET /movies_clean/_search
{
  "size": 0,
  "aggs": {
    "films_par_langue": {
      "terms": { "field": "original_language.keyword", "size": 10 }
    }
  }
}

## (Q12)
 Moyenne des notes par genre
GET /movies_clean/_search
{
  "size": 0,
  "aggs": {
    "par_genre": {
      "terms": { "field": "genres.keyword", "size": 10 },
      "aggs": {
        "note_moyenne": {
          "avg": { "field": "vote_average" }
        }
      }
    }
  }
}