docs: lib
	@node_modules/.bin/groc lib/*.coffee

docs.deploy: docs
	@cd docs && \
  git init . && \
  git add . && \
  git commit -m "Update documentation"; \
  git push "git@github.com:nordus/homeclub-gateway.git" master:gh-pages --force && \
  rm -rf .git