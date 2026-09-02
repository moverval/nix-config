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
        --unshare-user-try
        --unshare-pid
        --dir /
        --dir /sys
        --tmpfs /tmp
        --tmpfs /run
        --proc /proc
        --dir /run/user/$(id -u)
        --ro-bind /nix /nix
        --ro-bind /usr /usr
        --ro-bind /etc /etc
        --ro-bind /run/wrappers/bin /run/wrappers/bin
        --ro-bind /run/current-system/sw/bin /run/current-system/sw/bin
        --ro-bind /var /var
        --ro-bind-try "$HOME/.nix-profile/bin" "$HOME/.nix-profile/bin"
        --ro-bind "$HOME/.config" "$HOME/.config"
        --ro-bind-try "$HOME/.bash_profile" "$HOME/.bash_profile"
        --ro-bind-try "$HOME/.bashrc" "$HOME/.bashrc"
        --ro-bind "$HOME/.local" "$HOME/.local"
        --ro-bind-try "$HOME/.gitconfig" "$HOME/.gitconfig"
        --dev /dev
        --setenv PATH "$PATH"
        --setenv XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR"
        --setenv PS1 "$NEW_PS1"
        --unsetenv DISPLAY
        --unsetenv WAYLAND_DISPLAY
        --unsetenv DBUS_SESSION_BUS_ADDRESS
        --bind "$TARGET_DIR" "$TARGET_DIR"
        --chdir "$TARGET_DIR"
      )

      while [[ $# -gt 0 ]]; do

        case "$1" in
          -h|--help)
            cat <<EOF
Isolates current folder, so it is safe to execute unknown scripts or AI

-m <path> or --mount <path>
  expose a writeable path

-mr <path> or --ro-mount <path>
  expose a readonly path

--bind <host-path> <child-path>
  bind a host path

--ro-bind <host-path> <child-path>
  bind a readonly host path

--pi
  add pi content

--cargo
  add cargo content

--npm
  add npm content

--bun
  add bun content

--keepass
  add keepassxc support

-g or --graphical
  wayland support
  Unsafe: Keylogger

-a or --audio
  pipewire and pulseaudio support
  Unsafe: Screenshots and noise audio

--unsafe-x11
  x11 fallback support
  Unsafe: Remote Execution

--unsafe-bus
  host bus support
  Unsafe: Remote Execution because of full access to host system

--bus or -b
  bus support with sandboxed bus

PI Environment:

  isolate --pi

Firefox Environment:

  isolate -g -a -b --firefox

  Exposes wayland (-g), pipewire and pulseaudio (-a) and a sandboxed bus (-b)
  with an empty firefox config (--firefox)

Rust Environment:

  isolate --cargo

Keepassxc and Secret Service:

  isolate -b --keepass

  Secret Service runs over the bus
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
          --firefox)
            BWRAP_ARGS+=(
              --tmpfs "$HOME/.config/mozilla"
            )
            shift
            ;;
          --unsafe-bus)
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
          -b|--bus)
            if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
              DBUS_PATH=$(echo "$DBUS_SESSION_BUS_ADDRESS" | sed -r 's/.*path=([^,]*).*/\1/')
              if [ -S "$DBUS_PATH" ]; then
                BWRAP_ARGS+=(
                  --bind-try "/run/user/$(id -u)/bus-sandbox" "$DBUS_PATH"
                  --setenv DBUS_SESSION_BUS_ADDRESS "$DBUS_SESSION_BUS_ADDRESS"
                )
              fi
            fi
            shift
            ;;
          --keepass)
            KP_SOCKET="/run/user/$(id -u)/app/org.keepassxc.KeePassXC"
            BWRAP_ARGS+=( 
              --bind-try "$KP_SOCKET" "$KP_SOCKET"
            )

            KP_SOCKET="/run/user/$(id -u)/org.keepassxc.KeePassXC.BrowserServer"
            BWRAP_ARGS+=( 
              --bind-try "$KP_SOCKET" "$KP_SOCKET"
            )
            shift
            ;;
          -a|--audio)
            BWRAP_ARGS+=(
              --bind "/run/user/$(id -u)/pipewire-0" "/run/user/$(id -u)/pipewire-0"
              --bind "/run/user/$(id -u)/pulse" "/run/user/$(id -u)/pulse"
            )
            shift
            ;;
          -g|--graphical)
            if [ -z "$WAYLAND_DISPLAY" ]; then
              WAYLAND_DISPLAY="wayland-0"
            fi
            BWRAP_ARGS+=(
              --bind "/run/user/$(id -u)/$WAYLAND_DISPLAY" "/run/user/$(id -u)/$WAYLAND_DISPLAY"
              --dev-bind-try /dev/dri /dev/dri
              --setenv WAYLAND_DISPLAY "$WAYLAND_DISPLAY"
              --ro-bind /sys/dev /sys/dev
              --ro-bind /sys/devices /sys/devices
              --ro-bind /sys/class /sys/class
              --ro-bind-try /run/opengl-driver /run/opengl-driver
              --ro-bind-try /run/opengl-driver-32 /run/opengl-driver-32
            )
            shift
            ;;
          --unsafe-x11)
            BWRAP_ARGS+=(
              --ro-bind-try /tmp/.X11-unix /tmp/.X11-unix \
              --ro-bind-try ~/.Xauthority ~/.Xauthority \
              --setenv DISPLAY "$DISPLAY"
              --setenv XAUTHORITY "$XAUTHORITY"
             )
             shift
             ;;
          -m|--mount)
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
          -mr|--ro-mount)
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
          --bind)
            if [ -z "$2" ]; then
              echo "'$2' not a folder"
              return 1
            fi

            if [ -z "$3" ]; then
              echo "'$3' not a folder"
              return 1
            fi

            mkdir -p "$2"

            BWRAP_ARGS+=(
              --bind "$2" "$3"
            )

            shift 3
            ;;
          --ro-bind)
              if [ -z "$2" ]; then
                echo "'$2' not a folder"
                return 1
              fi

              if [ -z "$3" ]; then
                echo "'$3' not a folder"
                return 1
              fi

              mkdir -p "$2"

              BWRAP_ARGS+=(
                --ro-bind "$2" "$3"
              )

              shift 3
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
        ${pkgs.bashInteractive}/bin/bash --rcfile <(echo "source ~/.bashrc; PS1='$NEW_PS1'")
      '')
    ];

    systemd.user.services.dbus-proxy-sandbox = {
      Unit = {
        Description = "Filtered D-Bus proxy for sandboxed apps";
        After = [ "dbus.service" ];
      };
      Service = {
        ExecStart = ''
          ${pkgs.xdg-dbus-proxy}/bin/xdg-dbus-proxy \
            unix:path=%t/bus %t/bus-sandbox --filter \
            --talk=org.freedesktop.Notifications \
            --talk=org.freedesktop.portal.Secret \
            --talk=org.freedesktop.portal.Documents \
            --talk=org.freedesktop.portal.Desktop \
            --talk=org.gtk.Settings \
            --talk=org.ally.Bus
          '';
          Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
   };
 }
