#!/bin/sh

echo "Garmin Bridge HTTP iniciando..."

if [ -f /data/options.json ]; then
    export GARMIN_EMAIL="$(python3 -c 'import json; print(json.load(open("/data/options.json")).get("garmin_username",""))')"
    export GARMIN_PASSWORD="$(python3 -c 'import json; print(json.load(open("/data/options.json")).get("garmin_password",""))')"
fi

export GARMIN_MCP_TRANSPORT="streamable-http"
export GARMIN_MCP_HOST="0.0.0.0"
export GARMIN_MCP_PORT="8000"
export GARMINTOKENS="/data/.garminconnect"

mkdir -p "$GARMINTOKENS"
echo "=== COMPROBANDO SHARE ==="; ls -l /share/garmin_tokens.json 2>&1; cp /share/garmin_tokens.json "$GARMINTOKENS/garmin_tokens.json"; echo "=== TOKEN COPIADO ==="; ls -l "$GARMINTOKENS/garmin_tokens.json" 2>&1

if [ ! -f "$GARMINTOKENS/garmin_tokens.json" ]; then
    echo "No hay tokens Garmin. Realizando autenticación inicial..."
    garmin-mcp-auth --token-path "$GARMINTOKENS"
fi

echo "Garmin MCP HTTP en puerto 8000..."

exec garmin-mcp
