#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${HOME}/.nanobot/config.json"
MCP_PATH="/Users/ahk/github_codes/nanobot-enterprise/workspace/mcp/atlassian_confluence_mcp.py"

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

python - <<'PY'
import json
from pathlib import Path

config_path = Path.home() / ".nanobot" / "config.json"
raw = json.loads(config_path.read_text(encoding="utf-8"))

tools = raw.setdefault("tools", {})
mcp = tools.setdefault("mcpServers", {})
mcp["atlassian"] = {
    "command": "python",
    "args": ["/Users/ahk/github_codes/nanobot-enterprise/workspace/mcp/atlassian_confluence_mcp.py"],
}

config_path.write_text(json.dumps(raw, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"Updated: {config_path}")
print("Added/updated tools.mcpServers.atlassian")
PY
