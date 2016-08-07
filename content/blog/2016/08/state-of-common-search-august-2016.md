Title: State of Common Search - August 2016
Slug: state-of-common-search-august-2016
Date: 2016-08-07 15:42:35
Author: commonsearch

There has been a lot happening at [Common Search](https://about.commonsearch.org/) lately: we published our first datasets, opened a Tor hidden service, switched to Slack and started doing automated UI tests!

<!-- PELICAN_END_SUMMARY -->

## First datasets

Last week, we published our [first two datasets](https://about.commonsearch.org/2016/07/our-first-public-datasets-host-level-webgraph-and-pagerank/): a host-level web graph and a host-level list of PageRanks.

We plan to release even more datasets in the future to keep our service as transparent as we can, so feel free to test them, analyze the data and suggest improvements!


## Tor hidden service

We use CloudFlare as a CDN, but we explicitly whitelisted Tor users so they should not have any issue connecting to our [UI Demo](https://uidemo.commonsearch.org/).

However, some users may want to access Common Search directly through Tor for better [privacy](/privacy), which is why we just opened a [Tor hidden service](https://www.torproject.org/docs/hidden-services.html.en) with a [.onion](https://en.wikipedia.org/wiki/.onion) address:

**[http://comsearchl2zlnre.onion](http://comsearchl2zlnre.onion)**

Please report any issues connecting to the service!


## Slack channel

Due to low traffic in our IRC channel, we have switched to [Slack](https://slack.commonsearch.org). Though it is closed source, we feel it is a better, pragmatic choice for allowing new contributors to join the community easily.

To join, just click on the button below:

<script async defer src="https://slack.commonsearch.org/slackin.js"></script>

If you still prefer IRC, Slack has a gateway that you can use with a regular IRC client. Register first with the button above and then follow their [instructions](https://get.slack.help/hc/en-us/articles/201727913-Connecting-to-Slack-over-IRC-and-XMPP).

## Automated UI tests

It is important that our [Frontend](/developer/frontend) behaves the same way regardless of the browser people use. To make sure it stays that way, we started doing [automated tests](https://github.com/commonsearch/cosr-front/tree/master/tests) with the [webdriver.io](http://webdriver.io/) project.

We are using [Sauce Labs](https://saucelabs.com/) to run the tests in many different browsers and operating systems. You can even see our [latest builds](https://saucelabs.com/open_sauce/user/commonsearch) with full in-browser replays. As an example, check out how Common Search behaves on [Windows 7 with IE 10](https://saucelabs.com/beta/tests/1a42c35a7f4d41d59c613b0c60d7ed54/commands)!


## Community

So far we've had **16** contributors, **14** users who submitted issues, **28** who commented on an issue, and **141** who starred [one of our repositories](https://github.com/commonsearch). A **very big thanks** to them all! We hope you too will [join our growing community](/contributing)!


## What's next?

Our #1 goal remains to grow the community with better documentation, easier setup for [new contributors](/contributing) and making sure their first-time experience is top-notch.

In the next few weeks, we will also update the index of the [UI Demo](https://uidemo.commonsearch.org/) with many more domains and get one step closer to a useful service for everyone!
