---
name: ste-writing
description: Use this skill when you write or change a Cursor rule (.mdc) or a skill (SKILL.md) in this workspace. It gives the ASD-STE100 norms and a self-check procedure.
---
# Write rules and skills in ASD-STE100

All Cursor rules and skills in this workspace must be in ASD-STE100 Simplified Technical English (STE).
English text uses fewer tokens than Russian text. In STE, each word has only one definition.

## Scope

1. Write these parts in STE: the text of rules and skills, the `description` in the frontmatter, and the headers of tables.
2. Keep paths, file names, and IDs (`GOAL-04`, `ADR-26061101`) as they are.
3. Keep the names of sections of Russian documents in Russian. An agent must find the section by its name.

## Norms

1. Use only approved STE words. Use each word only with its approved definition.
2. You can use technical names (`ADR`, `capability`, `OpenAPI`, `SSOT`, `CODEOWNER`, `merge request`).
3. You can use technical verbs (`merge`, `commit`, `clone`, `push`).
4. Write a maximum of 20 words in a procedural sentence.
5. Write a maximum of 25 words in a descriptive sentence.
6. Write a maximum of 6 sentences in a paragraph.
7. Write only one instruction in a sentence.
8. Use the imperative for instructions.
9. Use the active voice.
10. Use only the simple tenses: present, past, and future.
11. Do not use `-ing` forms, except in technical names.
12. Do not remove articles and short words. STE does not permit a telegraphic style.
13. Start a warning with a command. Write the reason in a separate short sentence.
14. For a glossary term, use the English slug of the term. Put a link to `glossary/terms/<slug>.md`.
15. In tables, you can use noun phrases. Do not use verbs that STE does not approve.

## Replacements

| Do not use | Use |
| ---------- | --- |
| `ensure` | `make sure` |
| `utilize`, `leverage` | `use` |
| `existing` | `current`, or `that is` with a verb |
| `following` | `these`, `this` |
| `in order to` | `to` |
| `please` | (remove the word) |
| `refer to` (meaning "look at") | `read`, `see` |
| `it is necessary to` | `you must` |
| `should be done` | the imperative of the verb |

## Procedure

1. Write the text.
2. Run the check script on each file that you wrote or changed:

   ```bash
   bash .cursor/skills/ste-writing/scripts/check-ste.sh <file> [<file> ...]
   ```

3. Correct each problem that the script shows.
4. If the script shows a technical name, add the name to the exception list in the script.
5. Read the text again and examine the words. The script does not examine the approved words of the STE dictionary.
