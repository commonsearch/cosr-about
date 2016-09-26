Title: Tutorial: Running PageRank on the Web
Slug: developer/tutorials/running-pagerank-on-the-web
Template: page_developer

This tutorial get you through all the steps required to run PageRank on billions of pages using Common Search's codebase and tools such as Apache Spark and AWS.



## 1. Prerequisites

You should go through our [Analyzing the web with Spark on EC2](/developer/tutorials/analyzing-the-web-with-spark-on-ec2) first, to install the required software, understand the basic concepts of our pipeline, and run a simpler job first, at least on your local machine.

You should also be familiar with basic [Graph theory](https://en.wikipedia.org/wiki/Graph_theory).



## 2. Dumping the Web Graph

Before computing PageRank, we need to parse all the link in our corpus and save them as a directed graph.

(In some cases, you can actually skip this step by using one of the [dumps we publish](https://about.commonsearch.org/2016/07/our-first-public-datasets-host-level-webgraph-and-pagerank) directly.)

To dump the web graph, we are doing to use the `webgraph` plugin. Here is how you would dump it for the first 400 URLs from Common Crawl, at the host level:

```
spark-submit --verbose \
	/cosr/back/spark/jobs/pipeline.py \
	--source commoncrawl:limit=4,maxdocs=100 \
	--plugin plugins.webgraph.DomainToDomainParquet:path=out/webgraph/ \
	--stop_delay 600
```

This will actually create 2 subdirectories in `out/webgraph/`: one for the vertices and one for the edges. Both dumps will be stored as Apache Parquet format, so that we can easily reuse them in the next step.

You might notice this command will go over the source documents multiple times. This shouldn't be a big issue with so few documents, but at scale you will definitely want to use an intermediate dump as explained in the [Analyzing the web with Spark on EC2](/developer/tutorials/analyzing-the-web-with-spark-on-ec2) tutorial.


## 3. Computing PageRank

We are now ready to run the iterative PageRank algorithm over our web graph dump.

This is not done though our usual `pipeline.py` Spark job but with a dedicated one, like this:

```
spark-submit --verbose \
	/cosr/back/spark/jobs/pagerank.py \
	--webgraph out/webgraph/ \
	--dump out/pagerank/ \
	--tmpdir /tmp/spark-pr/ \
	--maxiter 20 --tol 0.001 --precision 0.000001 \
	--stats 5 \
	--include_orphans \
	--stop_delay 600
```

Let's review these new options:

 - `--dump` specifies the final output directory for the list of PageRanks
 - `--tmpdir` specifies a directory (which may also be on S3) that will be used to store intermediate results every 5 iterations of the PageRank algorithm, for performance and lower memory requirements.
 - `--maxiter 20 --tol 0.001 --precision 0.000001` are parameters for the PageRank convergence. (TODO explain them better)
 - `--stats 5` will print statistics on the algorithm every 5 iterations
 - `--include_orphans` will keep vertices without any inbound link in the graph (they should all have PR=0.15)
