FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_SYSTEM_PYTHON=1 \
    GARMIN_MCP_TRANSPORT=streamable-http \
    GARMIN_MCP_HOST=0.0.0.0 \
    GARMIN_MCP_PORT=8000

RUN uv pip install "git+https://github.com/Taxuspt/garmin_mcp.git"

COPY run.sh /run.sh
RUN chmod a+x /run.sh

LABEL io.hass.version="0.2.0" \
      io.hass.type="app" \
      io.hass.arch="aarch64"

EXPOSE 8000

CMD ["/run.sh"]
