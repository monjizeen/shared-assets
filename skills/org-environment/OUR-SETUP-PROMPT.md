# Prompt for us: set up a new org

Paste this into a Monjizeen agent session (or follow it by hand) when a new
org starts. Replace {{ORG_NAME}}. Never paste client keys into the session.

---

Set up {{ORG_NAME}} in Monjizeen (app.monjizeen.com) using the org-environment skill in shared-assets.

1. Write one message to the org asking, all at once, for:
   - an account for us on their side, like monjizeen@company.com, with access to the tools our work needs (ticket tool, GitHub, design tools);
   - an API key for each of those tools, created from that account, with an expiry;
   - whether they have their own AI agent we should work with;
   - any data rules we must follow (always ask an employer of ours first).
   Draft it and show it to me before it is sent.
2. When the keys arrive, I add them myself on the org page → Environment (you never see them). Then press Refresh and tell me what shows under Action needed and what access each key was found to have.
3. If they use Jira: link our tickets to theirs (Client's ticket on each ticket page) and fill in the Status map for any status names that don't match ours.
4. If they have their own agent: on the Environment card press Connect agent, send them the key privately, and send them the setup prompt (Copy setup prompt). Check the card shows "last seen" within a day.
5. If they have no agent and no tools: nothing to add. We work on their tickets in Monjizeen with our own agents and skills, and send them finished results.
6. Write the skills we create for them in shared-assets/clients/<client>/skills/. Tell the org these stay ours if they leave.
7. Update shared-assets/clients/<client>/STATUS.md (internal only) with what was set up and what is still waiting on whom.
