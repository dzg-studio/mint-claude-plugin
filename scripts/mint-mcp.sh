#!/bin/sh
# Starts Mint's MCP server, `mint-cli mcp`, from the Mint app installed on this Mac.
# The plugin holds no server of its own: every tool runs inside Mint, on this Mac.
# The app's own copy comes first, so the server always matches the installed app.

for cli in \
  "$MINT_CLI_PATH" \
  /Applications/Mint.app/Contents/Resources/mint-cli \
  "$HOME/Applications/Mint.app/Contents/Resources/mint-cli" \
  /opt/homebrew/bin/mint-cli \
  /usr/local/bin/mint-cli
do
  if [ -n "$cli" ] && [ -x "$cli" ]; then
    exec "$cli" mcp
  fi
done

echo "Mint's command-line tool was not found. Install Mint for Mac from https://mintstorage.app/download/ (the edition from the website; the App Store and Setapp editions have no command-line tool), open it once, then start Claude Code again. To use a copy elsewhere, set MINT_CLI_PATH to its mint-cli." >&2
exit 1
