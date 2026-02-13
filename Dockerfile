FROM alpine:3.23.3

ARG PYTHON_VERSION

#Ensure to load .profile file every time
ENV ENV="/root/.profile"
ENV PATH="/root/.local/bin:$PATH"

COPY pyproject.toml /app/pyproject.toml

RUN apk add --no-cache aws-cli curl tar && \
    wget -qO- https://astral.sh/uv/install.sh | sh && \
    source ~/.profile && \
    uv python install ${PYTHON_VERSION} && \
    uv venv /opt/venv --python ${PYTHON_VERSION} && \
    VIRTUAL_ENV=/opt/venv uv pip install --requirement /app/pyproject.toml && \
    rm -rf /app

ENV PATH="/opt/venv/bin:$PATH"
