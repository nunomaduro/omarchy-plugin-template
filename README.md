# Omarchy plugin template

A bar widget for the [Omarchy](https://omarchy.org) shell, and the checks that keep it loadable.

The widget draws a label, shows a tooltip on hover, and runs a command when you click it. Every value comes from `shell.json`, so the plugin is a working example of the whole contract the shell offers a third-party widget.

```bash
omarchy plugin add https://github.com/yourname/omarchy-hello.git --enable
```

## What you get

`bin/test` is one command and eleven checks. Nothing in it is advisory.

| Check | Tool | What it refuses |
| --- | --- | --- |
| Manifest | `omarchy-plugin-validate` | Anything the shell would reject: a wrong `schemaVersion`, the reserved `omarchy.*` namespace, an entry point that escapes the folder or does not exist, a kind without its entry point, a symlink |
| Manifest shape | `jq` | A `version` that is not semantic, and a `manifest.json` that is not formatted |
| Settings drift | `jq` | A setting declared in `manifest.json` that no QML reads, and a setting read by QML that `manifest.json` never declares |
| QML analysis | `qmllint` | Every check in `.qmllint.ini`, all raised from warning to error |
| QML format | `qmlformat` | Any byte `qmlformat` would rewrite |
| Bash analysis | `shellcheck` | `--enable=all --severity=style`, the strictest setting it has |
| Bash format | `shfmt` | Any byte `shfmt` would rewrite |
| Workflows | `actionlint`, `yamllint --strict` | A broken workflow expression, a bad YAML |
| Markdown | `markdownlint-cli2` | A malformed document |
| Whitespace, spelling, secrets | `editorconfig-checker`, `typos`, `gitleaks` | A file that breaks `.editorconfig`, a typo, a committed credential |
| Behaviour | `qmltestrunner` | A failing Qt Quick test, run offscreen |

The settings-drift check is the one that knows about Omarchy. A plugin whose manifest declares `format` while its QML reads `timeFormat` installs, enables, and shows a settings field that changes nothing. The check reads `barWidget.defaults` and `barWidget.schema` from the manifest, reads every `setting("<key>", ...)` call from the QML outside `tests/`, and fails on the difference.

## Run the checks

```bash
bin/test
```

Write the format back with `bin/format`, which runs `qmlformat`, `shfmt`, `jq` and `markdownlint --fix`.

Install the tools:

```bash
omarchy pkg add qt6-declarative jq shfmt actionlint yamllint editorconfig-checker typos gitleaks markdownlint-cli2
```

Arch ships no `shellcheck` for aarch64. On that architecture, take the binary from [the shellcheck releases](https://github.com/koalaman/shellcheck/releases) and put it on PATH. CI runs on x86_64 and installs it from pacman.

## Make it yours

Tell your coding agent what you want to build. The `name-the-plugin` skill in `.hod/skills/` answers that first message with four questions, and fills the template in from your answers.

By hand, it is five steps:

1. Change `id` in `manifest.json` from `yourname.hello` to `<you>.<plugin>`. The `omarchy.*` namespace is reserved, and the shell rejects a plugin that claims it.
2. Change `name`, `author`, `description`, and the `barWidget` block to describe your widget.
3. Rewrite `BarWidget.qml` and `tests/tst_BarWidget.qml`.
4. Put your name and the year in `LICENSE`.
5. Run `bin/test`.

`grep -rn "yourname\|Your Name\|omarchy-hello" --exclude-dir=.git .` reports every line that is still the template's.

The repository root is the plugin directory. `omarchy plugin add` clones it straight into `~/.config/omarchy/plugins/<id>/`, so `manifest.json` stays at the top.

## Develop against a running shell

Clone the repository into your plugin directory and the shell picks up every save:

```bash
git clone https://github.com/yourname/omarchy-hello.git ~/.config/omarchy/plugins/yourname.hello
omarchy plugin enable yourname.hello
```

Saving a file under `~/.config/omarchy/plugins/` reloads the plugin code. Force a reload with `omarchy-shell shell rescanPlugins`.

## What the shell gives your widget

The bar sets three properties on your root item after it loads:

| Property | What it holds |
| --- | --- |
| `bar` | The bar facade: `foreground`, `barForeground`, `background`, `urgent`, `fontFamily`, `position`, `vertical`, `barSize`, `transparent`, and the methods `run`, `showTooltip`, `hideTooltip`, `requestPopout`, `releasePopout` |
| `moduleName` | The id of this instance, as it appears in `shell.json` |
| `settings` | The fields of this instance's entry in `shell.json`, and nothing else |

A widget reads `settings` and falls back to its own default, because a user who never opened the settings panel has an entry with only an `id` in it.

Your plugin runs unsandboxed inside the long-lived `omarchy-shell` process. So does everyone else's. Say so in your own README.

## Layout

| Path | What it holds |
| --- | --- |
| `manifest.json` | The plugin declaration the shell reads |
| `BarWidget.qml` | The entry point named by `entryPoints.barWidget` |
| `bin/` | `test` runs every check, `format` writes the QML format back |
| `tests/` | Qt Quick tests and the stub bar they drive the widget with |
| `.qmllint.ini` | The lint levels, all raised to error |
| `.qmlformat.ini` | The format, pinned so every machine agrees |
| `.editorconfig` | The whitespace, enforced by `editorconfig-checker` |
| `.yamllint.yaml`, `.markdownlint-cli2.jsonc`, `.ecrc`, `_typos.toml`, `.gitleaks.toml` | The settings of the remaining checks |
| `.github/workflows/ci.yml` | The gate on GitHub, with the action pinned to a commit |

## Other kinds of plugin

A manifest declares one or more `kinds`, and each kind needs its own entry point:

| Kind | Entry point | What it is |
| --- | --- | --- |
| `bar-widget` | `entryPoints.barWidget` | A component the bar drops into a section |
| `panel` | `entryPoints.panel` | A floating window, summoned or persistent |
| `overlay` | `entryPoints.overlay` | A fullscreen surface |
| `menu` | `entryPoints.menu` | A summoned menu |
| `service` | `entryPoints.service` | A headless singleton |
| `bar` | `entryPoints.bar` | A full bar that replaces `omarchy.bar` |

`omarchy plugin validate` refuses a kind without its entry point, so a plugin cannot install, enable, and then quietly do nothing.
