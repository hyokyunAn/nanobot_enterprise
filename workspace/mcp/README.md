# Atlassian Confluence MCP (stdio)

이 폴더의 Confluence MCP는 **stdio 방식**으로 동작합니다.

- 서버 파일: `workspace/mcp/atlassian_confluence_mcp.py`
- 실행 스크립트: `workspace/mcp/run-atlassian-mcp.sh`
- 설정 자동 반영 스크립트: `workspace/mcp/install-confluence-mcp.sh`

## 1) 필수 환경변수

```bash
export CONFLUENCE_BASE_URL="https://your-domain.atlassian.net/wiki"
export CONFLUENCE_PAT="your_pat_here"
```

선택:

```bash
export CONFLUENCE_TIMEOUT_SECONDS="30"
export CONFLUENCE_VERIFY_SSL="true"
```

## 2) 로컬 단독 실행 확인

```bash
./workspace/mcp/run-atlassian-mcp.sh
```

`stdio` 서버라서 실행 후 대기 상태가 정상입니다.

## 3) nanobot에 MCP 서버 등록 (자동)

아래 명령을 실행하면 `~/.nanobot/config.json`의 `tools.mcpServers.atlassian`이 자동 등록/갱신됩니다.

```bash
./workspace/mcp/install-confluence-mcp.sh
```

등록되는 설정은 다음과 같습니다.

```json
{
  "tools": {
    "mcpServers": {
      "atlassian": {
        "command": "python",
        "args": ["/Users/ahk/github_codes/nanobot-enterprise/workspace/mcp/atlassian_confluence_mcp.py"]
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
