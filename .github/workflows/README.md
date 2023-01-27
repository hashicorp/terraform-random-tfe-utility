# terraform-random-tfe-utility

These are reusable Github Workflows and Actions that target TFE resources.

---

## Create Jira Issue

This workflow will create an issue within Jira when a GitHub issue is created in a repo.

### Secrets

- `JIRA_BASE_URL` - URL of Jira instance. Example: https://hashicorp.atlassian.net
- `JIRA_API_TOKEN` - Access Token for Authorization. Example: HXe8DGg1iJd2AopzyxkFB7F2
- `JIRA_USER_EMAIL` - email of the user for which Access Token was created. Example: human@example.com
