# meuCafeList

A speedrun attempt to clone [MAL](https://myanimelist.net/) lists into a github pages subdomain, using SpringBoot. IaC automation provided by OCI containers, compose, github actions and scaffolding with shellscript.

The second attempt is to make the app ~**blazingly**~ fast by having a slim container image build, featuring:
- alpine as OCI container distro;
- [amazon-corretto-22]() as JRE;
- symbol stripping with [jlink]();
- to avoid layer bloat, ~only one~ two are being used to download and remove build dependencies. Dockerfile inspired by the official [corretto](https://github.com/corretto/corretto-docker/) repo
- other bloat source is including the test framework inside the container. To avoid this, maven is used in the build process and elimined in the final result.

## Usage

1. clone repository with SSH and enter directory
```sh
git clone git@github.com:deomorxsy/meuCafeList.git
cd ./meuCafeList/
```

2. **make build** to build with:
```sh
mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App"
```
3. **make test** to test the app.

4. **make up/down** to respectively run or stop the app.


## Scaffolding

1. **make scaff** to run [setup.sh](./scripts/skel.sh) and generate the project skeleton directory structure:

## Deployment

This repository uses Github Actions for Continuous Integration. Similar to how to run manually, the [yaml script](./.github/workflows/ci.yml) calls Makefile, which calls compose.yml, which runs the containers based on the specific Dockerfile context. It consists in three containers:
- server: the SpringBoot application on a slim JRE with amazon-corretto and the Alpine distro.
- frontend: the Actix application frontend on a slim Rust environment. [This](./client/Dockerfile) multi-stage build was inspired by codefeetime's [article](https://www.codefeetime.com/post/docker-config-for-actix-web-diesel-and-postgres/).
- nginx as web server, reverse proxy, etc.

### compose

Compose concentrates in orchestrating multiple containers in a single host. To do this with k8s, you would need kind, k3s (does not use virtualization) or similar. It was made to be compatible with other OCI runtimes, such as Podman, which was one of the first to enable rootless containers, and can be setup with compose using the Podman Service's systemd unit file for unix sockets.

The orchestration tool docker-compose supports Podman Service through the DOCKER_HOST environment variable. This makes it possible to run containers with podman but with the benefit of rootless.

Source the script and run it to run compose with podman, or just put a ```make up```. XD

```sh
; source ./scripts/ccr.sh; checker
```

### k8s
> soon...

Kubernetes is a container orchestrator that have a YAML syntax similar to the CI deployment from this repo. To run this project on single host just like the Compose tool, you can use tools like kind in a full-virtualized environment or k3s which don't use full-virtualization.
