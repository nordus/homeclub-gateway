docs: lib
	@node_modules/.bin/lidoc lib/*.coffee --output docs --github nordus/homeclub-gateway

docs.deploy: docs
	@cd docs && \
  git init . && \
  git add . && \
  git commit -m "Update documentation"; \
  git push "git@github.com:nordus/homeclub-gateway.git" master:gh-pages --force && \
  rm -rf .git