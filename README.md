# Mint for Mac

Mint for Mac connects Claude to Mint, the Mac storage app, on this Mac. Claude can see where the space went and what grew, then clean, optimize, organize folders, free memory, uninstall apps and undo, through the same engine and the same checks as the Mint app. Anything that deletes for good, quits an app or changes Mint's settings waits until the person confirms it in Mint's own window on the Mac.

The plugin starts Mint's own MCP server on this Mac. Every tool runs locally, inside Mint.

![Mint](./assets/icon.png)

## Requirements

- macOS 14 or later.
- Mint for Mac 1.2.0 or later, the edition from [mintstorage.app/download](https://mintstorage.app/download/). Open it once after installing. The Mac App Store and Setapp editions don't include the command-line tool this plugin starts. Earlier versions of Mint offer only a few of the tools below.
- Claude Code, or Cowork running on the Mac. Claude chat, on the web, in the desktop app and on phones, doesn't start local servers, so the plugin has no tools there.

Scans, reports and previews are free. Cleaning, optimizing and organizing count toward Mint's free 1 GB a week; Mint Unlimited removes that limit.

## Install

In Claude, open **Customize › Plugins › Discover** and add **Mint for Mac**. Or, in a shell:

```bash
claude plugin marketplace add dzg-studio/mint-claude-plugin
claude plugin install mint-for-mac@dzg-studio
```

Then start a new Claude Code session. `/mcp` lists the `mint` server and its tools.

## Tools

| Area | Tools | What Claude can do |
| --- | --- | --- |
| Overview | `mint_status`, `mint_why`, `mint_history`, `mint_recent`, `mint_activity`, `mint_capabilities`, `mint_access` | Disk use over time and what grew, past work, which operations this Mint offers, and how much of the free allowance is left |
| Disk | `mint_disk_scan`, `mint_disk_clean`, `mint_scan`, `mint_execute`, `mint_trash_scan`, `mint_trash_remove` | Scan the Mac the way the Disk page does, clean reviewed items, and review or empty selected Trash entries |
| Space back without deleting | `mint_storage_scan`, `mint_storage_optimize`, `mint_sharing_scan`, `mint_sharing_execute` | Share storage between identical copies and compress files in place; every file keeps its name and contents |
| AI tools | `mint_agents`, `mint_conversations_scan`, `mint_conversations_optimize`, `mint_conversations_remove_media`, `mint_conversations_delete`, `mint_archives_optimize` | What Codex, Claude Code, Cursor and other AI tools keep on this Mac, and how much their conversations and archives take |
| Conversation pictures | `mint_compression_scan`, `mint_compression_execute`, `mint_pictures_scan`, `mint_picture_file_scan`, `mint_picture_preview`, `mint_pictures_keep`, `mint_pictures_remove` | Find the pictures inside AI conversations, preview one, keep some and remove the rest while the text stays |
| Memory | `mint_memory_scan`, `mint_memory_release` | What uses memory, and quitting the apps chosen from Mint's list |
| Apps | `mint_apps_list`, `mint_uninstall_scan`, `mint_uninstall_execute` | Installed apps, and removing an app with the files it left behind |
| Organize | `mint_organize_folders`, `mint_organize_preview`, `mint_organize_run`, `mint_organize_add`, `mint_organize_remove`, `mint_organize_configure` | Preview and organize the folders Mint manages, and choose which folders Mint manages and how |
| Auto Care | `mint_autocare_status`, `mint_autocare_disk`, `mint_autocare_folder`, `mint_autocare_memory` | See and set what Mint takes care of on its own |
| Rules and protection | `mint_rules`, `mint_rule_scan`, `mint_rule_create`, `mint_rule_update`, `mint_rule_enable`, `mint_rule_disable`, `mint_rule_remove`, `mint_handling_list`, `mint_handling_set` | Cleanup rules and their dry runs, and which paths Mint protects or asks about |
| Undo and jobs | `mint_undo_list`, `mint_undo`, `mint_job_status`, `mint_job_cancel` | Put back what Mint changed, follow a long job and stop it |

## How Mint keeps it safe

- **A scan is not permission.** Every change starts from a scan or preview Mint just made. Claude picks items by the IDs Mint returned, a scan's selection works once and for 15 minutes, and a file path alone never authorizes anything.
- **Mint checks again before it cleans or moves anything** that each item is the same one, that nothing is using it, and that it is still allowed. Paths Mint protects never change.
- **What Claude can run when asked:** moving items from Mint's Safe to clean list to the Trash, sharing storage between identical copies and compressing files in place, organizing a folder Mint already manages, putting a Mint operation back, stopping a job, protecting a path and turning Auto Care off.
- **What waits for the person:** every other cleanup, anything permanent (emptying Trash entries, deleting conversations, removing pictures), changes to AI conversations, quitting apps, uninstalling, adding, removing or configuring a managed folder, organizing files marked Needs Review, changing cleanup rules, loosening a path's protection and turning Auto Care on. Mint opens its own window on the Mac with the exact items and what will happen to them. It expires after two minutes, and nothing Claude sends can confirm it.
- **Long operations run as jobs.** Claude can follow their progress and ask Mint to stop. Stopping ends a job early; it doesn't undo what was already done.
- **Undo.** Mint records each change in its journal and keeps 90 days of history. Claude can list what Mint can put back and put it back while the items still exist. Permanent removals can't be undone.
- **Mint reports what happened:** what changed, what was refused and why, and how much disk space came back as measured. Items moved to the Trash still take space until the Trash is emptied.

## What the plugin runs

- `scripts/mint-mcp.sh`, a short shell script. It finds Mint's `mint-cli` inside `/Applications/Mint.app` first, then `~/Applications/Mint.app`, `/opt/homebrew/bin` and `/usr/local/bin` (or the path set in `MINT_CLI_PATH`), and runs `mint-cli mcp`.
- `mint-cli mcp` reads Mint's records in `~/Library/Application Support/Mint`. For a scan or a change it asks the Mint app on this Mac to do the work in the background, after checking that the app carries DZG Studio's Developer ID signature (team DRV5ZMT5U8). A confirmation opens Mint's own window.
- Before a change, Mint may check its plan and the week's free allowance with DZG Studio's servers, as the app does. With usage sharing on, Mint also sends usage data, described below.
- The plugin itself downloads nothing, installs nothing and opens no network connection.

## Privacy Policy

- **Data collection.** The plugin collects nothing. Tool results go to Claude as part of the conversation. Depending on the request, they can include file and folder names and paths, sizes, storage reports, installed apps and running processes, cleanup suggestions, settings and records of changes Mint made, which can reveal details about projects and activity. When Claude is asked to preview a picture from a supported conversation, the picture itself is shared with Claude. DZG Studio does not receive tool results.
- **Usage data.** When usage sharing is on, Mint sends DZG Studio usage data, including which features are used from an AI assistant and whether tasks complete. It is linked to a random identifier for the installation, not to a name, email address or account, and never includes files, file names or file contents.
- **Usage and storage.** Usage data helps fix problems and improve Mint. Mint's activity log and undo history stay on the Mac, in `~/Library/Application Support/Mint`. Anthropic's privacy policy and the account's Claude settings govern how a conversation is processed and kept.
- **Third-party sharing.** DZG Studio shares information only with the service providers that help run Mint, such as Cloudflare for hosting. It does not sell personal information, show ads, or track anyone across other apps or websites.
- **Data retention.** App usage data is kept for up to 120 days.
- **Choice.** In the edition from the website, usage sharing is on by default and can be turned off at any time in Mint's settings, without losing any feature. Removing the plugin stops further tool access; it doesn't remove what is already in a conversation.
- **Contact.** [dev@dzgapp.com](mailto:dev@dzgapp.com) or [mintstorage.app/contact](https://mintstorage.app/contact/).

The full policy is at [mintstorage.app/privacy](https://mintstorage.app/privacy).

## License

The files in this plugin are MIT licensed. Mint itself is commercial software by DZG Studio LLC, under its own [terms](https://mintstorage.app/terms).
