# QA reviewer learnings

One line each: `service | what to check | why`. Global only: no client names
or client facts (those go to `clients/<client>/skills/`). Added when we
correct a review or a client flags something the reviewer passed. Newest
last.

| Service | Check | Why |
|---|---|---|
| all | Every number or claim in the work has a source the client can open | Made-up facts lose trust at once |
| design-system-pattern | Test each instance against its row's full Use cell and test, not only the form | Wrong "follows" verdicts hid thin evidence |
| design-system-pattern | Compare the doc's structure to the client's existing pattern pages | The client reads its own format first |
| ux-audit | Render the client page at 390 px and read every mixed Arabic/English line | Missing dir/lang reversed a rule's meaning |
| all | Measurements cite the page and the method, never our tool names | Tool names leaked into client copy |
| ux-writing | Re-derive "new" or "not shown today" claims from the component code, not from string greps | A self-check passed a false "new" claim |
| all | Spot-check a sample of cited claims yourself, not only that a source is cited | Claims citing a source can still be wrong |
