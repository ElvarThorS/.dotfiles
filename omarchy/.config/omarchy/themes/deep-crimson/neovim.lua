return {
    {
        "bjarneo/aether.nvim",
        branch = "v2",
        name = "aether",
        priority = 1000,
        opts = {
            transparent = false,
            colors = {
                -- Background colors
                bg = "#0b0707",
                bg_dark = "#090505",
                bg_highlight = "#3a1a1a",

                -- Foreground colors
                -- fg: Object properties, builtin types, builtin variables, member access, default text
                fg = "#e1484f",
                -- fg_dark: Inactive elements, statusline, secondary text
                fg_dark = "#b3122a",
                -- comment: Line highlight, gutter elements, disabled states
                comment = "#3a1a1a",

                -- Accent colors
                -- red: Errors, diagnostics, tags, deletions, breakpoints
                red = "#b3122a",
                -- orange: Constants, numbers, current line number, git modifications
                orange = "#c08a46",
                -- yellow: Types, classes, constructors, warnings, numbers, booleans
                yellow = "#9a6b2f",
                -- green: Comments, strings, success states, git additions
                green = "#4a6a55",
                -- cyan: Parameters, regex, preprocessor, hints, properties
                cyan = "#4a6b6c",
                -- blue: Functions, keywords, directories, links, info diagnostics
                blue = "#4a5670",
                -- purple: Storage keywords, special keywords, identifiers, namespaces
                purple = "#7a2b3f",
                -- magenta: Function declarations, exception handling, tags
                magenta = "#b35a6d",
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
