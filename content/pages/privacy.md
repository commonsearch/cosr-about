Title: Privacy
Slug: privacy
Template: page_project

Respecting the privacy of our users is one of our [core values](/values#privacy).

Because we are a nonprofit organization, we don't have any incentive to collect or share personal information.

We are actually going in the opposite direction: trying to minimize the amount of traffic that goes through our servers!

## What we receive

We currently **don't use any cookie**. All our search pages have [permalinks](https://en.wikipedia.org/wiki/Permalink) and don't have any hidden parameters that would influence the results.

When a search was already done recently, users will get results directly from our CDN (CloudFlare), without hitting our servers at all.

The only information we (and our CDN) receive for each search are:

 - The query string, page number and language
 - The IP address of the user, from which a city-level location can be guessed
 - The user agent (name of the browser)

We currently do not store any of this, though we will probably start logging aggregate query volume (without IP addresses) to understand usage and provide autocompletion.

We will also open a [Tor hidden service](https://en.wikipedia.org/wiki/Tor_(anonymity_network)#Hidden_services) so that our users can safely mask their IP address. See [cosr-ops#8](https://github.com/commonsearch/cosr-ops/issues/8).

## Why you can trust us

Being completely transparent and open source actually makes our claims about privacy verifiable by everyone.

So don't take our word for it, just [look at the code](https://github.com/commonsearch)!

We will also research [reproducible builds](https://github.com/commonsearch/cosr-ops/issues/6) and ways of making sure that the code we run on our servers is the same that is public on GitHub.


## Going forward

We will continue to detail here the implications of our tech and product choices for privacy. At a minimum, we will use the great work done by [DuckDuckGo](https://duckduckgo.com/privacy) in this field as a baseline.

Feel free to contact us at [contact@commonsearch.org](mailto:contact@commonsearch.org) if you have any feedback or questions!