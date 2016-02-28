Title: Operations
Slug: developer/operations
Template: page_developer

The operations manage the deployment, performance and availability of our online service.


## Structure

The [cosr-ops repository](https://github.com/commonsearch/cosr-ops) contains tools and configurations for deploying and operating 2 components of our [infrastructure](/developer/architecture):

- Our Elasticsearch cluster, using [AWS CloudFormation](https://aws.amazon.com/cloudformation/).
- Our [Backend](/developer/backend), using the [Spark EC2 scripts](http://spark.apache.org/docs/latest/ec2-scripts.html).

All available commands are [documented in the Makefile](https://github.com/commonsearch/cosr-ops/blob/master/Makefile).


## Elasticsearch

CloudFormation allows us to provision an entire stack with instances and all their dependencies (security groups, IAM roles, Launch configurations, Auto-scaling groups, ...) in just one command.

The [aws/cloudformation](https://github.com/commonsearch/cosr-ops/tree/master/aws/cloudformation) directory contains scripts to generate a big JSON file that is sent to CloudFormation using the AWS command-line interface.

The [aws/elasticsearch](https://github.com/commonsearch/cosr-ops/tree/master/aws/elasticsearch) directory contains configuration files for our Elasticsearch cluster.

Our cluster has 3 types of nodes, as [explained in the Elasticsearch docs](https://www.elastic.co/guide/en/elasticsearch/reference/2.2/modules-node.html):

 - **Data nodes** that contain the actual index but never receive user queries directly.
 - **Client nodes** that receive the user queries and act as load balancers before the Data nodes.
 - **Master nodes** that help manage the cluster.

[Let us know](https://github.com/commonsearch/cosr-ops/issues) if you see tweaks in our [Elasticsearch configuration](https://github.com/commonsearch/cosr-ops/tree/master/aws/elasticsearch) that could be done to improve performance!


## Spark

We are currently using the [Spark EC2 scripts](http://spark.apache.org/docs/latest/ec2-scripts.html) to provision our Spark workers, though we aim to switch to CloudFormation in the future.

Our base AMI is [built using Packer](https://github.com/commonsearch/cosr-ops/tree/master/aws/spark).

Doing a full reindex currently requires a few manual steps:

 - Create a `configs/cosr-ops.prod.json` configuration file.
 - `make aws_spark_create` to create a Spark cluster with N workers.
 - `make aws_spark_deploy_cosrback` to deploy the latest backend code to the cluster.
 - `make aws_spark_ssh` to login into the master, open a screen, create the Elasticsearch indexes and then launch `spark-submit /cosr/back/jobs/spark/index.py` with the relevant options.

As our index size and the number of Spark jobs we run grow, we will need better scheduling and flexibility. [Let us know](https://github.com/commonsearch/cosr-ops/issues) if you'd like to help!


## Other components

 - [cosr-about](https://github.com/commonsearch/cosr-about) is deployed as static files on S3.
 - [cosr-front](https://github.com/commonsearch/cosr-front) is currently deployed on Heroku. We intend to migrate it to our own EC2 instances with CloudFormation in the future as well.
