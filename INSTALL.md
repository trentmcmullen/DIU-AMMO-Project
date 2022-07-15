<!-- 
  NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
  BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE
  OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM
  PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
-->

# Installation Procedures

Cloning the `CV-MLOps-Open-source-Data` repository from the `main` branch will persist the current state of the project to your development environment.
```bash
git clone <path_to_your_repository_tld>
```

The following procedures were written from the context of a Debian-based Host arbitration OS with an x86_64 architecture (ie, Ubuntu 20.04).

## Host Dependencies

The arbitration host OS must have the following system dependencies met:
```bash
sudo apt-get install -y bash ca-certificates curl gnupg lsb-release make
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

Additionally, requirements for the system `python3` dependencies to be met:
```bash
sudo pip3 install --upgrade pip setuptools pbr testresources docker docker-compose
```

For ease of use with the rest of the installation procedures, the following environmental variable is referenced on the host:
```bash
export DIU_AMMO_HOME=<path_to_your_repository_tld>  #  location of the cloned repository
```

Additionally, it is assumed that `docker` is on the host's `$PATH`, and at least available at `/bin/docker`.


## Data Populations

The following datasets will need to be populated to reproduce Training and Validation (T&V) with the provided [DIU_AMMO_Demo.ipynb](./resources/notebooks/DIU_AMMO_Demo.ipynb) exemplar.
These processes require sufficient access; convenience `populate.sh` POSIX scripts outline the downloads and persistence mechanisms per this repostiory.
Finally, exercising `make initialize` will extract the necessary datum as follows:

* Data population from Box: [data/populate.sh](./data/populate.sh). Generates:
  * [data/balanced_training_validation_set](./data/balanced_training_validation_set)
    * [data/balanced_training_validation_set.zip.sha256](./data/balanced_training_validation_set.zip.sha256)
  * [data/test_set](./data/test_set)
    * [data/test_set.zip.sha256](./data/test_set.zip.sha256)
  * [data/unbalanced_training_validation_set](./data/unbalanced_training_validation_set)
    * [data/unbalanced_training_validation_set.zip.sha256](./data/unbalanced_training_validation_set.zip.sha256)
* Model population from Box: [resources/models/populate.sh](./resources/models/populate.sh)
  * [resources/models/balanced_model.pth](./resources/models/balanced_model.pth)
    * [resources/models/balanced_model.pth.sha256](./resources/models/balanced_model.pth.sha256)
  * [resources/models/unbalanced_model.pth](./resources/models/unbalanced_model.pth)
    * [resources/models/unbalanced_model.pth.sha256](./resources/models/unbalanced_model.pth.sha256)


## Build Infrastructure Procedures

Creating the Docker images necessary for deployment can be performed simply by invoking `make`: 

```bash
make all
```

This default invocation provides a convenience workflow performing the following operations for production infrastructure:
* [initialization of repository checkout](#repository-initialization)  
* [building Docker images](#building-docker-images) 
* [cleaning up ephemeral artifacts](#cleaning-up-build-artifacts)
* [deploying containers](#deploy-containers)

### Repository Initialization

Additional curation, permission setting, etc. such that building and deployments execute as expected:
```bash
make initialize
```

## Building Docker Images

Building of various [Infrastructure Images](./infrastructure/README.md) can be performed via invoking the following:
```bash
make build
```

The `make build` process will generate the following similar `diu/ammo` image(s):
```bash
/bin/docker images --filter=reference="diu/ammo*" --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'
REPOSITORY   TAG           SIZE
diu/ammo     development   10.5GB
```

### Cleaning Up Build Artifacts

While ephemeral / intermediate files are to be ignored by `git` via rules, cleanup of those artifacts can be performed by:
```bash
make clean
```

## Deploying Containers

Created Docker images can be spawned as containers as provisioned in the provided `infrastructure/docker-compose.*.yml` configurations with `make` by simply running:
```bash
make deploy
```

A list of running containers can be found under the `diu/ammo` prefix with the following command as an example:
```bash
/bin/docker container ls --filter name="diu" --format 'table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}'
IMAGE                  STATUS                        PORTS                     NAMES
diu/ammo:development   Up About a minute (healthy)   0.0.0.0:65432->8888/tcp   diu_ammo_jupyter_1
```

## Accessing Server Tokens

Accessing the `Jupyter-Lab` access token can be performed by extracting the token from the `docker logs` of the `diu_ammo_jupyter_*` container.
The following procedure will deploy the container, wait for startup, extract the token to session variable `DIU_AMMO_ACCESS_TOKEN`, and start a `firefox` private window for access:

```bash
make deploy && sleep 1
DIU_AMMO_ACCESS_TOKEN=$(/bin/docker logs diu_ammo_jupyter_1 2>&1 | /bin/grep http://127.0.0.1:8888 | /bin/sed "s/^.*http:\/\/127.0.0.1:8888\/lab?token=//" | /bin/uniq)
/bin/firefox --private-window "http://localhost:65432/lab?token=${DIU_AMMO_ACCESS_TOKEN}"
```