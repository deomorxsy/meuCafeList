# meuCafeList

A speedrun attempt to clone [MAL](https://myanimelist.net/) lists into a github pages subdomain, using SpringBoot. IaC automation provided by OCI containers, compose, github actions and scaffolding with shellscript.

## Usage

1. clone repository with SSH and enter directory
```sh
git clone git@github.com:deomorxsy/meuCafeList.git
cd ./meuCafeList/
```

2. **make build** to build with:
```sh
mvn compile exec:java -Dexec.mainClass="com.meucafelist.app"
```
3. **make test** to test the app.

4. **make up/down** to respectively run or stop the app.


## Scaffolding

1. **make scaff** to run [setup.sh](./scripts/skel.sh) and generate the project skeleton directory structure:

