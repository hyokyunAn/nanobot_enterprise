# Atlassian Confluence MCP (stdio, Cloud + Data Center)

이 폴더의 Confluence MCP는 **stdio 방식**으로 동작합니다.

- 서버 파일: `workspace/mcp/atlassian_confluence_mcp.py`
- 실행 스크립트: `workspace/mcp/run-atlassian-mcp.sh`
- 설정 자동 반영 스크립트: `workspace/mcp/install-confluence-mcp.sh`
- 환경파일 예시: `workspace/mcp/confluence.env.example`

## 1) 환경값 관리 (권장: env 파일)

아래처럼 파일을 만들어 관리하면 `export`가 필요 없습니다.

```bash
cp workspace/mcp/confluence.env.example workspace/mcp/confluence.env
# 이후 workspace/mcp/confluence.env 파일 값 수정
```

`workspace/mcp/confluence.env` 예시:

```bash
CONFLUENCE_BASE_URL="https://confluence.company.com/confluence"
CONFLUENCE_PAT="your_pat_here"
CONFLUENCE_AUTH_MODE="bearer"      # bearer | basic
# CONFLUENCE_USERNAME="your_id"     # basic일 때만 필요
CONFLUENCE_TIMEOUT_SECONDS="30"
CONFLUENCE_VERIFY_SSL="true"
# CONFLUENCE_CA_BUNDLE="/path/to/internal-ca.pem"
```

`confluence.env`는 `.gitignore`에 포함되어 커밋되지 않습니다.

## 2) 로컬 단독 실행 확인

```bash
./workspace/mcp/run-atlassian-mcp.sh
```

`stdio` 서버라서 실행 후 대기 상태가 정상입니다.
기본적으로 `workspace/mcp/confluence.env`를 자동 로드합니다.

## 3) nanobot에 MCP 서버 등록 (자동)

아래 명령을 실행하면 `~/.nanobot/config.json`의 `tools.mcpServers.atlassian`이 자동 등록/갱신됩니다.

```bash
./workspace/mcp/install-confluence-mcp.sh
```

이 스크립트도 `workspace/mcp/confluence.env`를 자동 로드하고,
`~/.nanobot/config.json`의 `tools.mcpServers.atlassian`에 `env`를 함께 저장합니다.

```json
{
  "tools": {
    "mcpServers": {
      "atlassian": {
        "command": "python",
        "args": ["/Users/ahk/github_codes/nanobot-enterprise/workspace/mcp/atlassian_confluence_mcp.py"],
        "env": {
          "CONFLUENCE_BASE_URL": "https://confluence.company.com/confluence",
          "CONFLUENCE_PAT": "...",
          "CONFLUENCE_AUTH_MODE": "bearer"
        }
      }
    }
  }
}
```

## 4) 연결 확인

```bash
nanobot agent --logs -m "mcp_atlassian_health 실행해줘"
```

로그에 `MCP server 'atlassian': connected`가 보이면 정상 연결입니다.
