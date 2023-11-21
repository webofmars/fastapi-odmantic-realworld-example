all: build ci publish

build: docker-build
ci: lint format unit-tests coverage functional-tests
publish: docker-publish

WERF_RUN = werf run --docker-options="-i --rm --entrypoint=/bin/bash" dev

lint: docker-build
	${WERF_RUN} -- -c "bash scripts/lint.sh"

format: docker-build
	${WERF_RUN} -- -c "bash scripts/format.sh"

pre-commit: docker-build
	echo "TO BE IMPLEMENTED"

unit-tests: docker-build
	${WERF_RUN} -- -c "bash scripts/unit-tests.sh"

coverage: docker-build
	${WERF_RUN} -- -c "bash scripts/coverage.sh"

functional-tests:
	bash scripts/functional-tests.sh

ci-clean:
	rm -rf .pytest_cache
	rm -rf .mypy_cache

docker-build:
	werf build --repo webofmars/cicdparadox

docker-publish: docker-build
	docker push webofmars/cicdparadox:latest-prod
	docker push webofmars/cicdparadox:latest-dev
