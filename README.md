# nporc

A collection of shell functions, aliases, and scripts for personal productivity.

## Install

Clone the repo and run the installer:

    cd ~ && git clone git@github.com:npolgado/.nporc.git
    cd .nporc && chmod +x scripts/install.sh
    ./scripts/install.sh

For Raspberry Pi / home automation aliases, add the `--raspi` flag:

    ./scripts/install.sh --raspi

To update RC files without reinstalling packages:

    ./scripts/install.sh --update

## Contents

- `.nporc` — shell functions (`makezip`, `sanitize`, `ipm`, `ipdelay`, `now`, `today`)
- `.npo_aliases` — personal aliases (CLI, dev, git, tmux, obsidian)
- `.npo_raspi_aliases` — home automation and Raspberry Pi aliases (opt-in via `--raspi`)
- `.tmux.conf` — tmux config
- `scripts/` — install, commit helpers (`quick_commit.sh`, `formal_commit.sh`), SSH helpers
- `applications/` — standalone utility scripts (`file_organize.py`, `find_router.sh`, etc.)
- `templates/` — starter templates (`kivy.py`, `gum.sh`)
