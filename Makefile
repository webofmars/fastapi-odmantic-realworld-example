all: build ci publish

build: docker-build
ci: lint format unit-tests coverage functional-tests ci-clean
publish: docker-publish

lint:
	bash scripts/lint.sh

format:
	bash scripts/format.sh

pre-commit:
	bash scripts/pre-commit.sh

unit-tests:
	bash scripts/unit-tests.sh

coverage:
	bash scripts/coverage.sh

functional-tests:
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
