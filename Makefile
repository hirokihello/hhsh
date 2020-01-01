.PHONY: run
run:
	bin/hhsh

.PHONY: fix-lint
fix-lint:
	bundle exec rubocop --auto-correct