# syntax=docker/dockerfile:1.2
#
# NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
# BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE
# OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM
# PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.

ARG BASE_IMAGE=jupyter/minimal-notebook:notebook-6.4.12
FROM ${BASE_IMAGE} AS base_image
ARG ROOT_USER=root
ARG BASE_USER=root
USER ${BASE_USER}
ARG BASE_DIR=.

LABEL license.warranty="NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT." \
      license.date="2022-06-26" \
      maintainer="Defense Innovation Unit (diu.mil)"

MAINTAINER "Dan DeCapria, Technical Advisor <ddecapria.ctr@diu.mil>"

SHELL ["/bin/bash", "-c"]


# Environment
FROM base_image AS diu_ammo_development
ARG SETUPTOOLS_USE_DISTUTILS=stdlib
ARG APT_CACHE_DIRECTORY=/var/cache/apt
ARG APT_LIBS_DIRECTORY=/var/lib/apt
ARG APT_TRUSTED_GPG_DIRECTORY=/etc/apt/trusted.gpg.d
ARG PROFILES_DIRECTORY=/etc/profile.d
ARG REQUIREMENTS_DIRECTORY=/var/lib/diu/ammo/requirements
ARG RESOURCES_DIRECTORY=/var/lib/diu/ammo/resources


# Set System Repositories and Applications
COPY ${BASE_DIR}/resources/requirements/requirements.apt ${REQUIREMENTS_DIRECTORY}/
USER ${ROOT_USER}
RUN /usr/bin/apt-get update \
    && /usr/bin/apt-get install --no-install-suggests --no-install-recommends --yes \
      $(/bin/cat ${REQUIREMENTS_DIRECTORY}/requirements.apt \
    | /bin/grep -vE "^\s*#" \
    | /usr/bin/tr -s "\r\n" " ")
USER ${BASE_USER}

# Conda Virtualenv and Dependencies
COPY ${BASE_DIR}/resources/requirements/requirements.upstream.conda ${REQUIREMENTS_DIRECTORY}/
RUN /opt/conda/bin/conda install --yes -n base --file ${REQUIREMENTS_DIRECTORY}/requirements.upstream.conda
RUN /opt/conda/bin/conda config --set channel_priority false \
    && /opt/conda/bin/conda config --append channels nvidia \
    && /opt/conda/bin/conda config --append channels pytorch \
    && /opt/conda/bin/conda config --append channels anaconda
RUN /opt/conda/bin/conda create --yes -n ammo310
# - Install Python Dependencies
COPY ${BASE_DIR}/resources/requirements/requirements.conda ${REQUIREMENTS_DIRECTORY}/
RUN /opt/conda/bin/conda install --yes -n ammo310 --file ${REQUIREMENTS_DIRECTORY}/requirements.conda
# - Install PyTorch +1.11 CUDA
SHELL ["conda", "run", "-n", "ammo310", "/bin/bash", "-c"]
COPY ${BASE_DIR}/resources/requirements/requirements.pytorch.pip ${REQUIREMENTS_DIRECTORY}/
RUN pip3 install --upgrade pip \
    && pip3 install --no-cache-dir -r ${REQUIREMENTS_DIRECTORY}/requirements.pytorch.pip --extra-index-url https://download.pytorch.org/whl/cu115
# - Configure the Kernel
RUN python3 -m ipykernel install --user --name=ammo310 --display-name "DIU (AMMO)"

# - Cleanup Image
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN /opt/conda/bin/conda clean --all -f --yes


FROM diu_ammo_development AS diu_ammo_production
# TODO: minimal production image...