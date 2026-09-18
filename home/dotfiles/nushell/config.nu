$env.config = ($env.config? | default {} | upsert keybindings [
    ...($env.config.keybindings? | default [])
    {
        name: tv_history
        modifier: control
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit --insert (tv nu-history)"
        }
    }
])

$env.config = ($env.config? | default {} | upsert edit_mode "vi")

$env.config = ($env.config | upsert cursor_shape {
    vi_insert: line
    vi_normal: block
})

$env.EDITOR = "hx"
$env.VISUAL = "hx"
