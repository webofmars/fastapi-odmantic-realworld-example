all: ci publish

ci: pre-commit lint unit-tests docker-build
publish: docker_publish

pre-commit:
	pre-commit run --all-files

lint:
	bash scripts/lint.sh

unit-tests:
	bash scripts/unit-tests.sh

docker-build: docker-build_prod docker-build_dev

docker-build_prod:
	docker build -t webofmars/cicdparadox:latest-prod --target=prod .

docker-build_dev:
	docker build -t webofmars/cicdparadox:latest-dev --target=dev .

docker_publish:
	docker push webofmars/cicdparadox:latest-prod
	docker push webofmars/cicdparadox:latest-dev
