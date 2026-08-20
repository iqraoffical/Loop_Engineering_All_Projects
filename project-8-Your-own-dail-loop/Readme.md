# Project 8 — Own Daily Loop

## Overview

This project implements the Loop Engineering capstone: a recurring dependency-audit loop for the **current repository only**.

The loop combines all six required parts:

1. Heartbeat
2. Worktree
3. Skill
4. Maker-Checker
5. Connector
6. Spine

Budget guards are also included to limit resource usage.

## Project Structure

```text
project-8-Your-own-dail-loop/
│
├── main.py
├── heartbeat.py
├── worktree.py
├── skill.py
├── maker.py
├── checker.py
├── connector.py
├── config.py
├── requirements.txt
└── README.md
```

## Loop Workflow

```text
Heartbeat
    ↓
Spine / Main
    ↓
Worktree
    ↓
Skill
    ↓
Maker
    ↓
Checker
    ↓
PASS → Connector
    ↓
Ship / PR

FAIL → Stop and Report
```

## Chore

The recurring chore is a **dependency audit**.

The loop operates only on the current repository and does not access or modify other repositories.

## Components

### Heartbeat

Triggers the recurring loop.

### Worktree

Provides an isolated Git working environment for changes.

### Skill

Defines the instructions and steps for performing the dependency audit.

### Maker

Performs the dependency-audit work and prepares changes when required.

### Checker

Independently reviews the maker's changes and returns:

```text
PASS
```

or

```text
FAIL
```

Only a `PASS` is allowed to continue to the connector stage.

### Connector

Handles the Git/GitHub action required after a successful review.

### Spine

Coordinates the complete workflow from heartbeat through review and connector.

### Budget Guards

Limits resource usage such as attempts, runtime, model/API usage, and spending.

## Running the Project

Open Windows CMD and navigate to the project:

```cmd
cd /d "C:\Users\iqra\Documents\loop_Engineering\project-8-Your-own-dail-loop"
```

Run the loop:

```cmd
python main.py
```

## Safety Scope

This loop is intentionally limited to the **current repository**.

It must not:

* access other repositories
* modify unrelated projects
* add unrelated features
* bypass the checker
* continue shipping after a `FAIL`
* run without budget limits

## Capstone Completion

The implementation is considered complete only after the loop has been allowed to run unattended for one week.

The resulting changes must be reviewed by the project owner.

The goal is not simply to trust that the loop works, but to understand and review what it changes.

If an unattended run fails, the failure should be investigated using the Loop Engineering observability guidance before blaming the model.

## Concept 15

After the unattended period, answer honestly:

> Did my understanding of the project keep up with what the loop changed?

If the answer is no, the loop should be slowed down until the project owner's understanding can keep up with its changes.
