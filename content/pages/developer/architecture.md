Title: Technical architecture overview
Slug: developer/architecture
Template: page_developer


## Our current needs

We are focused on getting a first alpha version of the service online, based on the ~150TB [Common Crawl](http://commoncrawl.org) monthly dumps.

Real-time or local search are not on the short-term [roadmap](/roadmap) and we will not personalize results for users, which means we can start with a very "static" architecture. Our main text index only needs to be refreshed every month, like Google did [up until 2003](https://moz.com/google-algorithm-change#2003).


## High-level overview

How the main components of Common Search fit together, as of February 2016:

[![Architecture](/images/developer/architecture-2016-02.svg)](/images/developer/architecture-2016-02.svg)

## Main components

Our [backend](/developer/backend) contains all the Python code working on the raw data, analyzing it and indexing it into Elasticsearch.

We have 2 [Elasticsearch](https://elastic.co) clusters: the largest one contains the main inverted index, mapping words to document IDs. The second one acts as a document store, mapping document IDs to their actual content.

User queries are sent to the [frontend](/developer/frontend), a Go server that forwards these requests to the index and returns them properly formatted as HTML or JSON if JavaScript is supported by the client.

We update our index once a month, so we can cache results aggressively in many edge locations around the world provided by a CDN, which lowers our costs and makes popular queries extremely fast.

## What's next

This architecture will continue to evolve as we scale up. We hope you [join us](/contributing) on this exciting journey!