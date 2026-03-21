#!/bin/sh

DO_PACKAGES=false
DO_UPDATE=false
DO_TMUX=false
DO_AI=false
RASPI=false
HAS_FLAGS=false

for arg in "$@"; do
  case "$arg" in
    --packages) DO_PACKAGES=true; HAS_FLAGS=true ;;
    --update)   DO_UPDATE=true;   HAS_FLAGS=true ;;
    --tmux)     DO_TMUX=true;     HAS_FLAGS=true ;;
    --ai)       DO_AI=true;       HAS_FLAGS=true ;;
    --raspi)    RASPI=true;       HAS_FLAGS=true ;;
  esac
done

# No flags → full install (packages + RC + tmux)
if [ "$HAS_FLAGS" = false ]; then
  DO_PACKAGES=true
  DO_UPDATE=true
fi

os=$(uname -s)

echo ""
echo "========================================="
echo "  nporc installer"
echo "========================================="
echo "  OS       : $os"
echo "  packages : $DO_PACKAGES"
echo "  update   : $DO_UPDATE"
echo "  tmux     : $DO_TMUX"
echo "  ai       : $DO_AI"
echo "  raspi    : $RASPI"
echo "========================================="
echo ""

# ── Package installation ───────────────────────────────────────────────────────

install_packages() {
  echo "[packages] starting..."

  if [ "$os" = "Darwin" ]; then
    echo "[packages] running brew update && brew upgrade..."
    brew update && brew upgrade
    echo "[packages] installing brew packages..."
    brew install htop tree speedtest-cli wget gum nmap tldr tmux
    echo "[packages] upgrading pip..."
    python3 -m pip install --upgrade pip

  elif [ "$os" = "Linux" ]; then
    echo "[packages] running apt-get update..."
    sudo apt-get update
    echo "[packages] installing apt packages..."
    sudo apt-get install -y htop net-tools tmux tree speedtest-cli
    sudo apt-get install -y wget nmap ca-certificates indicator-multiload
    sudo apt-get install -y python3-pip python3-venv
    echo "[packages] installing gum..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install gum
    echo "[packages] upgrading pip..."
    python3 -m pip install --upgrade pip

  elif echo "$os" | grep -qi "mingw\|cygwin\|msys"; then
    echo "[packages] installing winget packages..."
    winget install charmbracelet.gum  --accept-source-agreements --accept-package-agreements
    winget install speedtest-cli      --accept-source-agreements --accept-package-agreements
    winget install -e --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements
    winget install python3            --accept-source-agreements --accept-package-agreements
    echo "[packages] upgrading pip..."
    python3 -m pip install --upgrade pip

  else
    echo "[packages] unknown OS — skipping"
  fi

  echo "[packages] done."
}

# ── RC patching ───────────────────────────────────────────────────────────────

patch_rc() {
  echo "[update] patching RC files..."

  if [ "$os" = "Darwin" ]; then
    RC="$HOME/.zshrc"

    if [ ! -f "$RC" ]; then
      echo "[update] $RC not found — creating from /etc/zshrc..."
      touch "$RC"
      cat /etc/zshrc >> "$RC"
    else
      echo "[update] found $RC"
    fi

    if grep -q "#:begin" "$RC"; then
      echo "[update] existing nporc block found — replacing..."
      sed -i '' '/#:begin/,$d' "$RC"
    else
      echo "[update] no existing nporc block — appending fresh..."
    fi

    echo "[update] appending .nporc..."
    cat ~/.nporc/.nporc >> "$RC"
    echo "[update] appending .npo_aliases..."
    cat ~/.nporc/.npo_aliases >> "$RC"

    if [ "$RASPI" = true ]; then
      echo "[update] appending .npo_raspi_aliases..."
      cat ~/.nporc/.npo_raspi_aliases >> "$RC"
    fi

    echo "[update] setting git remote to SSH..."
    cd ~/.nporc && git remote set-url origin git@github.com:npolgado/.nporc.git

  elif [ "$os" = "Linux" ]; then
    if [ ! -f ~/.bashrc ]; then
      echo "[update] ~/.bashrc not found — copying from /etc/skel..."
      /bin/cp /etc/skel/.bashrc ~/
    else
      echo "[update] found ~/.bashrc"
    fi

    if grep -q "#:begin" ~/.bashrc; then
      echo "[update] existing nporc block found in .bashrc — replacing..."
      sed -i '/#:begin/,$d' ~/.bashrc
    fi
    echo "[update] appending .nporc to .bashrc..."
    cat ~/.nporc/.nporc | sed -n '/#:begin/,$p' >> ~/.bashrc

    if [ ! -f ~/.bash_aliases ]; then
      echo "[update] ~/.bash_aliases not found — creating..."
      touch ~/.bash_aliases
      echo "#!/bin/bash" >> ~/.bash_aliases
    else
      echo "[update] found ~/.bash_aliases"
    fi

    if grep -q "#:begin" ~/.bash_aliases; then
      echo "[update] existing nporc block found in .bash_aliases — replacing..."
      sed -i '/#:begin/,$d' ~/.bash_aliases
    fi
    echo "[update] appending .npo_aliases to .bash_aliases..."
    cat ~/.nporc/.npo_aliases | sed -n '/#:begin/,$p' >> ~/.bash_aliases

    if [ "$RASPI" = true ]; then
      echo "[update] appending .npo_raspi_aliases to .bash_aliases..."
      cat ~/.nporc/.npo_raspi_aliases >> ~/.bash_aliases
    fi

    echo "[update] setting git remote to SSH..."
    cd ~/.nporc && git remote set-url origin git@github.com:npolgado/.nporc.git
  fi

  echo "[update] run 'reload' or open a new shell to apply changes"
  echo "[update] done."
}

# ── Tmux config ───────────────────────────────────────────────────────────────

install_tmux() {
  echo "[tmux] installing tmux config..."

  if [ -f ~/.tmux.conf ]; then
    backup="$HOME/.tmux.conf.old_$(date +%Y%m%d_%H%M%S)"
    echo "[tmux] existing config found — backing up to $backup"
    sudo cp ~/.tmux.conf "$backup"
  else
    echo "[tmux] no existing config found"
  fi

  sudo cp ~/.nporc/.tmux.conf ~/.tmux.conf
  echo "[tmux] done."
}

# ── AI config ─────────────────────────────────────────────────────────────────

install_ai() {
  echo "[ai] installing CLAUDE.md..."

  if [ -f ~/.claude/CLAUDE.md ]; then
    mkdir -p ~/.claude/.old
    backup="$HOME/.claude/.old/CLAUDE.md.old_$(date +%Y%m%d_%H%M%S)"
    echo "[ai] existing CLAUDE.md found — backing up to $backup"
    cp ~/.claude/CLAUDE.md "$backup"
  else
    echo "[ai] no existing CLAUDE.md found"
  fi

  cp ~/.nporc/CLAUDE.md ~/.claude/CLAUDE.md
  echo "[ai] done."
}

# ── Execute ───────────────────────────────────────────────────────────────────

if [ "$DO_PACKAGES" = true ]; then install_packages; echo ""; fi
if [ "$DO_UPDATE"   = true ]; then patch_rc;         echo ""; fi
if [ "$DO_TMUX"     = true ]; then install_tmux;     echo ""; fi
if [ "$DO_AI"       = true ]; then install_ai;       echo ""; fi

echo "========================================="
echo "  all done"
echo "========================================="
echo ""
