---
name: write-specification
description: Use this skill when the user asks to "сформировать спецификацию", "сформировать спеку", "сформируй спеку", or to write or change a microservice specification (Markdown, OpenAPI, Kafka) in documentation/specifications/.
---
# Write a microservice specification

The repository `documentation/specifications/` is the source of truth for contracts.
If this skill conflicts with `playbook/workflow/specifications-structure.md` or `documentation/specifications/messaging/README.md`, those documents win.

## Before you write

1. Read `playbook/workflow/specifications-structure.md`.
2. For Kafka, read `documentation/specifications/messaging/README.md`.
3. Read the rule `adr-topics` for platform REST, database, and Kafka decisions.
4. Do not invent endpoints or fields. If you lack data, ask questions before you write a draft.
5. List each file to create or change. Use paths from `documentation/specifications/`.
6. Write the full content of each new or changed file.

## Layout `microservices/<group>/<service>/`

| File | Purpose |
| ---- | ------- |
| `index.md` / `readme.md` | Overview and table of contents (reference-style links) |
| `openapi.yaml` | REST contract |
| `*-controller.md`, `rest.md`, `consumer.md` | Algorithms for endpoints or consumers |
| `async.md` | Kafka: topics, consume and produce |
| `jobs.md` | Scheduled jobs, if the service has them |

Message schemas live in `messaging/<topic-group>/<topic>/<type>.yaml` only.
In a service directory, use a `$ref` to them. Do not copy message schemas into the service folder.

## Markdown

1. Write spec prose in Russian. DTO names must match OpenAPI.
2. Put reference-style links at the end of the file after `<!-- LINKS -->`.
3. For each operation, use a `##` title, `` `METHOD /path` ``, a parameter table (mark required parameters with **📌**), and a numbered list titled **«Алгоритм работы:»**.
4. Do not duplicate platform REST rules in each file. Put links to ADR-26061701, ADR-26060701, ADR-26061501, and ADR-26061702. Use a relative path from the spec file to `ADR/`.

## Preamble for `*-controller.md` and `REST.md`

Use this block at the start of the file:

```markdown
HTTP contract: [openapi.yaml](./openapi.yaml).

Platform REST: [ADR-26061701](…/ADR/ADR-26061701-rest-crud-platform-conventions.md) (`crud-default`), [ADR-26060701](…), [ADR-26061501](…).

### Controller deltas

- (only differences: extra 400/404/409, domain rules, ADR-26061702 if needed)
```

Replace `…` with the correct relative path to `ADR/`.

If the service has more than one controller, put the ADR list in the service `index.md`.
In each `*-controller.md`, link to `index.md` and add a section **«Дельты»**.

## Algorithms

Write `REST.md`, `async.md`, `*-controller.md`, and `consumer.md` algorithms as follows:

1. Use Russian prose only (sentences or a numbered list).
2. Do not put code in algorithms: no SQL, no pseudocode, no syntax-highlighted blocks.
3. You can use inline field names, parameters, HTTP codes, API paths, and OpenAPI refs in the text.

## OpenAPI

1. Use the same OpenAPI version as other files in the repository (currently `3.2.0`).
2. Write descriptions in Russian.
3. In `servers`, include `http://<service>:8080/` and localhost.
4. Keep `openapi.yaml` in sync with `.md` files: same paths, response codes, schemas, and 409/404 examples.
5. Reuse `$ref` for shared components (`UncaughtException`, `traceId`, `spanId`).

## Kafka

Follow `documentation/specifications/messaging/README.md` for message shape and headers.

1. Topic name: `{first_folder_under_messaging}.{info.title}` (not the folder name alone).
2. Required headers: `key`, `schemaName`, `createdAt`, `schemaVersion`. Put them in `headers` only, not in the message body.
3. In `async.md`, list consumers and producers.
4. Filter on header `schemaName`. If the value does not match, exit without error and do not publish.

## Templates

1. Many REST controller groups: use `index.md` and `*-controller.md`.
2. Small service: use `readme.md`.
3. If the service directory has more than one `*.md` file, replace `readme.md` with a thin `index.md` that links to other files in the same directory (see `playbook/workflow/specifications-structure.md`).
