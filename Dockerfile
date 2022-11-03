
# 1. start by creating a base image
######################################################################################################

ARG BASE_IMAGE=redhat/ubi8-minimal

FROM $BASE_IMAGE as base

# 2. start by creating an ansible base image
######################################################################################################

FROM base as base_ansible

ARG ANSIBLE_RELEASE=v2.12.7

## common vars
ENV ANSIBLE_PATH="/ansible"
ENV ANSIBLE_PLAYBOOKS_BASEPATH="${ANSIBLE_PATH}/playbooks"
ENV ANSIBLE_ROLES_BASEPATH="${ANSIBLE_PATH}/roles"
ENV ANSIBLE_VENV="${ANSIBLE_PATH}/venv"
ENV ANSIBLE_VERBOSITY="0"
ENV ANSIBLE_DEBUG="false" 
ENV ANSIBLE_ROLES_PATH="~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles"
ENV ANSIBLE_PYTHON_INTERPRETER="${ANSIBLE_VENV}/bin/python3.9"

## ansible-specific config env vars

### Privilege escalation method to use when become is enabled.
ENV ANSIBLE_BECOME_METHOD="su"

### Set this to “False” if you want to avoid host key checking by the underlying tools Ansible uses to connect to the host
ENV ANSIBLE_HOST_KEY_CHECKING="False"

### Set the main callback used to display Ansible output,
# ENV ANSIBLE_STDOUT_CALLBACK="debug"
# ENV ANSIBLE_STDOUT_CALLBACK="yaml"

# Install Ansible
RUN set -x \
    && microdnf -y install python39 \
    && python3 --version \
    && python3 -m venv ${ANSIBLE_VENV} \
    && source ${ANSIBLE_VENV}/bin/activate \
    && pip3 install --upgrade setuptools pip \
    && python3 -m pip --version \
    && pip3 install https://github.com/ansible/ansible/archive/refs/tags/${ANSIBLE_RELEASE}.tar.gz \
    && ansible --version

# set path to virtual env
ENV PATH=${ANSIBLE_VENV}/bin:$PATH

## setup ansible
RUN set -x \
    && echo "==> Adding hosts for convenience..."  \
    && mkdir -p /etc/ansible \
    && echo "[local]" > /etc/ansible/hosts \
    && echo "localhost ansible_connection=local" >> /etc/ansible/hosts \
    && echo "==> Creating few needed ansible working directories"  \
    && mkdir -p ${ANSIBLE_PLAYBOOKS_BASEPATH} ${ANSIBLE_ROLES_BASEPATH} \
    && echo "==> Finally, Testing that ansible is working..." \
    && ansible localhost -m ping

WORKDIR ${ANSIBLE_PLAYBOOKS_BASEPATH}

# 2. Add the needed ansible roles
######################################################################################################

FROM base_ansible as base_ansible_with_roles

# sag ansible roles base url
ARG SAG_ANSIBLE_ROLES_URL=https://github.com/SoftwareAG

# sag common-utils package
ARG SAG_ANSIBLE_ROLES_COMMON_UTILS=sagdevops-ansible-common
ARG SAG_ANSIBLE_ROLES_COMMON_UTILS_RELEASE=1.0.0-6
ARG SAG_ANSIBLE_ROLES_COMMON_UTILS_FILENAME="${SAG_ANSIBLE_ROLES_COMMON_UTILS}-${SAG_ANSIBLE_ROLES_COMMON_UTILS_RELEASE}"

# sag apigateway roles
ARG SAG_ANSIBLE_ROLES_APIGATEWAY=sagdevops-ansible-apigateway
ARG SAG_ANSIBLE_ROLES_APIGATEWAY_RELEASE=1.0.4-10.11
ARG SAG_ANSIBLE_ROLES_APIGATEWAY_FILENAME="${SAG_ANSIBLE_ROLES_APIGATEWAY}-${SAG_ANSIBLE_ROLES_APIGATEWAY_RELEASE}"

# ansible-specific config env vars
# ":" separated paths in which Ansible will search for Roles.
ENV ANSIBLE_ROLES_PATH="${ANSIBLE_ROLES_PATH}:${ANSIBLE_ROLES_BASEPATH}/${SAG_ANSIBLE_ROLES_COMMON_UTILS_FILENAME}/roles:${ANSIBLE_ROLES_BASEPATH}/${SAG_ANSIBLE_ROLES_APIGATEWAY_FILENAME}/roles"

# Install tools needed to extract
RUN microdnf -y install tar gzip

# add the roles
## Role 1: SAG_ANSIBLE_ROLES_COMMON_UTILS
RUN set -x \
    && echo "==> Download a specific TAG release of ${SAG_ANSIBLE_ROLES_COMMON_UTILS}" \
    && curl -L "${SAG_ANSIBLE_ROLES_URL}/${SAG_ANSIBLE_ROLES_COMMON_UTILS}/archive/refs/tags/${SAG_ANSIBLE_ROLES_COMMON_UTILS_RELEASE}.tar.gz" -o "/tmp/${SAG_ANSIBLE_ROLES_COMMON_UTILS_FILENAME}.tar.gz"  \
    && tar xvf /tmp/${SAG_ANSIBLE_ROLES_COMMON_UTILS_FILENAME}.tar.gz -C ${ANSIBLE_ROLES_BASEPATH}

## Role 2: SAG_ANSIBLE_ROLES_APIGATEWAY
RUN set -x \
    && echo "==> Download a specific TAG release of ${SAG_ANSIBLE_ROLES_APIGATEWAY}" \
    && curl -L "${SAG_ANSIBLE_ROLES_URL}/${SAG_ANSIBLE_ROLES_APIGATEWAY}/archive/refs/tags/${SAG_ANSIBLE_ROLES_APIGATEWAY_RELEASE}.tar.gz" -o "/tmp/${SAG_ANSIBLE_ROLES_APIGATEWAY_FILENAME}.tar.gz"  \
    && tar xvf /tmp/${SAG_ANSIBLE_ROLES_APIGATEWAY_FILENAME}.tar.gz -C ${ANSIBLE_ROLES_BASEPATH}

# install ansible community playbooks
# note: used by import archive - community.general.archive
RUN ansible-galaxy collection install community.general

# 3. Finalize the image
######################################################################################################

FROM base_ansible_with_roles as final

LABEL org.opencontainers.image.authors="fabien.sanglier@softwareaggov.com" \
      org.opencontainers.image.vendor="Softwareag Government Solutions" \
      org.opencontainers.image.title="webMethods API Gateway Configurator" \
      org.opencontainers.image.description="A container that can easily configure various functions of SoftwareAG webmethods-apigateway from environment variable values passed in" \
      org.opencontainers.image.version="10.11" \
      org.opencontainers.image.source="https://github.com/softwareag-government-solutions/webmethods-apigateway-configurator"

ENV wait_connect=true

# add the ansible scripts
COPY ./ansible/ ./

# add entrypoint and related files
COPY scripts/entrypoint.sh ./
COPY scripts/common.sh ./

RUN chmod a+x ./entrypoint.sh

ENTRYPOINT ./entrypoint.sh