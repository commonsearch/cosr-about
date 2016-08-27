Title: Tutorial: Analyzing the web with Spark on EC2
Slug: developer/tutorials/analyzing-the-web-with-spark-on-ec2
Template: page_developer

This tutorial get you through all the steps required to analyze a large number of web pages with [Apache Spark](spark.apache.org) on EC2 using our [Backend](/developer/backend).

Common Search has a plugin system that allows developers to build their own processing pipeline. For this tutorial, we will run a plugin that dumps a list of backlinks to a specific domain.

Common Search uses the same pipeline to index the web in Elasticsearch, so you can follow the same steps to do any operation on the document sources we support.

An [Amazon Web Services](https://aws.amazon.com/) account is needed for this tutorial, though depending on the volume you could run the pipeline entirely locally or on another cloud provider.




## 1. Install cosr-back and cosr-ops on your local machine

We have Docker containers ready to use so this step should take you only a few minutes!

There are 2 sets of instructions to follow:

 - [cosr-back/INSTALL.md](https://github.com/commonsearch/cosr-back/blob/master/INSTALL.md): Python code that analyzes the documents
 - [cosr-ops/INSTALL.md](https://github.com/commonsearch/cosr-ops/blob/master/INSTALL.md): Tools to manage operations and infrastructure




## 2. Understand how document sources and plugins work

You should view this process as a data pipeline with some document sources as input, and any number of plugins that can perform operations on the documents.

In this tutorial we will use one document source ([Common Crawl](https://www.commoncrawl.org)) and two plugins (one to filter documents, and one to dump our list of backlinks).

For this example, let's collect all links to Wikipedia pages, except those coming from Blogpost or Tumblr. This is how the pipeline looks:

[![Pipeline](/images/developer/tutorials/spark-backlinks-pipeline.svg)](/images/developer/tutorials/spark-backlinks-pipeline.svg)




## 3. Do a test run on your local machine

It is very useful to test your pipeline on a few of documents on your local machine before scaling up to billions of documents!

Open a console in the [cosr-back repository](https://github.com/commonsearch/cosr-back) you just installed, and run:

```
make docker_shell
```

This will take you inside a Docker container that already has all the dependencies you will need.

Now you need to build the command line for your job. Let's understand how it is structured first:

```
spark-submit [spark_options] \
	/cosr/back/spark/jobs/pipeline.py \
	--source [source_options] \
	--plugin [plugin_options] \
	[other_pipeline_options]
```

We don't need many [Spark options](http://spark.apache.org/docs/latest/configuration.html) in local, let's just use `--verbose`.

We are using [Common Crawl](https://github.com/commonsearch/cosr-back/blob/master/cosrlib/sources/commoncrawl.py) as a source, but let's limit ourselves to 8 segments of 1000 documents each for this test run with `--source commoncrawl:limit=8,maxdocs=1000`. This will use the latest available version of Common Crawl.

We are using 2 different plugins:

 - [plugins.filter.Domains](https://github.com/commonsearch/cosr-back/blob/master/plugins/filter.py): blacklists some domains we want to skip. You can configure it with `--plugin "plugins.filter.Domains:skip=1,domains=tumblr.com wordpress.com"` (note the quotes! we need them because the plugin argument includes a space).
 - [plugins.backlinks.MostExternallyLinkedPages](https://github.com/commonsearch/cosr-back/blob/master/plugins/backlinks.py): outputs a list of pages on a specific domain that have the most backlinks in the document sources we are processing. Let's configure it like this: `--plugin plugins.backlinks.MostExternallyLinkedPages:domain=wikipedia.org,path=out/top_wikipedia/`.

Finally, let's add another useful option to our job: `--stop_delay 600`. This will prevent Spark from exiting for 10 minutes when your job is done, so that we have time to open the Spark Web UI and see what happened!

Putting it all together, the command you need to run is:

```
spark-submit --verbose \
	/cosr/back/spark/jobs/pipeline.py \
	--source commoncrawl:limit=8,maxdocs=1000 \
	--plugin "plugins.filter.Domains:skip=1,domains=tumblr.com wordpress.com" \
	--plugin plugins.backlinks.MostExternallyLinkedPages:domain=wikipedia.org,path=out/top_wikipedia/ \
	--stop_delay 600
```

Spark has a very convenient Web UI that lets you debug the jobs that are running. Go ahead and open it in [http://localhost:4040](http://localhost:4040).

<div style="width:80%;margin:auto;text-align:center;font-size:12px;margin-bottom:20px;font-style:italic;"><img style="border:1px solid #C0C0C0;padding:5px;margin:5px;" src="/images/developer/tutorials/spark-backlinks-web-ui.png" alt="Spark Web UI" /><br/>The Spark Web UI</div>


Once all the jobs are done and you have finished exploring the Spark UI, go back to the console and send a `Ctrl-c` to the command to interrupt the `stop_delay`.

Now you can open the file `out/top_wikipedia/part-*.txt` that should have been created and make sure it is what you want!




## 4. Prepare a Spark cluster on EC2

Common Crawl typically has 30,000+ segments of 50,000+ documents each so processing each document on your local machine will take a while. Let's move to the cloud!

We are going to deploy a Spark cluster on a fleet of [Spot Instances on EC2](https://aws.amazon.com/ec2/spot/). Spot Instances are ideal for this kind of data processing: they cost much less than regular instances and if they are killed during our job, we can just run it again!

To deploy our Spark cluster on EC2 we are using a tool called [Flintrock](https://github.com/nchammas/flintrock). All it requires is a YAML configuration file.

There is a file in the [cosr-ops repository](https://github.com/commonsearch/cosr-ops) called [configs/flintrock.yaml.template](https://github.com/commonsearch/cosr-ops/blob/master/configs/flintrock.yaml.template). Rename it to `configs/flintrock.yaml` and change it with the values that match your AWS account.

If you don't have any yet, you will need to create a [Security Group](https://docs.aws.amazon.com/AmazonVPC/latest/GettingStartedGuide/getting-started-create-security-group.html) that allows at least ports 22, 4040 and 8080 from the outside, a [Placement Group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html) and a [Key Pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair). Additionally, you should also use your default [VPC](https://docs.aws.amazon.com/AmazonVPC/latest/GettingStartedGuide/getting-started-create-vpc.html) and [Subnets](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html#AddaSubnet), or create new ones.

We recommend saving your `.pem` key file in the `cosr-ops/configs/` directory so that it is visible from the Docker container (don't worry, it will be ignored by git). Remember to run `chmod 400 /cosr/ops/configs/*.pem` to avoid SSH errors.

We should now choose an instance type and a number of machines in our cluster. Our pipeline is usually CPU-bound, so the most important metric will be the number of cores. The [C4 instance family](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/c4-instances.html) has the best CPU performance/cost ratio, and it usually takes around 15 minutes for a C4 core to index a full Common Crawl segment.

So for this example, if we want to process the whole Common Crawl, we will need (15/60) * 30000 = 7500 CPU hours. If we want to run it in 24 hours, we will need 9 `c4.8xlarge` instances with 36 CPUs each. You could also do it in just a couple hours with more instances, but you might need to ask for a raise in [EC2 limits](https://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html) to be able to launch tens of them at once.

Note: it might be safer to start testing the job with only 2 instances and make sure everything goes well over ~1% of the data (`--source commoncrawl:limit=300`).

The last step is to create a configuration file for `cosr-back`. There is a file in the [cosr-ops repository](https://github.com/commonsearch/cosr-ops) called [configs/cosr-back.json.template](https://github.com/commonsearch/cosr-ops/blob/master/configs/cosr-back.json.template). You must rename it to `configs/cosr-back.json` but there should be no changes to perform, mainly because we are not using Elasticsearch in this tutorial.




## 5. Launch your Spark cluster

Once you have the configuration of your cluster filled in your `flintrock.yaml` file, you are ready to launch the cluster! Open a console in the [cosr-ops repository](https://github.com/commonsearch/cosr-ops) and just like the previous step, do this to enter the container:

```
make docker_shell
```

Once in the container, you should configure your AWS credentials, doing something like this:

```
export AWS_ACCESS_KEY_ID=AKIAxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=yyyyyyyyyyyyyyyyyyyyyyyyyy
```

Then, let's create the cluster:

```
make aws_spark_flintrock_create
```

If this command is successful, it will ultimately log you in the Spark master server.

The Web UI should also have been launched. Open it at http://[spark_master_hostname]:8080

If you want to log back in the Spark master, you can do `make aws_spark_flintrock_shell`. Other useful commands can be found in the [cosr-ops Makefile](https://github.com/commonsearch/cosr-ops/blob/master/Makefile).




## 6. Launch your index job

You have now a shell in the Spark master. This is very similar to step 3 except now you have much more CPUs at your fingertips and you are paying for each hour that the cluster spends online. So let's not waste any time!

First, let's open a [screen](https://kb.iu.edu/d/acuy) in the server, so that we don't loose anything if you are temporarily disconnected from the Internet.

```
screen -S sparkjob
```

You can exit this screen with the `Ctrl-a d` keys and go back into it with `screen -x sparkjob`.

If you are planning to save files to S3, you should also export your AWS credentials like you did on your local machine:

```
export AWS_ACCESS_KEY_ID=AKIAxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=yyyyyyyyyyyyyyyyyyyyyyyyyy
```

Now let's assemble a new `spark-submit` command like we did in step 3!

This time, there are a few flags that will change:

 - We want to use all the machines in the cluster so we have to explicitly reference the master in the Spark options. The internal address of the Spark master appears in the Web UI and should be something like `spark://ip-172-31-40-187:7077`.
 - We want to index the whole Common Crawl, so there are no more `limit` or `maxdocs` on our document source.
 - Gzipping the output file could be nice, so we'll add a `gzip=1` option to the backlinks plugin.
 - Storing the output file on the local filesystem won't work because we have many different machines! So we need to save it to S3. If you don't have an existing S3 bucket you can use, go ahead and [create one](https://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html) named `my-spark-results`.
 - With large EC2 instances, you should tell Spark to use most of the available RAM. For `c4.8xlarge` instances, we recommend adding the Spark arguments `--driver-memory 50G --executor-memory 50G`.

So this is the type of command we will run inside the `screen`:

```
spark-submit --verbose --master spark://[spark_master_ip]:7077 --driver-memory 50G --executor-memory 50G --properties-file /cosr/back/spark/conf/spark-defaults.conf \
	/cosr/back/spark/jobs/pipeline.py \
	--source commoncrawl \
	--plugin "plugins.filter.Domains:skip=1,domains=tumblr.com wordpress.com" \
	--plugin plugins.backlinks.MostExternallyLinkedPages:path=s3a://my-spark-results/top_wikipedia/,domain=wikipedia.org,gzip=1
```




## 7. Optional: Save intermediate results to S3

In the previous step, we are parsing data straight from Common Crawl and feeding it directly to the backlinks plugin. This can be suboptimal for 2 reasons:

 - If you want to run more than one plugin, Spark might go over all of Common Crawl again, wasting time and resources.
 - If the plugin fails or if you need to tweak the options, you will need to start from scratch again.

There is a convenient way of separating the parsing from the plugin execution: saving intermediate parsing results to S3!

This can be done by adding the `dump.DocumentMetadata` plugin to our pipeline:

```
spark-submit --verbose --master spark://[spark_master_ip]:7077 --driver-memory 50G --executor-memory 50G --properties-file /cosr/back/spark/conf/spark-defaults.conf \
	/cosr/back/spark/jobs/pipeline.py \
	--source commoncrawl \
	--plugin "plugins.filter.Domains:skip=1,domains=tumblr.com wordpress.com" \
	--plugin plugins.backlinks.MostExternallyLinkedPages \
	--plugin plugins.dump.DocumentMetadata:path=s3a://my-spark-results/intermediate-metadata/,abort=1
```

Note the `abort=1` option for the dump plugin: this will interrupt the pipeline before starting to aggregate the backlinks. However we still need to include the backlinks plugin in the pipeline so that its additional fields are included in the intermediate metadata.

After the pipeline has finished, you can check the folder `intermediate-metadata` in your S3 bucket. It will contain the list of outgoing links of each page, in [Apache Parquet](https://parquet.apache.org/) format.

Now, we can run the pipeline again with the `metadata` source pointed at the intermedate data:

```
spark-submit --verbose --master spark://[spark_master_ip]:7077 --driver-memory 50G --executor-memory 50G --properties-file /cosr/back/spark/conf/spark-defaults.conf \
	/cosr/back/spark/jobs/pipeline.py \
	--source metadata:path=s3a://my-spark-results/intermediate-metadata/ \
	--plugin plugins.backlinks.MostExternallyLinkedPages:path=s3a://my-spark-results/top_wikipedia/,domain=wikipedia.org,gzip=1
```

This should be pretty fast because the intermediate data is much smaller than the original source. You can run more pipelines and plugins based on the same data before discarding the intermediate metadata!


## 8. What's next

Once the pipeline is finished... congratulations! You just ran some code on billions of web pages :-)

Don't forget to terminate the EC2 instances with `make aws_spark_flintrock_destroy`.

There are a few things you may want to try after this:

 - Try our other [plugins](https://github.com/commonsearch/cosr-back/tree/master/plugins) and [document sources](https://github.com/commonsearch/cosr-back/tree/master/cosrlib/sources)... or create your own!
 - Index the documents into Elasticsearch! Stay tuned for a tutorial on this topic...
