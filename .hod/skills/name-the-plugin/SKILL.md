---
name: name-the-plugin
description: "Ask the author for the identity of the plugin, then replace each placeholder of this template. Use when the author says what plugin the author wants to build, when the author asks to rename this template, and when a file of this project still holds `yourname.hello`, `Your Name` or `omarchy-hello`."
---

# Name the plugin

This repository is a template. It ships a working bar widget under a placeholder identity, and an author replaces that identity with the identity of the plugin that the author builds.

Replace the identity first, in one change, before you write one line of the plugin. An answer changes `manifest.json`, `LICENSE` and `README.md`, thus code that you write before the answer is code that you write two times.

## 1. Read the answers that a file gives

Run these commands and keep the output.

```bash
git config user.name
git remote get-url origin
```

`git config user.name` proposes the name of the author. The path of the `origin` remote proposes the GitHub username and the name of the repository. Propose a value from this output, and never state the value as a fact.

## 2. Ask the four questions

Ask the four questions in one message, in the message that answers the first description of the plugin. Ask them before you read one more file. Give your proposal with each question, and take the answer of the author over your proposal.

1. **The name of the author.** It goes in `author` of `manifest.json` and in the copyright line of `LICENSE`.
2. **The GitHub username of the author.** It gives the part of `id` in `manifest.json` that comes before the dot, and the URL in `README.md`. The shell refuses `omarchy.*`, thus the username may not be `omarchy`.
3. **The name of the plugin.** It gives `name` and `barWidget.displayName` in `manifest.json`, the part of `id` that comes after the dot, and the title of `README.md`.
4. **The kind of the plugin.** One of `bar-widget`, `panel`, `overlay`, `menu`, `service` and `bar`. It gives `kinds` in `manifest.json` and the key in `entryPoints` that the shell reads.

Wait for the answers. Ask no fifth question, and write no file until each answer arrives.

## 3. Replace each placeholder

Run this command to name each file and each line that still holds a placeholder.

```bash
grep -rn "yourname\|Your Name\|omarchy-hello" --exclude-dir=.git .
```

Replace each line that the command reports. Write the year of today in the copyright line of `LICENSE`. Rename `BarWidget.qml` and `tests/tst_BarWidget.qml` when the kind is not `bar-widget`, and name the new file in `entryPoints` of `manifest.json`.

Write the intention of the plugin in `.hod/PROJECT.md`, because that file describes the template until the author replaces it.

Run the command one more time. It must report no line.

## 4. Run the tests

Run `bin/test`. It refuses a manifest that the Omarchy shell would refuse, thus it proves that the new identity is one that `omarchy plugin add` accepts.
