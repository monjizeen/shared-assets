# Clients

One folder per client: `clients/<client>/STATUS.md`. Each client has its own
Claude project, run by the [`client-ceo`](../skills/client-ceo/SKILL.md) skill.
That project keeps its STATUS.md current through PRs, so the main CEO project
can see every client from here.

- New client: copy `_template/STATUS.md` to `<client>/STATUS.md`.
- Paste-in text for a new client project:
  [`skills/client-ceo/PROJECT-INSTRUCTIONS.md`](../skills/client-ceo/PROJECT-INSTRUCTIONS.md).
- Each project edits only its own folder. No secrets here.
