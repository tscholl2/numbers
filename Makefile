#configurable stuff
INSTALL_DIR = www

default: build

#
#commands
#
BROWSERIFY := node_modules/browserify/bin/cmd.js
EXORCIST := node_modules/exorcist/bin/exorcist.js
CJSX := node_modules/coffee-react/bin/cjsx
SASS := node_modules/node-sass/bin/node-sass

#
#setup
#
NPM_DEPS := $(BROWSERIFY) $(EXORCIST) $(CJSX) $(SASS)
npm-setinal := node_modules/.ns
$(npm-setinal): $(NPM_DEPS)
	@command -v npm >/dev/null 2>&1 || { echo >&2 "I require npm but it's not installed.  Aborting."; exit 1; }
	@command -v node >/dev/null 2>&1 || { echo >&2 "I require node but it's not installed.  Aborting."; exit 1; }
	touch $(npm-setinal)
$(NPM_DEPS):
	npm install
setup: $(npm-setinal)
	@mkdir -p build/
	@mkdir -p lib/
update: setup
	npm install

#
#javascript
#
CJSX_FILES := $(shell find src -wholename 'src/*.cjsx')
JS_FILES := $(subst .cjsx,.js,$(subst src/,build/,$(CJSX_FILES)))
build/%.js: src/%.cjsx
	./$(CJSX) --compile --map --bare --output $(@D) $<
	@ # ./$(CJSX) --compile --bare --output $(@D) $<
BUNDLE_JS := lib/bundle.js
$(BUNDLE_JS): $(JS_FILES)
	node $(BROWSERIFY) build/main.js --debug | ./$(EXORCIST) $(BUNDLE_JS).map > $(BUNDLE_JS)
	@ # node $(BROWSERIFY) build/main.js > $(BUNDLE_JS)

#
#css
#
SCSS_FILES := $(wildcard scss/*) foundation.scss normalize.scss
CSS_FILES := $(addprefix build/, $(notdir $(subst .scss,.css,$(SCSS_FILES))))
build/%.css: scss/%.scss
	# ./$(SASS) --output build/ $<
	./$(SASS) --source-map true --output build/ $<
build/foundation.css: node_modules/zurb-foundation-5/scss/foundation.scss
	# ./$(SASS) --output build/ $<
	./$(SASS) --source-map true --output build/ $<
build/normalize.css: node_modules/zurb-foundation-5/scss/normalize.scss
	# ./$(SASS) --output build/ $<
	./$(SASS) --source-map true --output build/ $<
BUNDLE_CSS := lib/bundle.css
$(BUNDLE_CSS): $(CSS_FILES)
	$(RM) $@
	cat $(CSS_FILES) >> $@

#
# building
#
build: $(BUNDLE_JS) $(BUNDLE_CSS) setup

#
# installing
#
IMG := $(wildcard img/*)
HTML := $(wildcard ./*.html)
FONTS := node_modules/font-awesome/fonts/fontawesome-webfont.ttf node_modules/font-awesome/fonts/fontawesome-webfont.woff node_modules/font-awesome/fonts/fontawesome-webfont.woff2 node_modules/font-awesome/fonts/FontAwesome.otf
PREINSTALL := $(BUNDLE_JS) $(BUNDLE_CSS) $(IMG) $(HTML) $(FONTS)
POSTINSTALL := $(addprefix $(INSTALL_DIR)/,$(PREINSTALL))
$(INSTALL_DIR)/%: %
	install -m 644 -D $< $@
install: $(POSTINSTALL) setup


#
#cleanup
#
clean:
	$(RM) -r build/*

.PHONY: update setup install default build clean
