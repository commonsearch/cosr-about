#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import os

AUTHOR = u'Common Search'
SITENAME = u'Common Search'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'Europe/Paris'

THEME = 'theme'

DEFAULT_LANG = u'en'

ARTICLE_URL = '{date:%Y}/{date:%m}/{slug}'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{slug}/index.html'

DIRECT_TEMPLATES = ['index', 'archives', 'home']

TAGS_SAVE_AS = ''
TAG_SAVE_AS = ''
CATEGORIES_SAVE_AS = ''
CATEGORY_SAVE_AS = ''

FAVICON = "favicon.ico"
TOUCHICON = "apple-touch-icon-precomposed.png"

DEFAULT_DATE_FORMAT = "%b %d, %Y"

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

DEFAULT_PAGINATION = 10

INDEX_SAVE_AS = 'blog/index.html'
HOME_SAVE_AS = 'index.html'

PAGE_SAVE_AS = '{slug}.html'
PAGE_URL = '/{slug}'

PLUGIN_PATHS = ['plugins']
PLUGINS = ['summary']

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

PAGINATION_PATTERNS = (
    (1, '{base_name}/', '{base_name}/index.html'),
    (2, '{base_name}/page/{number}/', '{base_name}/page/{number}/index.html'),
)
