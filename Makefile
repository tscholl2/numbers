#configurable stuff
INSTALL_DIR = www

#programs
BROWSERIFY := node_modules/browserify/bin/cmd.js
EXORCIST := node_modules/exorcist/bin/exorcist.js
CJSX := node_modules/coffee-react/bin/cjsx
SASS := node_modules/node-sass/bin/node-sass
NPM_DEPS := $(BROWSERIFY) $(EXORCIST) $(CJSX) $(SASS)

default: build

#
#setup
#
npm-setinal := node_modules/.ns
$(npm-setinal): $(NPM_DEPS)
	touch $(npm-setinal)
$(NPM_DEPS):
	@command -v npm >/dev/null 2>&1 || { echo >&2 "I require npm but it's not installed.  Aborting."; exit 1; }
	npm install
setup: $(npm-setinal)

#
#javascript
#
CJSX_FILES := $(shell find src -wholename 'src/*.cjsx')
JS_FILES := $(subst .cjsx,.js,$(subst src/,build/,$(CJSX_FILES))) #$(addprefix build/,$(JS_LIBS))
$(subst .cjsx,.js,$(subst src/,build/,$(CJSX_FILES))): $(CJSX_FILES)
	./$(CJSX) -cbm -o build/ src/
BUNDLE_JS := lib/bundle.js
$(BUNDLE_JS): $(JS_FILES)
	@mkdir -p lib
	@command -v node >/dev/null 2>&1 || { echo >&2 "I require node but it's not installed.  Aborting."; exit 1; }
	node $(BROWSERIFY) build/main.js --debug | ./$(EXORCIST) $(BUNDLE_JS).map > $(BUNDLE_JS)

#
#css
#
SCSS_FILES := $(wildcard scss/*) node_modules/zurb-foundation-5/scss/foundation.scss node_modules/zurb-foundation-5/scss/normalize.scss
CSS_FILES := $(subst .scss,.css,$(addprefix build/,$(SCSS_FILES)))
BUILT_CSS := $(addprefix build/, $(notdir $(CSS_FILES)))
build/%.css: %.scss
	./$(SASS) $< --output build/
BUNDLE_CSS := lib/bundle.css
$(BUNDLE_CSS): $(BUILT_CSS)
	$(RM) -f $(BUNDLE_CSS)
	cat $(BUILT_CSS) >> $(BUNDLE_CSS)

#
# installing
#
IMG := $(wildcard img/*)
HTML := $(wildcard ./*.html)
FONTS := node_modules/font-awesome/fonts/fontawesome-webfont.ttf node_modules/font-awesome/fonts/fontawesome-webfont.woff node_modules/font-awesome/fonts/fontawesome-webfont.woff2 node_modules/font-awesome/fonts/FontAwesome.otf
PREINSTALL := $(BUNDLE_JS) $(BUNDLE_CSS) $(IMG) $(HTML) $(FONTS) # $(FONTAWESOME) $(FOUNDATION) $(JQUERY)
POSTINSTALL := $(addprefix $(INSTALL_DIR)/,$(PREINSTALL))
$(INSTALL_DIR)/%: %
	install -m 644 -D $< $@
install: $(POSTINSTALL)


build: $(BUNDLE_JS) $(BUNDLE_CSS)
update:
	npm install

.PHONY: update compile setup install default build
