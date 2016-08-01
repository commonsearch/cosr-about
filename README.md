# cosr-about

This repository contains our presentation website and blog hosted at https://about.commonsearch.org/.

You can use the [issues page](https://github.com/commonsearch/cosr-about) to suggest improvements to the content or layout!

## Local install with Docker

Running `cosr-about` on your local machine is very simple. You only need to have [Docker](https://docs.docker.com/engine/installation/) installed.

Once Docker is launched, just run:

```
[sudo] make docker_devserver
```

Then open http://192.168.99.100:9701/ in your browser. (Replace "192.168.99.100" by the address of your Docker machine. On a Mac, you can get it with `docker-machine ip boot2docker`)

## Alternate install without Docker

If for some reason you don't want to use Docker, you might be able to use your local Python install to run `cosr-about`. Please note that this is an unsupported method and might break at any time.

```
make virtualenv
make devserver
```

Then open http://localhost:9701/

## Tech details

This website uses [Pelican](http://blog.getpelican.com/) to statically generate a bunch of HTML files from [Markdown](http://commonmark.org/) source.

We use a customized [Bootstrap 3](http://getbootstrap.com/) template. We welcome any contributions to make it prettier!
