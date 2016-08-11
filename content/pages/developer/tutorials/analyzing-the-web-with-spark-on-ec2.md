Title: Tutorial: Analyzing the web with Spark on EC2
Slug: developer/tutorials/analyzing-the-web-with-spark-on-ec2
Template: page_developer

This tutorial get you through all the steps required to analyze a large number of web pages with Spark on EC2 using our [Backend](/developer/backend).

Common Search has a plugin system that allows developers to build their own processing pipeline. For this example, we will run a plugin that dumps a list of backlinks to a specific domain.

Common Search uses the same pipeline to index the web in Elasticsearch, so you can follow the same steps to do any operation on the document sources we support.

An [Amazon Web Services](https://aws.amazon.com/) account is needed for this tutorial, though depending on the volume you could run the pipeline entirely locally or on another cloud provider.


## 1. Install cosr-back and cosr-ops on your local machine

We have Docker containers ready to use so this step should take you only a few minutes!

You can follow the instructions in [cosr-back/INSTALL.md](https://github.com/commonsearch/cosr-back/blob/master/INSTALL.md) (which contains the Python code that analyzes the documents) and then [cosr-ops/INSTALL.md](https://github.com/commonsearch/cosr-ops/blob/master/INSTALL.md) (which contains the tools to manage operations and infrastructure).


## 2. Understand how document sources and plugins work

You should view this process as a data pipeline with some document sources as input, and any number of plugins that can perform operations on the documents.

In this tutorial we will use one document source (Common Crawl) and two plugins (one to filter documents, and one to dump our list of backlinks).

For this example, let's collect all links to Wikipedia pages, except those coming from Blogpost or Tumblr. This is how the pipeline looks:

[![Pipeline](/images/developer/tutorials/spark-backlinks-pipeline.svg)](/images/developer/tutorials/spark-backlinks-pipeline.svg)


## 3. Do a test run on your local machine

It is very useful to test your pipeline on a few of documents on your local machine before scaling up to billions of documents!

Open a console in the `cosr-back` repository you just installed, and run:

```
make docker_shell
```

This will take you inside a Docker container that already has all the dependencies you will need.

Now you need to build the command line for your job. Let's understand how it is structured first:

```
spark-submit [spark_options] jobs/spark/pipeline.py --source [source_options] --plugin [plugin_options] [other_pipeline_options]
```

We don't need many Spark options in local, let's just use `--verbose`.

We are using Common Crawl as a source, let's limit ourselves to 8 segments of 1000 documents each for this test run. This is done with `--source commoncrawl:limit=8,maxdocs=1000`. This will use the latest available version of Common Crawl.

We are using 2 different plugins. The first is `plugins.filter.Domains`: it blacklists some domains we want to skip. You can configure it with `--plugin "plugins.filter.Domains:skip=1,domains=tumblr.com wordpress.com"` (note the quotes! we need them because the plugin argument includes a space).

The second plugin is `plugin.hyperlinks.MostExternallyLinkedPages`. It will output a list of pages on a specific domain that have the most backlinks in the document sources we are processing. Let's configure it like this: `--plugin plugin.hyperlinks.MostExternallyLinkedPages:domain=wikipedia.org,path=out/top_wikipedia.txt`.

Finally, let's add another useful option to our job: `--stop_delay 600`. This will prevent Spark from exiting for 10 minutes when your job is done, so that we have time to open the Spark Web UI and see what happened!

Putting it all together, the command you need to run is:

```
spark-submit --verbose jobs/spark/pipeline.py --source commoncrawl:limit=8,maxdocs=1000 --plugin "plugins.filter.Domains:skip=1,domains=tumblr.com wordpress.com" --plugin plugin.hyperlinks.MostExternallyLinkedPages:domain=wikipedia.org,path=out/top_wikipedia.txt --stop_delay 600
```

This is what you should get as output:

XXXX

Spark has a very convenient Web UI that lets you debug the jobs that are running. Go ahead and open it in [http://localhost:4040](http://localhost:4040).

Once all the jobs are done and you have finished exploring the Spark UI, go back to the console and send a `Ctrl-C` to the command to interrupt the `stop_delay`.

Now you can open the file `out/top_wikipedia.txt` that should have been created and make sure it is what you want!


## 4. Create a Spark cluster on EC2

Now, Common Crawl typically has 20,000+ segments of 50,000+ documents each so processing each document on your local machine will take a while. Let's move to the cloud!

We are going to deploy a Spark cluster on a fleet of [Spot Instances on EC2](https://aws.amazon.com/ec2/spot/). Spot Instances are ideal for this kind of data processing: they cost much less than regular instances and if they are killed during our job, we can just run it again!

To deploy our Spark cluster on EC2 we are using a tool called [Flintrock](https://github.com/nchammas/flintrock). All it requires is a YAML configuration file.

There is a file in the `cosr-ops` repository called `configs/flintrock.yaml.template`. Rename it to `configs/flintrock.yaml` and change it with the values that match your AWS account.

We should now choose an instance type and a number of machines in our cluster. Our pipeline is usually CPU-bound, so the most important metric will be the number of cores. The [C4 instance family](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/c4-instances.html) has the best CPU performance/cost ratio, and it usually takes around 15 minutes for a C4 core to index a full Common Crawl segment.

For this example, this means that if we want to process the whole Common Crawl, we will need (15/60) * 20000 = 5000 CPU hours. If we want to run it in 24 hours, we will need 6 `c4.8xlarge` instances with 36 CPUs each. You could also do it in just a couple hours with more instances, but you might need to ask for a raise in EC2 limits to be able to launch tens of them at once.

Once you have the configuration of your cluster filled in your `flintrock.yaml` file, you are ready to launch the cluster! Open a console in the `cosr-ops` repository and just like the previous step, do `make docker_shell` to enter the container.

Once in the container, you should configure your AWS credentials, doing something like this:

```
export AWS_ACCESS_KEY_ID=AKIAxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=yyyyyyyyyyyyyyyyyyyyyyyyyy
```

Then, let's create the cluster:

```
make aws_spark_flintrock_create
```

If this command is successfuly, it will ultimately log you in the Spark master server.

The Web UI should also have been launched. Open it at http://[spark_master_hostname]:8080


## 5. Launch your index job

You have now a shell in the Spark master. This is very similar to step 3 except now you have much more CPUs at your fingertips and you are paying for each hour that the cluster spends online. So let's not waste any time!

First, let's open a `screen` in the server, so that we don't loose anything if you are temporarily disconnected from the Internet.

```
screen -S sparkjob
```

You can exit this screen with `Ctrl-A D` and go back into it with `screen -x sparkjob`.

Now let's assemble a new `spark-submit` command like we did in step 3!

This time, there are a few flags that will change:

 - We want to use all the machines in the cluster so we have to explicitly reference the master in the Spark options. The internal address of the Spark master appears in the Web UI and should be something like `spark://ip-172-31-40-187:7077`.
 - We want to index the whole Common Crawl, so there are no more `limit` or `maxdocs` on our document source.
 - Gzipping the output file could be nice, so we'll add a `gzip=1` option to the hyperlinks plugin.
 - Storing the `top_wikipedia.txt` file on the local filesystem won't work because we have many different machines! So we need to save it to S3. If you don't have an existing S3 bucket you can use, go ahead and create one named `my-spark-results`.

So this is the type of command we will run inside the `screen`:

```
spark-submit --verbose --master spark://[spark_master_ip]:7077 jobs/spark/index.py --source commoncrawl --plugin "plugins.filter.Domains:skip=1,domains=tumblr.com wordpress.com" --plugin plugin.hyperlinks.MostExternallyLinkedPages:path=s3a://my-spark-results/top_wikipedia.txt,domain=wikipedia.org,gzip=1 --stop_delay 600
```

Once the pipeline is finished... congratulations! You just ran some code on billions of web pages :-)

There are a few things you may want to try after this:

 - Try our other plugins and document sources... or create your own!
 - Index the documents into Elasticsearch, like Common Search does.
