import random
import sys
import uuid

import anyio
import dagger


async def main():
    config = dagger.Config(log_output=sys.stdout)

    async with dagger.Connection(config) as client:
        base_image = "python:3.10.0-slim"

        # set build context
        src = client.host().directory(".")
        pc_cache = client.cache_volume("pc")

        # run pre-commit hooks
        # FIXME: pre-commit is not working because we don't mount .git inside the container
        # pre_commit = (
        #     await docker_image_dev.with_directory("/code", src)
        #     .with_workdir("/code")
        #     .with_mounted_cache("/cache", pc_cache)
        #     .with_env_variable("PRE_COMMIT_HOME", "/cache")
        #     .with_entrypoint(["/bin/bash"])
        #     .with_exec(["git", "remote", "-v"])
        #     .with_exec(["pre-commit", "run", "--all-files"])
        #     .stdout()
        # )
        # print(pre_commit)

        # build the prod docker image
        docker_image_prod = await src.docker_build(target="prod")

        # build the dev docker image
        docker_image_dev = await src.docker_build(target="dev")

        # lint
        print("Running linting")
        lint = (
            await docker_image_dev.with_directory("/code", src)
            .with_workdir("/code")
            .with_entrypoint(["/bin/sh", "-c"])
            .with_exec(["/bin/bash", "scripts/lint.sh"])
            .stdout()
        )
        print(lint)

        # format
        print("Running format")
        format = (
            await docker_image_dev.with_directory("/code", src)
            .with_workdir("/code")
            .with_entrypoint(["/bin/sh", "-c"])
            .with_exec(["/bin/bash", "scripts/format.sh"])
            .stdout()
        )
        print(format)

        # unit tests
        print("Running unit tests")
        unit = (
            await docker_image_dev.with_directory("/code", src)
            .with_workdir("/code")
            .with_entrypoint(["/bin/sh", "-c"])
            .with_exec(["/bin/bash", "scripts/unit-tests.sh"])
            .stdout()
        )
        print(unit)

        # coverage
        print("Running coverage")
        coverage = (
            await docker_image_dev.with_directory("/code", src)
            .with_workdir("/code")
            .with_entrypoint(["/bin/sh", "-c"])
            .with_exec(["/bin/bash", "scripts/coverage.sh"])
            .stdout()
        )
        print(coverage)

        # fonctional tests
        print("Running fonctional tests")
        # FIXME: this should work but it hangs on stopping the mongo process after initial setup
        # mongo = (
        #     client.container()
        #     .from_("bitnami/mongodb:4.4-debian-10")
        #     .with_env_variable("MONGODB_ROOT_PASSWORD", "root")
        #     .with_env_variable("MONGODB_USERNAME", "app")
        #     .with_env_variable("MONGODB_PASSWORD", "app")
        #     .with_env_variable("MONGODB_DATABASE", "test")
        #     .with_exposed_port(27017)
        #     .as_service()
        # )
        mongo = client.host().service(
            [
                dagger.PortForward(
                    backend=27017, frontend=27017, protocol=dagger.NetworkProtocol.TCP
                )
            ]
        )

        api = (
            docker_image_prod
            .with_env_variable("MONGO_URI", "mongodb://app:app@mongo:27017/test")
            .with_service_binding("mongo", mongo)
            .with_exposed_port(8000)
            .as_service()
        )

        newman = (
            await docker_image_dev
            .with_directory("/code", src)
            .with_workdir("/code")
            .with_service_binding("api", api)
            .with_entrypoint(["/bin/bash", "scripts/functional-tests.sh"])
            .stdout()
        )
        print(newman)

anyio.run(main)
