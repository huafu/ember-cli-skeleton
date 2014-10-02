BIN = ./node_modules/.bin

build:
	@$(BIN)/ember build


test:
	@$(BIN)/ember test


serve:
	@$(BIN)/ember serve


#publish-doc: doc
#	BRANCH=`git rev-parse --abbrev-ref HEAD` && \
#		git checkout gh-pages && \
#		cp -R docs/* . && \
#		git add -A && \
#		git commit -m "Updating documentation" && \
#		git push origin gh-pages && \
#		git checkout "$$BRANCH"


define release
	VERSION=`node -pe "require('./package.json').version"` && \
	NEXT_VERSION=`node -pe "require('semver').inc(\"$$VERSION\", '$(1)')"` && \
	node -e "\
		var j = require('./package.json');\
		j.version = \"$$NEXT_VERSION\";\
		var s = JSON.stringify(j, null, 2);\
		require('fs').writeFileSync('./package.json', s);" && \
	git commit -m "release $$NEXT_VERSION" -- package.json && \
	git tag "$$NEXT_VERSION" -m "release $$NEXT_VERSION"
endef


release-patch: build test
	@$(call release,patch)


release-minor: build test
	@$(call release,minor)


release-major: build test
	@$(call release,major)


publish: build test
	git push --tags origin HEAD:master
