VERSION 0.7
FROM earthly/dind:alpine-3.18-docker-23.0.6-r4
WORKDIR /app

deps:
    FROM DOCKERFILE --target "base" .

dev:
    FROM DOCKERFILE --target "dev" .

prod:
    FROM DOCKERFILE --target "prod" .

lint:
    FROM +dev
    RUN bash scripts/lint.sh

format:
    FROM +dev
    RUN bash scripts/format.sh

# FIXME: we don't mount .git files in containers, so this doesn't work
# pre-commit:
#     FROM +dev
#     RUN bash scripts/pre-commit.sh

unit-tests:
    FROM +dev
    RUN bash scripts/unit-tests.sh

coverage:
    FROM +dev
    RUN bash scripts/coverage.sh

functional-tests:
    FROM +dev
    COPY docker-compose.yaml .
    WITH DOCKER \
        --compose docker-compose.yaml \
        --load webofmars/cicdparadox:earthly-latest=+prod \
        --load webofmars/cicdparadox:earthly-develop=+dev \
        --service mongo --service api
        RUN bash scripts/functional-tests.sh
    END
