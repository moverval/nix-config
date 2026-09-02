{ pkgs, ... }: {
  home.packages = [
    pkgs.bubblewrap

    
    (pkgs.writeShellScriptBin "isolate" ''
      set -e      
      TARGET_DIR=$(pwd)

      FOLDER_NAME=$(basename "$TARGET_DIR")

      CURRENT_PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] "
      NEW_PS1="\n\[\033[1;35m\]($FOLDER_NAME)\[\033[1;32m\] $CURRENT_PS1"

      BWRAP_ARGS=(
        --unshare-user
        --dir /
        --bind /run /run
        --bind /tmp /tmp
        --ro-bind /nix /nix
        --ro-bind /usr /usr
        --ro-bind /etc /etc
        --ro-bind /sys /sys
        --ro-bind /proc /proc
        --ro-bind /var /var
        --ro-bind "$HOME/.nix-profile/bin" "$HOME/.nix-profile/bin"
        --ro-bind "$HOME/.config" "$HOME/.config"
        --ro-bind "$HOME/.bash_profile" "$HOME/.bash_profile"
        --ro-bind "$HOME/.bashrc" "$HOME/.bashrc"
        --ro-bind "$HOME/.local" "$HOME/.local"
        --ro-bind "$HOME/.gitconfig" "$HOME/.gitconfig"
        --dev /dev
        --setenv PATH "$PATH"
        --setenv XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR"
        --setenv PS1 "$NEW_PS1"
        --bind "$TARGET_DIR" "$TARGET_DIR"
        --chdir "$TARGET_DIR"
      )

      while [[ $# -gt 0 ]]; do

        case "$1" in
          --help)
            cat <<EOF
Isolate:

-b <path> or --bind <path>
  expose a writeable path

-rb <path> or --ro-bind <path>
  expose a readonly path

--pi
  add pi content

--cargo
  add cargo content

--npm
  add npm content

--bun
  add bun content

--keyring
  add keyring support

--keepass
  add keepassxc support
EOF
            exit 0
            shift
            ;;
          --pi)
            mkdir -p "$HOME/.pi"
            BWRAP_ARGS+=(
              --bind "$HOME/.pi" "$HOME/.pi"
            )
            shift
            ;;
          --cargo)
            mkdir -p "$HOME/.cargo"
            BWRAP_ARGS+=(
              --bind "$HOME/.cargo" "$HOME/.cargo"
            )
            shift
            ;;
          --npm)
            mkdir -p "$HOME/.npm"
            BWRAP_ARGS+=(
              --bind "$HOME/.npm" "$HOME/.npm"
            )
            shift
            ;;
          --bun)
            mkdir -p "$HOME/.bun"
            BWRAP_ARGS+=(
              --bind "$HOME/.bun" "$HOME/.bun"
            )
            shift
            ;;
          --keyring)
            if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
              DBUS_PATH=$(echo "$DBUS_SESSION_BUS_ADDRESS" | sed -r 's/.*path=([^,]*).*/\1/')
              if [ -S "$DBUS_PATH" ]; then
                BWRAP_ARGS+=( 
                  --bind "$DBUS_PATH" "$DBUS_PATH"
                  --setenv DBUS_SESSION_BUS_ADDRESS "$DBUS_SESSION_BUS_ADDRESS"
                )              
              fi
            fi
            shift
            ;;
          --keepass)
            if [ -z "$XDG_RUNTIME_DIR" ]; then
              KP_SOCKET="/run/user/$(id -u)/app/org.keepassxc.KeePassXC"
            fi

            if [ -S "$KP_SOCKET" ]; then
              BWRAP_ARGS+=( 
                --bind "$KP_SOCKET" "$KP_SOCKET"
              )
            fi

            if [ -z "$XDG_RUNTIME_DIR" ]; then
              KP_SOCKET="/run/user/$(id -u)/org.keepassxc.KeePassXC.BrowserServer"
            fi

            if [ -S "$KP_SOCKET" ]; then
              BWRAP_ARGS+=( 
                --bind "$KP_SOCKET" "$KP_SOCKET"
              )
            fi
            shift
            ;;
          -b|--bind)
            if [ -z "$2" ]; then
              echo "'$2' not a folder"
              return 1
            fi

            mkdir -p "$2"

            BWRAP_ARGS+=(
              --bind "$2" "$2"
            )

            shift 2
            ;;
            -rb|--ro-bind)
            if [ -z "$2" ]; then
              echo "'$2' not a folder"
              return 1
            fi

            mkdir -p "$2"

            BWRAP_ARGS+=(
              --ro-bind "$2" "$2"
            )

            shift 2
            ;;
          *)
          echo "Unknown option: '$1'"
          echo "See 'isolate --help' for help"
          exit 1
          shift
          ;;
        esac

      done

      exec ${pkgs.bubblewrap}/bin/bwrap \
        "''${BWRAP_ARGS[@]}" \
        ${pkgs.bashInteractive}/bin/bash --norc
      '')
    ];
}
