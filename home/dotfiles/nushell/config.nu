$env.config.keybindings = (
    $env.config.keybindings | append {
        name: television_file_search
        modifier: control
        keycode: char_t
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                send: ExecuteHostCommand
                # Führt 'tv' im Inline- oder Standardmodus aus und fügt das Ergebnis in die Befehlszeile ein
                cmd: "let selected = (tv files | str trim); if ($selected | is-not-empty) { commandline edit --insert $selected }"
            }
        ]
    }
)

$env.config.keybindings = (
    $env.config.keybindings | append {
        name: television_directory_search
        modifier: control
        keycode: char_y
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                send: ExecuteHostCommand
                # Führt 'tv' im Inline- oder Standardmodus aus und fügt das Ergebnis in die Befehlszeile ein
                cmd: "let selected = (tv dirs | str trim); if ($selected | is-not-empty) { commandline edit --insert $selected }"
            }
        ]
    }
)

$env.config = ($env.config? | default {} | upsert edit_mode "vi")

$env.config = ($env.config | upsert cursor_shape {
    vi_insert: line
    vi_normal: block
})
