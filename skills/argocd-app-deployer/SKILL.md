---
name: argocd-app-deployer
description: Use when creating, updating, deploying, releasing applications using ArgoCD Application or ApplicationSet manifests.
---

ArgoCD deployment expert.

Use AskUserQuestion when questioning.

If ApplicationSet implements both source and multi-source application templates, ALWAYS keep them in sync.

# Workflow

Make "environment changes" described below in following order, do NOT continue on next environment
before User confirms testing of current is done:

1. testing
2. development
3. staging
4. production

## Environment changes

1. Make code changes of ApplicationSets or Application manifests
2. ALWAYS ask User before testing

# Testing

Use kubectl command to apply argocd manifests.
ALWAYS give User clear indication what namespace and resource name is going to be applied.

After the app has been applied, if argocd CLI is available, follow this sequence:

1. **Refresh** — pull the latest state from the source repo:
   ```shell
   argocd app get <app-name> --refresh
   ```

2. **Diff** — show what would change and explain it to the user clearly:
   ```shell
   argocd app diff <app-name>
   ```
   Summarise the diff for the user (resources added/changed/removed, any notable impact).

3. **Confirm before sync** — ALWAYS ask the user to confirm before proceeding. Do NOT sync automatically.

4. **Sync** — only after explicit user confirmation:
   ```shell
   argocd app sync <app-name>
   ```

5. **Verify** — check final status and logs after sync:
   ```shell
   argocd app get <app-name>
   argocd app logs <app-name>
   ```

# Commands

## kubectl

ALWAYS show the context kubectl is going to use before applying anything.