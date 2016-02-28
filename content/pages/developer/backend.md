Title: Backend
Slug: developer/backend
Template: page_developer

Our backend is responsible for everything happening before indexing in Elasticsearch. It is not directly exposed to user queries.

## Structure

The [cosr-back repository](https://github.com/commonsearch/cosr-back) contains 3 main folders:

 - [cosrlib](https://github.com/commonsearch/cosr-back/tree/master/cosrlib): Python code for parsing, analyzing and indexing documents. This is where most of the intelligence resides.
 - [jobs](https://github.com/commonsearch/cosr-back/tree/master/jobs/spark): Spark jobs using cosrlib.
 - [urlserver](https://github.com/commonsearch/cosr-back/tree/master/urlserver): An internal service for getting metadata about URLs from static databases like DMOZ.
 - [explainer](https://github.com/commonsearch/cosr-back/tree/master/explainer): A web service for explaining and [debugging results](/developer/result-quality), hosted at [explain.commonsearch.org](https://explain.commonsearch.org/)

## Python guidelines

We chose [Python](https://python.org) for our backend because of its simplicity and vibrant community.

Some components for which performance is critical (like the [HTML parser](https://github.com/commonsearch/gumbocy)) may be written in lower-level languages as long as they have a Python interface.