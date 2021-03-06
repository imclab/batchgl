node_modules/.bin/uglifyjs:
	npm install

node_modules/.bin/coffee:
	npm install

node_modules/.bin/mocha:
	npm install

build/batchgl.js:
	mkdir -p build
	cat \
		lib/index.js \
		lib/extendable.js \
		lib/context.js \
		lib/treenode.js \
		lib/root.js \
		lib/step.js \
		lib/leaf.js \
		lib/vertices.js \
		lib/memory.js \
		lib/virtualmemory.js \
		lib/boundedvirtualmemory.js \
		> $@

build/batchgl.min.js: build/batchgl.js node_modules/.bin/uglifyjs
	./node_modules/.bin/uglifyjs \
		-m \
		-c warnings=false,unsafe=true \
		$< > $@

build/batchgl.min.js.gz: build/batchgl.min.js
	gzip -c $< > $@

.PHONY: test
test: node_modules/.bin/coffee node_modules/.bin/mocha
	mkdir -p test/build
	./node_modules/.bin/coffee -o test/build -c test/specs

.PHONY: clean
clean:
	rm -rf build
	mkdir build

.PHONY: build
build: build/batchgl.js build/batchgl.min.js build/batchgl.min.js.gz

.PHONY: rebuild
rebuild: clean build
