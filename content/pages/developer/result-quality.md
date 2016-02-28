Title: Result Quality
Slug: developer/result-quality
Template: page_developer

Improving the quality of our search results is an ongoing, complex project. Here are a few pointers to get you started.


## Explainer service

A fundamental requirement for [transparency](/values#transparency) is being able to explain the order of our search results. This is unheard-of in the search engine landscape!

[explain.commonsearch.org](https://explain.commonsearch.org) is dedicated to this, and provides complete visibility into the different ranking methods we use.

The final [Elasticsearch](https://elastic.co) score of each document is currently the product of 2 factors: the query score (specific to the searched terms) and the static ranking score (computed at index time).


## Query score

To understand how Elasticsearch scores documents depending on the search terms, we recommend reading [Controlling Relevance](https://www.elastic.co/guide/en/elasticsearch/guide/current/controlling-relevance.html) from their documentation first.

The [explainer](https://explain.commonsearch.org) outputs the full formula for each result, which makes understanding issues relatively easy (we will try to make the explain output even more readable).

You can also check our [current Elasticsearch mapping](https://github.com/commonsearch/cosr-back/blob/master/cosrlib/es_mappings.py) and the [Searcher class](https://github.com/commonsearch/cosr-back/blob/master/cosrlib/searcher.py) to review the settings we currently use.


## Static rankings

Static rankings are computed at index time, and don't depend on search terms. They are roughly equivalent to the "popularity" of each domain, though improving our document-level signals is a big priority.

You can view the [signals](https://github.com/commonsearch/cosr-back/tree/master/cosrlib/signals) we have implemented so far, as well as their [relative weights](https://github.com/commonsearch/cosr-back/blob/master/cosrlib/ranker.py).


## Unit tests

Making sure the tweaks we will make to the algorithms don't impact simple usecases is important, so we have implemented a first basic suite of [unit tests for rankings](https://github.com/commonsearch/cosr-back/tree/master/tests/rankingtests), which uses small corpuses of documents and their expected rankings for different searches.

This is obviously not nearly enough to make sure our results are relevant, but it helps to reason on very simple cases, rather than doing guesswork on the whole index.


## What's next

We need your help! You can have a look at the issues in [cosr-results](https://github.com/commonsearch/cosr-results/issues) and [cosr-back](https://github.com/commonsearch/cosr-back/issues) to see the current state of things and start [contributing](/contributing)!