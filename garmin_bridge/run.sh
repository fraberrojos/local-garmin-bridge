#!/bin/sh
set -eu

echo "Garmin Bridge HTTP iniciando..."

# Read credentials from Home Assistant add-on options without printing them.
if [ -f /data/options.json ]; then
    export GARMIN_EMAIL="$(python3 -c 'import json; print(json.load(open("/data/options.json")).get("garmin_username", ""))')"
    export GARMIN_PASSWORD="$(python3 -c 'import json; print(json.load(open("/data/options.json")).get("garmin_password", ""))')"
fi

export GARMIN_MCP_TRANSPORT="streamable-http"
export GARMIN_MCP_HOST="0.0.0.0"
export GARMIN_MCP_PORT="8000"
export GARMINTOKENS="/data/.garminconnect"

mkdir -p "$GARMINTOKENS"

# Import a token file from /share only when it exists.
# Keep existing add-on tokens if no shared token file is available.
if [ -f /share/garmin_tokens.json ]; then
    if [ ! -f "$GARMINTOKENS/garmin_tokens.json" ]; then
        echo "Importando tokens Garmin desde /share..."
        cp /share/garmin_tokens.json "$GARMINTOKENS/garmin_tokens.json"
    else
        echo "Ya existen tokens Garmin en el directorio del complemento; se conservan."
    fi
else
    echo "No se encontró /share/garmin_tokens.json; se comprobarán los tokens del complemento."
fi

if [ ! -f "$GARMINTOKENS/garmin_tokens.json" ]; then
    echo "No hay tokens Garmin. Realizando autenticación inicial..."
    garmin-mcp-auth --token-path "$GARMINTOKENS"
fi

if [ ! -f "$GARMINTOKENS/garmin_tokens.json" ]; then
    echo "ERROR: no se generó el archivo de tokens Garmin. No se inicia el servidor."
    exit 1
fi

echo "Garmin MCP HTTP en puerto 8000..."
exec garmin-mcp
