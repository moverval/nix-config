{ pkgs, ... }: {
  home.packages = [
    pkgs.bubblewrap

    
    (pkgs.writeShellScriptBin "isolate" ''
      set -e      
      TARGET_DIR=$(pwd)

      FOLDER_NAME=$(basename "$TARGET_DIR")

      CURRENT_PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] "
      NEW_PS1="\n\[\033[1;35m\]($FOLDER_NAME)\[\033[1;32m\] $CURRENT_PS1"

      exec ${pkgs.bubblewrap}/bin/bwrap \
        --unshare-user \
        --dir / \
        --bind /run /run \
        --bind /tmp /tmp \
        --ro-bind /nix /nix \
        --ro-bind /usr /usr \
        --ro-bind /etc /etc \
        --ro-bind /sys /sys \
        --ro-bind /proc /proc \
        --ro-bind /var /var \
        --ro-bind "$HOME/.nix-profile/bin" "$HOME/.nix-profile/bin" \
        --ro-bind "$HOME" "$HOME" \
        --dev /dev \
        --setenv PATH "$PATH" \
        --setenv PS1 "$NEW_PS1" \
        --bind "$TARGET_DIR" "$TARGET_DIR" \
        --chdir "$TARGET_DIR" \
        ${pkgs.bashInteractive}/bin/bash --norc
      '')
    ];
}
