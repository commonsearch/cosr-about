Title: State of Common Search - April 2016
Slug: state-of-common-search-april-2016
Date: 2016-04-06 14:36:19
Author: commonsearch

Common Search was [soft-launched](https://twitter.com/sylvinus/status/706605807354449920) one month ago, on March 6th. To keep up with the latest developments we will publish regular reports of our activity, starting with this one!

<!-- PELICAN_END_SUMMARY -->

# What's new?

In our first month, we had **7** contributors, **10** users who submitted issues, **21** who commented on an issue, and **93** who starred [one of our repositories](https://github.com/commonsearch). A **very big thanks** to them all! Here is an overview of what was done:

## Backend

 - Avoid indexing data URIs for images ([#21](https://github.com/commonsearch/cosr-back/issues/21)) - [Adrien di Pasquale](https://github.com/adipasquale)
 - Import Wikidata dumps ([#10](https://github.com/commonsearch/cosr-back/issues/10)) - [Sylvain Zimmer](https://github.com/sylvinus)
 - Update to Common Crawl's February 2016 crawl ([#24](https://github.com/commonsearch/cosr-back/issues/24)) - [Rafa](https://github.com/vanhalt)
 - Add status badges and code coverage ([#32](https://github.com/commonsearch/cosr-back/issues/32)) - Suggested by [Henning Jacobs](https://github.com/hjacobs)
 - Strip Unicode Emoji characters from page titles ([#42](https://github.com/commonsearch/cosr-back/pull/42)) - [Richard Townsend](https://github.com/Sentimentron)
 - Strip default ports from URLs ([#33](https://github.com/commonsearch/cosr-back/pull/33)) - [Henning Jacobs](https://github.com/hjacobs)

## Frontend

 - Avoid loosing selected language after clicking on logo ([#7](https://github.com/commonsearch/cosr-front/issues/7)) - [Yu Wu](https://github.com/chaconnewu)
 - Keyboard navigation v1 ([#10](https://github.com/commonsearch/cosr-front/issues/10)) - Progress by [JBaba](https://github.com/JBaba)
 - Basic highlighing in snippets ([#33](https://github.com/commonsearch/cosr-front/pull/33)) - [JBaba](https://github.com/JBaba)
 - Add approximated total result count ([#14](https://github.com/commonsearch/cosr-front/issues/14)) - [Yu Wu](https://github.com/chaconnewu)
 - Localized !bang codes ([#3](https://github.com/commonsearch/cosr-front/issues/3)) - [Sylvain Zimmer](https://github.com/sylvinus)

You can already test all these improvements in our [UI Demo](https://uidemo.commonsearch.org/)!

## Other

 - We made a few documentation improvements, simplified local setup with Docker images for all projects, and wrote a tutorial on [how to send a first Frontend patch](https://about.commonsearch.org/developer/tutorials/first-frontend-patch).
 - We made a first round of tweaks to the results (mainly for queries with 2+ terms) but we don't have proper tools to report on them yet.
 - Sylvain did a lightning talk about Common Search at [LibrePlanet 2016](https://libreplanet.org/2016/) and had very positive feedback about the [Explainer](https://explain.commonsearch.org) in particular.
 - We were featured on [Hacker News](https://news.ycombinator.com/item?id=11281700) for the first time!
 - We met with many friendly organizations like [Wikimedia](https://wikimedia.org), [Internet Archive](https://archive.org) and [Common Crawl](https://commoncrawl.org) in San Francisco to discuss how we could exchange data and tools to help each other.


# What's next?

We have set 2 primary goals for the next few months:

## 1. Reach 100 contributors

To grow, we need to continue optimizing our project for new contributions. We are tracking progress and ideas on how to reach 100 contributors in our dedicated repository [cosr-participation](https://github.com/commonsearch/cosr-participation/issues). Please consider [contributing](/contributing) and telling us about your first-timer experience afterwards!

## 2. Send a ranked URL seed list to Common Crawl

After meeting with the directors of Common Crawl, we laid out a tentative roadmap for contributing back to their project. This will directly improve our index and hopefully create a virtuous feedback loop.

For their past few monthly crawls, they have been using the same static seed list from Blekko, which we intend to complement or replace with a monthly list of our own. This file will be created by extracting all the URLs we find in their latest dump (even if they just appear in a link) and adding our open rankings.

Let's do this! :-)

---

*[Discuss this post](https://discuss.commonsearch.org/)*