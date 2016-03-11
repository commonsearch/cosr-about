Title: Tutorial: Your first Frontend patch
Slug: developer/tutorials/first-frontend-patch
Template: page_developer

This tutorial get you through all the steps required to send a first patch to our [Frontend](/developer/frontend).



## 1. Install cosr-front on your local machine

You can follow the instructions in [cosr-front/INSTALL.md](https://github.com/commonsearch/cosr-front/blob/master/INSTALL.md).

Please note that if you intend to send a patch, you should **fork the repository first** and clone your fork instead of our official repository. You will send a Pull Request later to contribute your patch to the main repository.



## 2. Choose an issue to fix

Our [Get Started](/developer/get-started) page is a helpful resource to understand how to choose a first easy issue.

For this tutorial, we will fix [cosr-front#3](https://github.com/commonsearch/cosr-front/issues/3) by implementing localized [!bang codes](https://duckduckgo.com/bang). This is a Go issue but most of this tutorial also applies to HTML, JS and CSS issues.

<a href="https://github.com/commonsearch/cosr-front/issues/3"><img src="/images/developer/tutorials/first-frontend-patch-issue.png" alt="cosr-front#3" style="width:500px;margin:auto;display:block;" /></a>

If you don't find anything to work on, please [send us an email](/contact) describing your skills briefly and we will help you find something to start with!



## 3. Understand the issue

Most of our issues should be self-explanatory but if you have any doubts, **just ask!** Our maintainers will be happy to help you.

In the case of [cosr-front#3](https://github.com/commonsearch/cosr-front/issues/3), a link is provided to the [bangs.json](https://github.com/commonsearch/cosr-front/blob/5cd14caa067b0a3b84aad2bdfe818295184be57e/server/bangs.json) file. It looks like there is no way to specify other languages indeed. Let's do this!



## 4. Add a test

It is a very good practice to add a test before patching the code itself. This will help you set expectations for the new behaviour and make sure they are not broken in future patches.

In our case, there is already a [bangs_test.go](https://github.com/commonsearch/cosr-front/blob/5cd14caa067b0a3b84aad2bdfe818295184be57e/server/bangs_test.go) file that does some simple checks on the `DetectBang()` function we are going to patch.

Let's make sure that the tests pass before changing anything:

```
make docker_test
```

This should take a few seconds because it runs all available tests. In this case if you want to go even faster, you can go into the Docker container and run only the Go tests:

```
make docker_shell
make gotest
```

You can read the [patch to the tests](https://github.com/commonsearch/cosr-front/pull/24/files#diff-43e2e47b456d624a78e6b854480a74ce) where we added a new `lang` parameter to the `DetectBang()` function. The tests are now failing, as expected!

<img src="/images/developer/tutorials/first-frontend-patch-failing-tests.png" alt="Failing tests" style="width:500px;margin:auto;display:block;" />



## 5. Fix the code

For this example, the [patch](https://github.com/commonsearch/cosr-front/pull/24/files) is straightforward: we will just add a new level of data in the file for each language, with a default of "any".

Some patches will be more complex so don't hesitate to reach out to the maintainers for help by posting a comment in the issue tracker!



## 6. Send a Pull Request

Once you think the patch is ready, go to your fork on GitHub and use the "New pull request" button.

<img src="/images/developer/tutorials/first-frontend-patch-pull-request.png" alt="New Pull Request" style="width:500px;margin:auto;display:block;" />

GitHub has a complete guide on [how to use pull requests](https://help.github.com/articles/using-pull-requests/) that you can follow.

## 7. Congratulations!

Once your [Pull Request is sent](https://github.com/commonsearch/cosr-front/pull/24), one of our maintainers will review it and follow up with you.

Congratulations and welcome to this community! :-)

We would love to hear about your first experience contributing, so please [reach out](/contact) or open an issue in our [cosr-participation repository](https://github.com/commonsearch/cosr-participation/issues)!