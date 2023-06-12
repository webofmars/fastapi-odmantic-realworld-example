all: build ci publish

build: docker-build
ci: dagger
publish: docker-publish

dagger:
	pip install dagger.io==0.9.3 && \
	python .dagger/ci.py

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
