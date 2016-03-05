Title: Data sources
Slug: data-sources
Template: page_project

For [transparency](/values#transparency), we are committed to using only **publicly available data** to generate our search results.

Here is an exhaustive list of what we currently use:

 - **[Common Crawl](http://www.commoncrawl.org)**: The largest open repository of web crawl data. This is currently our unique source of raw page data.

 - **[Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page)**: A free, linked database that acts as central storage for the structured data of many Wikimedia projects like Wikipedia, Wikivoyage, Wikisource, ...

 - **[UT1 Blacklist](http://dsi.ut-capitole.fr/blacklists/index_en.php)**: Maintained by Fabrice Prigent from the Université Toulouse 1 Capitole, this blacklist categorizes domains and URLs into several categories, including "adult" and "phishing".

 - **[DMOZ](http://www.dmoz.org)**: Also known as the Open Directory Project, it is the oldest and largest web directory still alive. Though their data is not as reliable as it was in the past, we still use it as a signal and metadata source.

 - **[Web Data Commons Hyperlink Graphs](http://webdatacommons.org/hyperlinkgraph/2012-08/download.html)**: Graphs of all hyperlinks from a 2012 Common Crawl archive. We are currently using their Harmonic Centrality file as a temporary ranking signal on domains. We plan to perform our own analysis of the web graph in the near future.

 - **[Alexa top 1M sites](https://support.alexa.com/hc/en-us/articles/200461990-Can-I-get-a-list-of-top-sites-from-an-API-)**: Alexa ranks websites based on a combined measure of page views and unique site users. It is known to be demographically biased. We are using it as a temporary ranking signal on domains.

Do you know about another data source that could be useful? Send us an [email](mailto:contact@commonsearch.org)!