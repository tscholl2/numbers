#configurable stuff
INSTALL_DIR = www

#npm stuff
BROWSERIFY := node_modules/browserify/bin/cmd.js
EXORCIST := node_modules/exorcist/bin/exorcist.js
CJSX := node_modules/coffee-react/bin/cjsx
SASS := node_modules/node-sass/bin/node-sass
NPM_DEPS := $(BROWSERIFY) $(EXORCIST) $(CJSX) $(SASS)


default: build

#
#setup
#

#setinal stuff
npm-setinal := node_modules/.ns

setup: $(npm-setinal)

$(npm-setinal): $(NPM_DEPS)
	touch $(npm-setinal)

$(NPM_DEPS):
	@command -v npm >/dev/null 2>&1 || { echo >&2 "I require npm but it's not installed.  Aborting."; exit 1; }
	npm install

#
#installing
#
BUNDLE_JS := lib/bundle.js
BUNDLE_CSS := lib/bundle.css
CJSX_FILES := $(shell find src -wholename 'src/*.cjsx')
JQUERY := node_modules/jquery/dist/jquery.js
FOUNDATION_JS := node_modules/zurb-foundation-5/js/foundation/foundation.js
FOUNDATION_SCSS := node_modules/zurb-foundation-5/scss/
#FOUNDATION_CSS := vendor/foundation/css/foundation.min.css vendor/foundation/css/normalize.css
#FOUNDATION_JS := vendor/foundation/js/foundation.min.js vendor/foundation/js/vendor/modernizr.js
FONTAWESOME := node_modules/font-awesome/css/font-awesome.css.map node_modules/font-awesome/css/font-awesome.min.css node_modules/font-awesome/fonts/fontawesome-webfont.ttf node_modules/font-awesome/fonts/fontawesome-webfont.woff node_modules/font-awesome/fonts/fontawesome-webfont.woff2
SASS := $(wildcard css/*)
IMG := $(wildcard img/*)
HTML := $(wildcard ./*.html)

PREINSTALL := $(BUNDLE_JS) $(BUNDLE_CSS) $(IMG) $(HTML) $(FONTAWESOME) $(FOUNDATION) $(JQUERY)
POSTINSTALL := $(addprefix $(INSTALL_DIR)/,$(PREINSTALL))

install: $(POSTINSTALL)

$(INSTALL_DIR)/%: %
	install -m 644 -D $< $@


#
#building
#
build: $(BUNDLE)

$(BUNDLE): $(CJSX_FILES) $(CSS) $(CJSX) $(BROWSERIFY) $(EXORCIST)
	@mkdir -p lib
	@command -v node >/dev/null 2>&1 || { echo >&2 "I require node but it's not installed.  Aborting."; exit 1; }
	./$(CJSX) -cbm -o build/ $(CJSX_FILES)
	./$(SASS) --source-map css/ -o css/main.css
	./$(SASS) $(FOUNDATION) -o css/main.css
	node $(BROWSERIFY) build/main.js --debug | ./$(EXORCIST) $(BUNDLE).map > $(BUNDLE)

#for production use this one
#node $(BROWSERIFY) -t coffeeify --extension=".coffee" src/main.coffee > lib/bundle.js


#
#update dependencies
#
update:
	npm install

.PHONY: update compile setup install default
