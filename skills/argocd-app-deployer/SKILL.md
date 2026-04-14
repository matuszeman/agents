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

# Commands

## kubectl

ALWAYS show the context kubectl is going to use before applying anything.