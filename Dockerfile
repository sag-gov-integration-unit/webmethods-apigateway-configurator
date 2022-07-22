
# 1. start by creating a base image
######################################################################################################

ARG BASE_IMAGE

FROM $BASE_IMAGE as base

## USER and HOME
ARG SAG_HOME=/opt/softwareag
ARG SAG_USER=saguser
ARG SAG_USERID=1724
ARG SAG_USER_DESC="Software AG User"
ARG SAG_GROUP=saguser
ARG SAG_GROUPID=1724

ENV SAG_HOME ${SAG_HOME}
ENV SAG_USER ${SAG_USER}
ENV SAG_USERID ${SAG_USERID}
ENV SAG_USER_DESC ${SAG_USER_DESC}
ENV SAG_GROUP ${SAG_GROUP}
ENV SAG_GROUPID ${SAG_GROUPID}

# Create saguser a process owner and group
RUN groupadd -g ${SAG_GROUPID} ${SAG_GROUP} && \
    useradd -s /bin/bash -u ${SAG_USERID} -m -g ${SAG_GROUPID} -d ${SAG_HOME} -c "${SAG_USER_DESC}" ${SAG_USER} && \
    mkdir -p ${SAG_HOME}/.ansible/tmp && \
    chown -R ${SAG_USER}:${SAG_GROUP} ${SAG_HOME}/.ansible

# 2. start by creating an ansible base image
######################################################################################################

FROM base as base_ansible

ARG ANSIBLE_RELEASE=v2.11.1

## common vars
ENV ANSIBLE_PATH="/ansible"
ENV ANSIBLE_PLAYBOOKS_BASEPATH="${ANSIBLE_PATH}/playbooks"
ENV ANSIBLE_ROLES_BASEPATH="${ANSIBLE_PATH}/roles"
ENV ANSIBLE_VENV="${ANSIBLE_PATH}/venv"
ENV ANSIBLE_VERBOSITY="0"
ENV ANSIBLE_ROLES_PATH="~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles"

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
    && dnf -y install python39 \
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
ARG SAG_ANSIBLE_ROLES_COMMON_UTILS_RELEASE=1.0.0-3
ARG SAG_ANSIBLE_ROLES_COMMON_UTILS_FILENAME="${SAG_ANSIBLE_ROLES_COMMON_UTILS}-${SAG_ANSIBLE_ROLES_COMMON_UTILS_RELEASE}"

# sag apigateway roles
ARG SAG_ANSIBLE_ROLES_APIGATEWAY=sagdevops-ansible-apigateway
ARG SAG_ANSIBLE_ROLES_APIGATEWAY_RELEASE=1.0.0-4
ARG SAG_ANSIBLE_ROLES_APIGATEWAY_FILENAME="${SAG_ANSIBLE_ROLES_APIGATEWAY}-${SAG_ANSIBLE_ROLES_APIGATEWAY_RELEASE}"

# ansible-specific config env vars
# ":" separated paths in which Ansible will search for Roles.
ENV ANSIBLE_ROLES_PATH="${ANSIBLE_ROLES_PATH}:${ANSIBLE_ROLES_BASEPATH}/${SAG_ANSIBLE_ROLES_COMMON_UTILS_FILENAME}/roles:${ANSIBLE_ROLES_BASEPATH}/${SAG_ANSIBLE_ROLES_APIGATEWAY_FILENAME}/roles"

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
RUN ansible-galaxy collection install community.general


# 3. Finalize the image
# this creates an image of approx 2.20GiB (un-compressed)
######################################################################################################

FROM base_ansible_with_roles as final

LABEL org.opencontainers.image.authors="fabien.sanglier@softwareaggov.com" \
      org.opencontainers.image.vendor="Softwareag Government Solutions" \
      org.opencontainers.image.version="10.11"

ENV apigw_wait_connect=true

# add the ansible scripts
COPY ./ansible/ ./

# add entrypoint and related files
COPY scripts/entrypoint.sh ./
COPY scripts/common.sh ./

RUN chmod a+x ./entrypoint.sh

ENTRYPOINT ./entrypoint.sh