#!/usr/bin/env bash
set -euo pipefail

# kickstart.nvim dependency installer (macOS + Debian/Ubuntu)
#
# This installs system-level binaries that this Neovim config expects.
# Neovim plugins themselves are installed by lazy.nvim on first launch.
#
# Usage:
#   ./install-deps.sh            # install + verify
#   ./install-deps.sh --check    # verify only (no installs)
#   ./install-deps.sh --help
#
#   WORK=1 ./install-deps.sh     # also installs WORK-only deps (Sourcegraph CLI; Linux prints instructions)

usage() {
  cat <<'EOF'
install-deps.sh - install external dependencies for this Neovim config

Usage:
  install-deps.sh            Install via brew/apt + npm, then verify
  install-deps.sh --check    Verify only (no installs)
  install-deps.sh --help     Show this help

Environment:
  WORK=1   Also install WORK-only tools (Sourcegraph CLI)
  INSTALL_ZELLIJ=1  On Linux, attempt to install zellij (may require a newer Rust toolchain)
EOF
}

case "${1:-}" in
  "" ) mode="install" ;;
  --check ) mode="check" ;;
  --help|-h ) usage; exit 0 ;;
  * ) echo "Unknown argument: $1"; usage; exit 1 ;;
esac

is_darwin() { [[ "${OSTYPE:-}" == darwin* ]]; }
is_linux() { [[ "${OSTYPE:-}" == linux* ]]; }

# Make common user bin dirs discoverable for checks
if [[ -d "${HOME}/.local/bin" ]]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi
if [[ -d "${HOME}/.cargo/bin" ]]; then
  export PATH="${HOME}/.cargo/bin:${PATH}"
fi

if ! is_darwin && ! is_linux; then
  echo "Unsupported OS: ${OSTYPE:-unknown}"
  echo "Supported: macOS (darwin), Debian/Ubuntu (linux)"
  exit 1
fi

if is_darwin && [[ "$mode" == "install" ]] && ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required on macOS. Install it from https://brew.sh then re-run."
  exit 1
fi

linux_id=""
linux_like=""
if is_linux && [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  linux_id="${ID:-}"
  linux_like="${ID_LIKE:-}"
fi

is_debian_like() {
  [[ "$linux_id" == "debian" || "$linux_id" == "ubuntu" || "$linux_like" == *debian* ]]
}

if is_linux && ! is_debian_like; then
  echo "This Linux mode supports Debian/Ubuntu only (detected ID='${linux_id:-unknown}', ID_LIKE='${linux_like:-unknown}')."
  exit 1
fi

if is_darwin; then
  BREW_INSTALLABLE=(
    # Core
    neovim
    git
    make
    unzip

    # Telescope live_grep + config health check
    ripgrep

    # File finding (telescope integrations commonly use fd)
    fd

    # Plugin builds / native deps
    cmake
    ninja

    # Plugins / workflows in this config
    lazygit
    gh
    tmux
    zellij

    # Language toolchains used by this config
    go
    node
    yarn

    # Formatters
    stylua
  )

  # WORK-only tools (your config loads some plugins only when WORK=1)
  if [[ "${WORK:-0}" == "1" ]]; then
    echo "WORK=1 detected: will also install Sourcegraph CLI (src)."
    brew tap sourcegraph/src-cli >/dev/null 2>&1 || true
    BREW_INSTALLABLE+=(src-cli)
  fi

  if [[ "$mode" == "install" ]]; then
    echo "Installing Homebrew packages..."
    brew update >/dev/null
    brew install "${BREW_INSTALLABLE[@]}"

    # Node-based formatter used by lua/kickstart/plugins/conform.lua
    if ! command -v prettier >/dev/null 2>&1; then
      echo "Installing prettier (npm -g)..."
      npm install -g prettier
    fi
  fi
fi

if is_linux; then
  require_sudo() {
    if command -v sudo >/dev/null 2>&1; then
      sudo -v
    else
      echo "sudo is required on Linux to install packages."
      exit 1
    fi
  }

  apt_install_core() {
    require_sudo
    sudo apt-get update
    sudo apt-get install -y \
      ca-certificates \
      curl \
      git \
      make \
      unzip \
      ripgrep \
      fd-find \
      tmux \
      xclip \
      build-essential \
      pkg-config \
      cmake \
      ninja-build \
      nodejs \
      npm \
      golang-go
  }

  apt_try_install() {
    local pkg="$1"
    set +e
    sudo apt-get install -y "$pkg" >/dev/null 2>&1
    local rc=$?
    set -e
    return $rc
  }

  install_neovim_linux() {
    require_sudo

    if [[ "$linux_id" == "ubuntu" ]]; then
      # Use Neovim PPA so we get a recent version.
      sudo apt-get update
      sudo apt-get install -y software-properties-common
      sudo add-apt-repository -y ppa:neovim-ppa/unstable
      sudo apt-get update
      sudo apt-get install -y neovim
      return
    fi

    # Debian: distro neovim is often too old; install latest tarball to /opt.
    local arch
    arch="$(uname -m)"
    if [[ "$arch" != "x86_64" && "$arch" != "amd64" ]]; then
      echo "Debian: automatic Neovim install is only implemented for x86_64 (detected $arch)."
      echo "Install Neovim >= 0.10 manually, then re-run with --check."
      return
    fi

    sudo apt-get update
    sudo apt-get install -y tar xz-utils

    local tmp
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT

    echo "Installing Neovim from GitHub release tarball..."
    curl -fsSL -o "$tmp/nvim-linux-x86_64.tar.gz" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

    # Replace existing install under /opt.
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo mkdir -p /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf "$tmp/nvim-linux-x86_64.tar.gz"
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  }

  linux_fix_fd() {
    # Debian/Ubuntu package is fd-find, binary is typically `fdfind`.
    if command -v fd >/dev/null 2>&1; then
      return
    fi
    if command -v fdfind >/dev/null 2>&1; then
      # Prefer a system-wide symlink so tools can find `fd` without PATH tweaks.
      if command -v sudo >/dev/null 2>&1; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd 2>/dev/null || true
      fi
      if command -v fd >/dev/null 2>&1; then
        return
      fi

      mkdir -p "${HOME}/.local/bin"
      ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
      echo "Linked fdfind -> ~/.local/bin/fd"
    fi
  }

  linux_install_formatters_and_mux() {
    # yarn is needed by markdown-preview.nvim build (if you enable it) and is generally useful.
    if ! command -v yarn >/dev/null 2>&1; then
      if command -v corepack >/dev/null 2>&1; then
        echo "Enabling yarn via corepack..."
        sudo corepack enable || true
        corepack prepare yarn@stable --activate || true
      fi
    fi
    if ! command -v yarn >/dev/null 2>&1; then
      echo "Installing yarn (npm -g)..."
      sudo npm install -g yarn
    fi

    # prettier is used by conform for markdown formatting.
    if ! command -v prettier >/dev/null 2>&1; then
      echo "Installing prettier (npm -g)..."
      sudo npm install -g prettier
    fi
  }

  if [[ "$mode" == "install" ]]; then
    echo "Installing apt packages (Debian/Ubuntu)..."
    apt_install_core

    # Optional tools; do not fail if unavailable.
    require_sudo
    if ! apt_try_install wl-clipboard; then
      echo "NOTE: could not install wl-clipboard via apt (Wayland clipboard integration may be limited)."
    fi
    if ! apt_try_install lazygit; then
      echo "WARN: could not install lazygit via apt (install it manually if you use :LazyGit)."
    fi
    if ! apt_try_install gh; then
      echo "WARN: could not install gh via apt (needed for octo.nvim)."
    fi

    # Optional: zellij is only needed if you enable sidekick's zellij backend.
    if [[ "${INSTALL_ZELLIJ:-0}" == "1" ]]; then
      if ! apt_try_install zellij; then
        echo "WARN: could not install zellij via apt."
        echo "NOTE: cargo install zellij may require a newer Rust toolchain (edition2024)."
        echo "      Consider installing rustup + updating Rust (1.85+ or nightly), then: cargo install zellij"
      fi
    fi

    install_neovim_linux
    linux_fix_fd
    linux_install_formatters_and_mux

    if [[ "${WORK:-0}" == "1" ]]; then
      echo "WORK=1 detected: sg.nvim also expects the Sourcegraph CLI (src)."
      echo "NOTE: This script does not auto-install src on Debian/Ubuntu yet. Install it from https://sourcegraph.com/docs/cli"
    fi
  fi
fi

printf '\nVerifying executables...\n'

# Core requirements to start Neovim + bootstrap lazy.nvim
CORE_EXES=(
  nvim
  git
  make
  unzip
  rg
)

# Strongly recommended for this config's features
FEATURE_EXES=(
  fd
  lazygit
  gh
  node
  yarn
  go
  tmux
  zellij
  stylua
  prettier
)

# Custom keymaps reference these (optional)
OPTIONAL_EXES=(
  day
  zet
  tmux-sessionizer
)

missing_core=0
for exe in "${CORE_EXES[@]}"; do
  if command -v "$exe" >/dev/null 2>&1; then
    echo "  OK   $exe"
  else
    echo "  MISS $exe"
    missing_core=1
  fi
done

for exe in "${FEATURE_EXES[@]}"; do
  if command -v "$exe" >/dev/null 2>&1; then
    echo "  OK   $exe"
  else
    if [[ "$exe" == "stylua" ]]; then
      echo "  NOTE stylua (Mason installs this on first nvim start)"
    elif [[ "$exe" == "zellij" ]]; then
      echo "  NOTE zellij (only required if you enable sidekick)"
    else
      echo "  WARN $exe (some features may not work)"
    fi
  fi
done

for exe in "${OPTIONAL_EXES[@]}"; do
  if command -v "$exe" >/dev/null 2>&1; then
    echo "  OK   $exe"
  else
    echo "  NOTE $exe (only needed for custom keymaps)"
  fi
done

# Clipboard check
if is_darwin; then
  if command -v pbcopy >/dev/null 2>&1; then
    echo "  OK   pbcopy (clipboard)"
  else
    echo "  WARN pbcopy (clipboard integration may not work)"
  fi
else
  if command -v wl-copy >/dev/null 2>&1; then
    echo "  OK   wl-copy (clipboard)"
  elif command -v xclip >/dev/null 2>&1; then
    echo "  OK   xclip (clipboard)"
  else
    echo "  WARN clipboard tool missing (install wl-clipboard or xclip)"
  fi
fi

# Native build toolchain checks (treesitter parsers, telescope-fzf-native, luasnip jsregexp)
if command -v cc >/dev/null 2>&1; then
  echo "  OK   cc (C compiler)"
else
  if is_darwin; then
    echo "  WARN cc (install Xcode Command Line Tools: xcode-select --install)"
  else
    echo "  WARN cc (install build-essential)"
  fi
fi

cat <<'EOF'

Notes:
- Neovim plugins install automatically on first `nvim` launch via lazy.nvim.
- LSP servers/formatters/debug adapters are installed by Mason:
  - LSPs: clangd, gopls, rust_analyzer, lua_ls, vtsls, html (from lua/kickstart/lazy.lua)
  - Formatter: stylua (and prettier for markdown via conform)
  - Debug adapter: delve (Go)
- Some custom keymaps expect extra tools:
  - `tmux` + `tmux-sessionizer` (bound to <C-f>)
  - `day` (daily note path generator)
  - `zet` (zettelkasten note creator)
  These are not standard packages; install them however you manage dotfiles.

Recommended next step:
  nvim +":Lazy sync" +qa
EOF

if [[ $missing_core -ne 0 ]]; then
  printf '\nMissing one or more core requirements. Fix those and re-run.\n'
  exit 2
fi

printf '\nCore requirements installed.\n'
