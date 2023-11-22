all: build ci publish

build: docker-build
ci: docker-build lint format unit-tests coverage functional-tests ci-clean
publish: docker-publish

DOCKER_RUN = docker run --rm -i --entrypoint bash webofmars/cicdparadox:standard-develop

lint: docker-build-dev
	${DOCKER_RUN} scripts/lint.sh

format: docker-build-dev
	${DOCKER_RUN} scripts/format.sh

pre-commit: docker-build-dev
	${DOCKER_RUN} scripts/pre-commit.sh

unit-tests: docker-build-dev
	${DOCKER_RUN} scripts/unit-tests.sh

coverage: docker-build-dev
	${DOCKER_RUN} scripts/coverage.sh

functional-tests: docker-build-prod
	bash scripts/functional-tests.sh

ci-clean:
	rm -rf .pytest_cache
	rm -rf .mypy_cache

docker-build: docker-build-prod docker-build-dev

docker-build-prod:
	docker build -t webofmars/cicdparadox:standard-latest --target=prod .

docker-build-dev:
	docker build -t webofmars/cicdparadox:standard-develop --target=dev .

docker-publish: docker-build
	docker push webofmars/cicdparadox:standard-latest
