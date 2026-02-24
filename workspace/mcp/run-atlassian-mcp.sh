#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_PY="${SCRIPT_DIR}/atlassian_confluence_mcp.py"
ENV_FILE="${CONFLUENCE_ENV_FILE:-${SCRIPT_DIR}/confluence.env}"

# Load settings from env file (if present) so users don't need shell export.
if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "${ENV_FILE}"
  set +a
fi

if [[ -z "${CONFLUENCE_BASE_URL:-}" ]]; then
  echo "CONFLUENCE_BASE_URL is required." >&2
  echo "Set it in ${ENV_FILE} (recommended) or export it in shell." >&2
  exit 1
fi

if [[ -z "${CONFLUENCE_PAT:-}" ]]; then
  echo "CONFLUENCE_PAT is required" >&2
  echo "Set it in ${ENV_FILE} (recommended) or export it in shell." >&2
  exit 1
fi

exec python "${SERVER_PY}"
