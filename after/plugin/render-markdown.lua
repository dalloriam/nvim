require('render-markdown').setup({
    enabled = true,
    render_modes = { 'n', 'c', 't', 'i' },
    link = {
        custom = {
            arch = { pattern = 'archlinux', icon = "󰣇 " },
        }
    }
})
