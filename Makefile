all: build ci publish

build: docker-build
ci: lint format unit-tests coverage functional-tests
publish: docker-publish

lint:
	earthly +lint

format:
	earthly +format

# FIXME: since we don't mount .git folders in docker, we can't use pre-commit
# pre-commit:
# 	earthly +pre-commit

unit-tests:
	earthly +unit-tests

coverage:
	earthly +coverage

functional-tests:
	earthly --allow-privileged +functional-tests

ci-clean:
	earthly prune

docker-build: docker-build-prod docker-build-dev

docker-build-prod:
	earthly +prod

docker-build-dev:
	earthly +dev

docker-publish: docker-build
	earthly prod --push
	earthly dev --push
