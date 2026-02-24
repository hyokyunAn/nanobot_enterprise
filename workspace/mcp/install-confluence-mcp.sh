#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="${HOME}/.nanobot/config.json"
MCP_PATH="${SCRIPT_DIR}/atlassian_confluence_mcp.py"
ENV_FILE="${CONFLUENCE_ENV_FILE:-${SCRIPT_DIR}/confluence.env}"

# Load settings from env file first (recommended, no shell export needed).
if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "${ENV_FILE}"
  set +a
fi

mkdir -p "$(dirname "$CONFIG_PATH")"

if [[ ! -f "$CONFIG_PATH" ]]; then
  cat > "$CONFIG_PATH" <<'JSON'
{
  "tools": {
    "mcpServers": {}
  }
}
JSON
fi

MCP_PATH="${MCP_PATH}" python - <<'PY'
import json
import os
from pathlib import Path

config_path = Path.home() / ".nanobot" / "config.json"
raw = json.loads(config_path.read_text(encoding="utf-8"))

tools = raw.setdefault("tools", {})
mcp = tools.setdefault("mcpServers", {})
entry = {
    "command": "python",
    "args": [os.environ["MCP_PATH"]],
}

env_keys = [
    "CONFLUENCE_BASE_URL",
    "CONFLUENCE_PAT",
    "CONFLUENCE_TIMEOUT_SECONDS",
    "CONFLUENCE_VERIFY_SSL",
    "CONFLUENCE_CA_BUNDLE",
    "CONFLUENCE_AUTH_MODE",
    "CONFLUENCE_USERNAME",
]
env = {k: os.environ[k] for k in env_keys if os.environ.get(k)}
existing_env = (mcp.get("atlassian", {}) or {}).get("env", {})

if env:
    if not env.get("CONFLUENCE_BASE_URL") or not env.get("CONFLUENCE_PAT"):
        raise SystemExit(
            "CONFLUENCE_BASE_URL and CONFLUENCE_PAT are required "
            "(set in confluence.env or shell env)."
        )
    entry["env"] = env
elif existing_env:
    # Preserve previously stored credentials if no new values are supplied.
    entry["env"] = existing_env
else:
    raise SystemExit(
        "No Confluence credentials found. "
        "Set workspace/mcp/confluence.env (recommended) or configure "
        "~/.nanobot/config.json tools.mcpServers.atlassian.env first."
    )

mcp["atlassian"] = entry

config_path.write_text(json.dumps(raw, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"Updated: {config_path}")
print("Added/updated tools.mcpServers.atlassian")
PY
