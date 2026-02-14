FROM alpine:3.23.3

ENV PATH="/root/.local/bin:$PATH"
ENV UV_PROJECT_ENVIRONMENT=/opt/venv

COPY pyproject.toml /app/pyproject.toml

COPY .python-version /app/.python-version

WORKDIR /app

RUN apk add --no-cache aws-cli curl tar && \
    wget -qO- https://astral.sh/uv/install.sh | sh && \
    uv sync --no-install-project --no-dev && \
    cd / && rm -rf /app

ENV PATH="/opt/venv/bin:$PATH"
