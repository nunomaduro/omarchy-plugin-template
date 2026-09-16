# The intention of this project

This project is a template for a plugin of the Omarchy shell. A developer clones it to write a bar widget, a panel, an overlay, a menu or a service for `omarchy-shell`, and publishes the result as a git repository that `omarchy plugin add` installs. It is a plugin that a user installs, not an application. `manifest.json` declares the plugin to the shell, and `BarWidget.qml` is the entry point that the shell loads.

Install the dependencies with `omarchy pkg add qt6-declarative jq shfmt actionlint yamllint editorconfig-checker typos gitleaks markdownlint-cli2`, and take `shellcheck` from <https://github.com/koalaman/shellcheck/releases> on aarch64. Run the tests with `bin/test`. Write the QML format back with `bin/format`. There is no command that starts the program, because the shell loads the plugin from `~/.config/omarchy/plugins/<id>/`.

- `bin/` — `test` validates the manifest, lints the QML, checks its format and runs the tests; `format` rewrites the QML
- `tests/` — the Qt Quick tests and the stub bar that drives the widget
- `.github/` — the workflow that runs `bin/test` on Arch Linux
