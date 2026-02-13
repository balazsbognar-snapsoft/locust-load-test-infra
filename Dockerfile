FROM alpine:3.23.3

ARG PYTHON_VERSION

ENV PATH="/root/.local/bin:$PATH"

COPY pyproject.toml /app/pyproject.toml

RUN apk add --no-cache aws-cli curl tar && \
    wget -qO- https://astral.sh/uv/install.sh | sh && \
    uv python install ${PYTHON_VERSION} && \
    uv venv /opt/venv --python ${PYTHON_VERSION} && \
    VIRTUAL_ENV=/opt/venv uv pip install --requirement /app/pyproject.toml && \
    rm -rf /app

ENV PATH="/opt/venv/bin:$PATH"
