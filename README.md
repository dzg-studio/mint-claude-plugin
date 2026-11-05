# Mint for Mac

Mint for Mac lets Claude see where a Mac's storage went: what takes the space, what grew lately and why, and what Mint would clean. For the few kinds of files Mint can prove safe on its own (app cache files, old logs and crash reports, temporary Xcode builds), Claude can ask Mint to move them to the Trash; Mint checks each file again and records the batch, so it can be undone in Mint. Everything else Claude points to in Mint, where it is reviewed and cleaned.

The plugin starts Mint's own MCP server on this Mac. Every tool runs locally, inside Mint.

![Mint](./assets/icon.png)

## Requirements

- macOS 14 or later.
- Mint for Mac, the edition from [mintstorage.app/download](https://mintstorage.app/download/). Open it once after installing. The Mac App Store and Setapp editions don't include the command-line tool this plugin starts.

Scans and every report are free. Moving items to the Trash counts toward Mint's free 1 GB a week; Mint Unlimited removes that limit.

## Install

In a shell:

```bash
claude plugin marketplace add dzg-studio/mint-claude-plugin
claude plugin install mint-for-mac@dzg-studio
```

Then start a new Claude Code session. `/mcp` lists the `mint` server with eight tools.

## Tools

| Tool | What it does | Changes files |
| --- | --- | --- |
| `mint_status` | Disk usage over time, recent activity and the folders Mint manages | No |
| `mint_why` | Which kinds of data grew fastest, or every operation that touched a given path, with its reason | No |
| `mint_scan` | A cleanup scan: concrete items, why each one can go, whether Claude may move it, and a plan ID valid for 15 minutes. Developer caches by default; `all: true` covers every category | No |
| `mint_recent` | Recent operations from Mint's journal, with reasons | No |
| `mint_activity` | Recent entries in Mint's activity log | No |
| `mint_agents` | What AI tools (Codex, Claude Code, Cursor and others) keep on this Mac, from Mint's last AI agents scan | No |
| `mint_rules` | Mint's cleanup rules: list them, show templates, or dry-run one | No |
| `mint_execute` | Moves items a `mint_scan` plan marks as eligible to the Trash | Yes, to the Trash only |

## How cleanup stays safe

- `mint_execute` accepts only a plan ID from a `mint_scan` in the last 15 minutes and item IDs picked from that plan. A plan works once, and a file path alone never authorizes anything.
- Right before touching each file, Mint checks again that it is the same file, that nothing is using it, and that it is still allowed.
- Items go to the Trash only. Permanent deletion isn't available to Claude; it stays in Mint or the Finder.
- Paths on Mint's Ignore List keep their level: Protected paths never appear in scans, and Needs Review items are confirmed in Mint, not by Claude.
- Each run is a journal batch with its own ID. Mint keeps 90 days of history and can undo a batch while its items are still in the Trash.

## What the plugin runs

- `scripts/mint-mcp.sh`, a short shell script. It finds Mint's `mint-cli` inside `/Applications/Mint.app` first, then `~/Applications/Mint.app`, `/opt/homebrew/bin` and `/usr/local/bin` (or the path set in `MINT_CLI_PATH`), and runs `mint-cli mcp`.
- `mint-cli mcp` reads Mint's records in `~/Library/Application Support/Mint`. For a scan or a cleanup it asks the Mint app on this Mac to do the work, after checking that the app carries DZG Studio's Developer ID signature (team DRV5ZMT5U8).
- The plugin downloads nothing, installs nothing and opens no network connection.

## Privacy Policy

- **Data collection.** The plugin collects nothing and sends nothing anywhere. Tool results (file paths, sizes and reasons) go to Claude as part of the conversation, like any tool's output. When usage sharing is on in Mint, Mint sends DZG Studio usage data that includes how many times AI tools call Mint's tools each day and how much space those calls gave back, as counts and totals by category. Usage data never includes files, file names or file contents.
- **Usage and storage.** Usage data helps fix problems and improve Mint. It is linked to a random identifier for the installation, not to a name, email address or account. Mint's activity log and undo history stay on the Mac, in `~/Library/Application Support/Mint`.
- **Third-party sharing.** DZG Studio shares information only with the service providers that help run Mint, such as Cloudflare for hosting. It does not sell personal information, show ads, or track anyone across other apps or websites.
- **Data retention.** App usage data is kept for up to 120 days.
- **Choice.** In the edition from the website, usage sharing is on by default and can be turned off at any time in Mint's settings, without losing any feature.
- **Contact.** [dev@dzgapp.com](mailto:dev@dzgapp.com) or [mintstorage.app/contact](https://mintstorage.app/contact/).

The full policy is at [mintstorage.app/privacy](https://mintstorage.app/privacy).

## License

The files in this plugin are MIT licensed. Mint itself is commercial software by DZG Studio LLC, under its own [terms](https://mintstorage.app/terms).
