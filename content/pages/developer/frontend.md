Title: Frontend
Slug: developer/frontend
Template: page_developer

The frontend is responsible for responding to user queries.

## Structure

The [cosr-front repository](https://github.com/commonsearch/cosr-front) contains 2 main components:

 - A [Go server](https://github.com/commonsearch/cosr-front/tree/master/server) that receives user queries (as HTTP GETs for page loads or AJAX calls), sends them to an Elasticsearch index, and then returns results as HTML or JSON.
 - An optional [JavaScript/CSS layer](https://github.com/commonsearch/cosr-front/tree/master/static) that provides a fast, single-page search experience to the otherwise static result pages.

## Go guidelines

The Go server's job is mainly to do I/O operations as fast as possible. Most of the work on the data should have already been done by the [backend](/developer/backend).

We intend to follow all the best practices from the [Go community](https://golang.org/), as this kind of I/O server is one of the primary usecases of Go.

## JavaScript guidelines

The HTML pages returned by the Go server are meant to be self-sufficient.

However, when JavaScript is available, we can provide a much better search experience with results appearing as the user types.

The constraits for our [JavaScript layer](https://github.com/commonsearch/cosr-front/blob/master/static/js/index.js) are:

- **Progressive enhancement**: JavaScript should stay optional.
- **Small size**: The code will be sent to each client so each byte counts in the final minimized, gzipped file. We want to keep compatibility with the [Closure Compiler's advanced level](https://developers.google.com/closure/compiler/docs/api-tutorial3).
- **UI speed**: We must optimize for the feeling of speed from the end user, using tricks to mask network latency.
- **Portability**: The code must run the same on a wide range of modern browsers, though as we have a proper fallback we don't need to support legacy browsers.
- **Readability**: Let our toolchain minify the code, it must remain understandable by regular web developers.