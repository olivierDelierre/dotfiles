#!/usr/bin/env bash

set -euo pipefail

readonly DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly HOME_DIR="${HOME:?HOME must be set}"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME_DIR}/.config}"

dry_run=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Create symbolic links from this repository into your home directory.
Existing files are moved to a timestamped .backup path before linking.
EOF
}

run() {
  if ${dry_run}; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

choose_shell() {
  local choice

  printf 'Which shell profile do you want to install?\n'
  printf '  1) PowerShell\n'
  printf '  2) ZSH\n'

  while true; do
    if ! read -r -p "Choose [1-2]: " choice; then
      printf 'No shell selected.\n' >&2
      exit 1
    fi

    case "${choice}" in
      1|powershell|PowerShell)
        selected_shell="powershell"
        return
        ;;
      2|zsh|ZSH)
        selected_shell="zsh"
        return
        ;;
      *)
        printf 'Please enter 1 or 2.\n' >&2
        ;;
    esac
  done
}

install_oh_my_posh() {
  local choice

  if command -v oh-my-posh >/dev/null 2>&1; then
    printf 'oh-my-posh is already installed; skipping.\n'
    return
  fi

  while true; do
    if ! read -r -p "Do you want to install oh-my-posh? (Y/n): " choice; then
      printf 'Skipping oh-my-posh installation.\n'
      return
    fi

    case "${choice}" in
      ""|y|Y|yes|YES|Yes)
        if ${dry_run}; then
          printf '%s\n' '[dry-run] curl -s https://ohmyposh.dev/install.sh | bash -s'
        else
          curl -s https://ohmyposh.dev/install.sh | bash -s
        fi
        return
        ;;
      n|N|no|NO|No)
        printf 'Skipping oh-my-posh installation.\n'
        return
        ;;
      *)
        printf 'Please enter y or n.\n' >&2
        ;;
    esac
  done
}

install_fzf() {
  local choice

  if command -v fzf >/dev/null 2>&1; then
    printf 'fzf is already installed; skipping.\n'
    return
  fi

  while true; do
    if ! read -r -p "Do you want to install fzf? (Y/n): " choice; then
      printf 'Skipping fzf installation.\n'
      return
    fi

    case "${choice}" in
      ""|y|Y|yes|YES|Yes)
        run git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME_DIR}/.fzf"
        run "${HOME_DIR}/.fzf/install"
        return
        ;;
      n|N|no|NO|No)
        printf 'Skipping fzf installation.\n'
        return
        ;;
      *)
        printf 'Please enter y or n.\n' >&2
        ;;
    esac
  done
}

install_zoxide() {
  local choice

  if command -v zoxide >/dev/null 2>&1; then
    printf 'zoxide is already installed; skipping.\n'
    return
  fi

  while true; do
    if ! read -r -p "Do you want to install zoxide? (Y/n): " choice; then
      printf 'Skipping zoxide installation.\n'
      return
    fi

    case "${choice}" in
      ""|y|Y|yes|YES|Yes)
        if ${dry_run}; then
          printf '%s\n' '[dry-run] curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh'
        else
          curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
        fi
        return
        ;;
      n|N|no|NO|No)
        printf 'Skipping zoxide installation.\n'
        return
        ;;
      *)
        printf 'Please enter y or n.\n' >&2
        ;;
    esac
  done
}

link_path() {
  local source=$1
  local destination=$2
  local destination_parent
  local backup
  local suffix

  if [[ -L "${destination}" ]] && [[ "$(readlink "${destination}")" == "${source}" ]]; then
    printf 'Already linked: %s\n' "${destination}"
    return
  fi

  destination_parent="$(dirname -- "${destination}")"
  run mkdir -p "${destination_parent}"

  if [[ -e "${destination}" ]] || [[ -L "${destination}" ]]; then
    backup="${destination}.backup.$(date +%Y%m%d%H%M%S)"
    suffix=1

    while [[ -e "${backup}" ]] || [[ -L "${backup}" ]]; do
      backup="${destination}.backup.$(date +%Y%m%d%H%M%S).${suffix}"
      ((suffix += 1))
    done

    run mv -- "${destination}" "${backup}"
    printf 'Backed up: %s -> %s\n' "${destination}" "${backup}"
  fi

  run ln -s "${source}" "${destination}"
  printf 'Linked: %s -> %s\n' "${destination}" "${source}"
}

while (($# > 0)); do
  case "$1" in
    --dry-run)
      dry_run=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

selected_shell=""
choose_shell
install_oh_my_posh
install_fzf
install_zoxide

readonly home_files=(".ideavimrc")

for file in "${home_files[@]}"; do
  link_path "${DOTFILES_DIR}/${file}" "${HOME_DIR}/${file}"
done

if [[ -d "${DOTFILES_DIR}/.config" ]]; then
  for source in "${DOTFILES_DIR}"/.config/*; do
    [[ -e "${source}" ]] || continue
    link_path "${source}" "${CONFIG_HOME}/$(basename -- "${source}")"
  done
fi

case "${selected_shell}" in
  powershell)
    if [[ -f "${DOTFILES_DIR}/Microsoft.PowerShell_profile.ps1" ]]; then
      link_path \
        "${DOTFILES_DIR}/Microsoft.PowerShell_profile.ps1" \
        "${CONFIG_HOME}/powershell/Microsoft.PowerShell_profile.ps1"
    fi
    ;;
  zsh)
    link_path "${DOTFILES_DIR}/.zshrc" "${HOME_DIR}/.zshrc"
    ;;
esac
