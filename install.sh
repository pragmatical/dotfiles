#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ssh_dir="$HOME/.ssh"
include_line='Include ~/.ssh/config.d/personal-github.conf'

install -d -m 700 "$ssh_dir" "$ssh_dir/config.d"
install -m 644 "$source_dir/github-personal.pub" "$ssh_dir/github-personal.pub"
install -m 600 "$source_dir/github-personal.conf" "$ssh_dir/config.d/personal-github.conf"

touch "$ssh_dir/config"
chmod 600 "$ssh_dir/config"
if ! grep -Fxq "$include_line" "$ssh_dir/config"; then
    config_tmp="$(mktemp "$ssh_dir/config.XXXXXX")"
    trap 'rm -f -- "$config_tmp"' EXIT
    {
        printf '%s\n' "$include_line"
        cat "$ssh_dir/config"
    } > "$config_tmp"
    cat "$config_tmp" > "$ssh_dir/config"
fi

printf 'Personal GitHub SSH configuration installed.\n'
