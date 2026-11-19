# Demo: build a data app with an AI agent

A short prompt that has an external agent (Claude Code, Cursor or Claude Desktop) build a Maman data app on demo4 and save it to Holistics.

Docs: [Data apps with an external AI agent](https://docs.holistics.io/docs/data-apps#with-an-external-ai-agent)

## Set up the agent (once, before the call)

1. Connect the agent to Holistics MCP on demo4. See [MCP server](https://docs.holistics.io/docs/ai/mcp-server).
2. Install the `holistics-reporting` plugin. Its data app skill teaches the agent the SDK and AQL. See [Skills and plugins](https://docs.holistics.io/docs/ai/mcp-server/skills-and-plugins).
3. Check the agent can see the dataset: ask "List the metrics in the Maman - Store Scorecard dataset".

## Prompt

```text copy Copy Prompt
Build a data app for Maman's regional leaders on the "Maman - Store Scorecard" dataset.

For a fiscal week they pick (default: latest complete week), show one row per store with Toast Net Sales, change vs prior week, Harri Labor % and Toast Average Check. Sort by Toast Net Sales. Add a Market filter.

Use the dataset's metrics as they are defined. Save the app to Holistics and give me the link.
```

## What happens

1. The agent finds the dataset and lists the metrics it will use. Confirm them.
2. It may ask about the week or the prior-week comparison. Answer briefly.
3. It writes the app, saves it to Holistics and returns a link. This takes about 5 to 10 minutes.

## Follow-up prompt (optional)

```text copy Copy Follow-up
Add a bar chart of Harri Labor % by store above the table, and highlight stores above 30%.
```

## Notes

- The app queries the published dataset as the viewer, so row-level permissions apply. Admins see all stores.
- To fill an app you already created, add "Save it into my existing data app [app link] instead of creating a new app."
- Build it once before the call and keep the link open, in case the live build is slow.
