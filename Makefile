PWD := $(shell pwd)
PY?=python
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

S3_BUCKET=about.commonsearch.org

DATE = $(shell date +'%Y-%m-%d %H:%M:%S')
DATE_PATH = $(shell date +'%Y/%m')
SLUG = $(shell echo '${NAME}' | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)
EXT ?= md
PORT ?= 9701

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          start/restart develop_server.sh    '
	@echo '   make stopserver                     stop local server                  '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload                 upload the web site via Dropbox    '
	@echo '   make ftp_upload                     upload the web site via FTP        '
	@echo '   make s3_upload                      upload the web site via S3         '
	@echo '   make cf_upload                      upload the web site via Cloud Files'
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

serve-global:
ifdef SERVER
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 $(SERVER)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 0.0.0.0
endif


devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	$(BASEDIR)/develop_server.sh stop
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

publish:
	rm -rf $(OUTPUTDIR)-publish
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR)-publish -s $(PUBLISHCONF) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)-publish/; fi
	find $(OUTPUTDIR)-publish -name ".DS_Store" | xargs rm

s3_publish: publish
	s3cmd sync $(OUTPUTDIR)-publish/ s3://$(S3_BUCKET) --acl-public --delete-removed --guess-mime-type --default-mime-type text/html --no-preserve

.PHONY: html help clean regenerate serve serve-global devserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github

newpost:
ifdef NAME
	mkdir -p $(INPUTDIR)/blog/$(DATE_PATH)
	echo "Title: $(NAME)" >  $(INPUTDIR)/blog/$(DATE_PATH)/$(SLUG).$(EXT)
	echo "Slug: $(SLUG)" >> $(INPUTDIR)/blog/$(DATE_PATH)/$(SLUG).$(EXT)
	echo "Date: $(DATE)" >> $(INPUTDIR)/blog/$(DATE_PATH)/$(SLUG).$(EXT)
	echo "Author: commonsearch" >> $(INPUTDIR)/blog/$(DATE_PATH)/$(SLUG).$(EXT)
	echo "Status: draft" >> $(INPUTDIR)/blog/$(DATE_PATH)/$(SLUG).$(EXT)
	echo ""              >> $(INPUTDIR)/blog/$(DATE_PATH)/$(SLUG).$(EXT)
	echo ""              >> $(INPUTDIR)/blog/$(DATE_PATH)/$(SLUG).$(EXT)
	subl ${INPUTDIR}/blog/$(DATE_PATH)/${SLUG}.${EXT} &
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

#
# Specific commands for Common Search
#

# Build a new virtualenv with dependencies installed
virtualenv:
	rm -rf venv
	virtualenv venv
	venv/bin/pip install -r requirements.txt

# Build the docker image
docker_build:
	docker build -t commonsearch/about .

# Log into the Docker image
docker_shell: docker_build
	docker run -p $(PORT):$(PORT) -v "$(PWD):/cosr/about:rw" -w /cosr/about -i -t commonsearch/about bash

# Run the website in a container
docker_devserver:
	docker run -d -p $(PORT):$(PORT) -v "$(PWD):/cosr/about:rw" -w /cosr/about -i -t commonsearch/about sh -c "make devserver && sleep 99999999"

# Stop the container running the website
docker_stopserver:
	bash -c 'docker ps | tail -n +2 | grep -E "commonsearch/about" | cut -d " " -f 1 | xargs docker stop -t=0'
