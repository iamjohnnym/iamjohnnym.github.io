# https://simpleit.rocks/ruby/jekyll/tutorials/how-to-add-bootstrap-4-to-jekyll-the-right-way
SHELL := /bin/bash
BUNDLE := bundle
YARN := yarn
VENDOR_DIR = assets/vendor/
HTMLPROOF := $(BUNDLE) exec htmlproofer
JEKYLL := $(BUNDLE) exec jekyll

PROJECT_DEPS := Gemfile package.json

.PHONY: all clean install update

all : serve

check:
	$(JEKYLL) doctor
	$(HTMLPROOF) --check-html \
		--http-status-ignore 999 \
		--internal-domains localhost:4000 \
		--assume-extension \
		_site

install: $(PROJECT_DEPS)
	$(BUNDLE) install
	$(YARN) install

update: $(PROJECT_DEPS)
	$(BUNDLE) update
	$(YARN) upgrade

include-yarn-deps:
	mkdir -p $(VENDOR_DIR)
	cp node_modules/jquery/dist/jquery.min.js $(VENDOR_DIR)
	cp node_modules/jquery/dist/jquery.min.map $(VENDOR_DIR)
	cp node_modules/popper.js/dist/umd/popper.min.js $(VENDOR_DIR)
	cp node_modules/popper.js/dist/umd/popper.min.js.map $(VENDOR_DIR)
	cp node_modules/bootstrap/dist/js/bootstrap.min.js $(VENDOR_DIR)
	cp node_modules/bootstrap/dist/js/bootstrap.min.js.map $(VENDOR_DIR)
	cp -r node_modules/bootstrap/scss _sass/bootstrap_scss

build: install include-yarn-deps
	$(JEKYLL) build

build-dev: install include-yarn-deps
	$(JEKYLL) build --config _config.localhost.yml

serve: install include-yarn-deps
	JEKYLL_ENV=production $(JEKYLL) serve --config _config.yml

serve-dev: install include-yarn-deps
	JEKYLL_ENV=development $(JEKYLL) serve --config _config.localhost.yml

clean-deploy:
	rm -rf node_modules script vendor *.yml *.lock

clean:
	rm -fr _site/
	rm -fr $(VENDOR_DIR) #from yarn
	rm -fr $(ASSETS_DIR)/fonts #fontawesome dependency
	rm -fr .sass_cache
