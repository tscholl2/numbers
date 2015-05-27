#configurable stuff
INSTALL_DIR = www

#npm stuff
BOWER := node_modules/bower/bin/bower
BROWSERIFY := node_modules/browserify/bin/cmd.js
EXORCIST := node_modules/exorcist/bin/exorcist.js
CJSX := node_modules/coffee-react/bin/cjsx
NPM_DEPS := $(BOWER) $(BROWSERIFY) $(COFFEE) $(EXORCIST) $(CJSX)


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
BUNDLE = lib/bundle.js
CJSX_FILES := $(shell find src -wholename 'src/*.cjsx')
FOUNDATION := vendor/foundation/css/foundation.min.css vendor/foundation/css/normalize.css
FONTAWESOME := node_modules/font-awesome/css/font-awesome.min.css node_modules/font-awesome/fonts/fontawesome-webfont.ttf node_modules/font-awesome/fonts/fontawesome-webfont.woff node_modules/font-awesome/fonts/fontawesome-webfont.woff2
CSS := $(wildcard css/*)
IMG := $(wildcard img/*)
HTML := $(wildcard ./*.html)
PREINSTALL := $(BUNDLE) $(CSS) $(IMG) $(HTML) $(FONTAWESOME) $(FOUNDATION)
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
	./$(CJSX) -cbm -o lib $(CJSX_FILES)
	node $(BROWSERIFY) lib/main.js -t browserify-css css/main.css --debug | ./$(EXORCIST) $(BUNDLE).map > $(BUNDLE)

#for production use this one
#node $(BROWSERIFY) -t coffeeify --extension=".coffee" src/main.coffee > lib/bundle.js


#
#update dependencies
#
update:
	npm install

.PHONY: update compile setup install default
