# CI/CD paradox

we want to run the following stages

- [ STAGE 1 | STEP 1 ] : build the prod target
- [ STAGE 1 | STEP 2 ] : build the dev target
- [ STAGE 2 | STEP 1 ] : run pre-commit hooks
- [ STAGE 2 | STEP 2 ] : run linting
- [ STAGE 3 | STEP 2 ] : unit tests
- [ STAGE 4 | STEP 1 ] : docker-compose & functional tests
- [ STAGE 5 | STEP 1 ] : publish docker image
