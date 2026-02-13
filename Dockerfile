FROM alpine:3.23.3

ARG PYTHON_VERSION
ARG LOCUST_CLI_VERSION

#Ensure to load .profile file every time
ENV ENV="/root/.profile"

RUN apk add --no-cache aws-cli curl tar && \
wget -qO- https://astral.sh/uv/install.sh | sh && \
source ~/.profile && \
uv python install ${PYTHON_VERSION} && \
uv tool install locust==${LOCUST_CLI_VERSION}
