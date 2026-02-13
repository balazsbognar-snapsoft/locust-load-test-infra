FROM alpine:3.23.3

ARG PYTHON_VERSION

#Ensure to load .profile file every time
ENV ENV="/root/.profile"

COPY pyproject.toml /app/pyproject.toml

RUN apk add --no-cache aws-cli curl tar && \
wget -qO- https://astral.sh/uv/install.sh | sh && \
source ~/.profile && \
uv python install ${PYTHON_VERSION} && \
uv tool install --from /app && \
rm -rf /app
