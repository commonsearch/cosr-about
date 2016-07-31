Title: Our first public datasets: Host-level WebGraph and PageRank!
Slug: our-first-public-datasets-host-level-webgraph-and-pagerank
Date: 2016-07-31 15:22:54
Author: commonsearch


[Common Search](/) is building an open source search engine with [transparent](/values) rankings, and analyzing the hyperlinks on the web is a major part of this effort.

To make that possible, we are going to publish datasets that will let contributors, students and researchers reproduce the rankings, submit improvements and hopefully use the underlying data for their own work.

The first two we are happy to announce today are a **host-level WebGraph** and a list of **host-level PageRanks**.

<!-- PELICAN_END_SUMMARY -->

We want to give credit to both [Common Crawl](http://commoncrawl.org) for their amazing work and to the [Web Data Commons](http://webdatacommons.org/) project who published [similar dumps](http://webdatacommons.org/hyperlinkgraph/index.html) in 2012 and 2014.

Our datasets are released under a [Creative Commons Attribution 4.0 license](https://creativecommons.org/licenses/by/4.0/).

## Host-level WebGraph

This dataset is based on the [June 2016 Common Crawl](http://commoncrawl.org/2016/07/june-2016-crawl-archive-now-available/). It represents the directed graph of all hyperlinks aggregated at the hostname level (e.g. "about.commonsearch.org").

 - [vertices.txt.gz](https://dumps.commonsearch.org/webgraph/201606/host-level/graph/txt/vertices.txt.gz) (575M lines, 2.3 GB). Format: ```[int64 id] [hostname]```
 - [edges.txt.gz](https://dumps.commonsearch.org/webgraph/201606/host-level/graph/txt/edges.txt.gz) (112M lines, 4.7 GB). Format: ```[int64 src_id] [int64 dst_id]```

The Python code used to generate these files is [available on GitHub](https://github.com/commonsearch/cosr-back/blob/master/plugins/webgraph.py)!

## Host-level PageRank

This dataset was generated directly from the Host-level WebGraph above and contains a PageRank for the 112M hostnames found in the [June 2016 Common Crawl](http://commoncrawl.org/2016/07/june-2016-crawl-archive-now-available/).

 - [pagerank.txt.gz](https://dumps.commonsearch.org/webgraph/201606/host-level/pagerank/pagerank.txt.gz) (1.0 GB) with format ```[hostname] [pagerank]```
 - [pagerank-top1m.txt.gz](https://dumps.commonsearch.org/webgraph/201606/host-level/pagerank/pagerank-top1m.txt.gz) (10.8 MB) with only the top 1 million hostnames.

Here is the top 10:

```
facebook.com 244660.58
twitter.com 164232.66
blogger.com 77521.93
youtube.com 62967.95
plus.google.com 61344.234
instagram.com 39883.676
linkedin.com 34856.848
wordpress.org 33809.844
google.com 27425.883
pinterest.com 25640.172
```

There are several things to keep in mind:

 - The PageRank is not normalized: it ranges from 0.15 to 244660.58.
 - We used a [damping factor](https://en.wikipedia.org/wiki/PageRank#Damping_factor) of 0.85, tolerance of 0.001 and the algorithm stopped after 95 iterations. Edges with a contribution of less than 0.000001 were not used to accelerate convergence.
 - We have not yet made any effort to filter spam (more on this below).
 - There are a still a few high-profile websites entirely missing from Common Crawl because of their [robots.txt](https://en.wikipedia.org/wiki/Robots_exclusion_standard) rules, like facebook or linkedin. They appear in this dataset because they have incoming links from other websites but their PageRank is probably off.
 - We automatically remove the leading "www." and merge HTTP and HTTPS URLs together.
 - These PageRanks are not yet used in [Common Search](/) and will be one of several factors in the final rankings.
 - The Python code used to generate this dataset is [available on GitHub](https://github.com/commonsearch/cosr-back/blob/master/spark/jobs/pagerank.py).

## What to do next

We encourage everyone to analyze these datasets and **report their findings publicly**! You can also contact us [by email](/contact).

Here is a non-exhaustive list of interesting areas to explore:

 - Spam! We have opened an [issue in GitHub]() to track the progress. Join the fight!
 - Analyzing correlations between the PageRank dataset and other public domain rankings (Top sites in Alexa, ...)
 - Using the WebGraph dataset to create other metrics, for instance: [Centrality](https://en.wikipedia.org/wiki/Centrality), [CheiRank](https://en.wikipedia.org/wiki/CheiRank), [HITS](https://en.wikipedia.org/wiki/HITS_algorithm), [SALSA](https://en.wikipedia.org/wiki/SALSA_algorithm), ...
 - Review our [Python code on GitHub](https://github.com/commonsearch/cosr-back) to look for bugs and speed improvements!

Happy data exploration!

[Discuss this on our forum](https://discuss.commonsearch.org/t/feedback-on-our-first-host-level-datasets/32)

