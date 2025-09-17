return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    -- Add Mason for better LSP management
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    -- Setup Mason first
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "tailwindcss",
        "html",
        "cssls",
        "tsserver",
        "lua_ls",
      },
    })

    -- import lspconfig plugin
    local lspconfig = require("lspconfig")
    local util = require("lspconfig/util")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1 })
      end, opts)

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1 })
      end, opts)

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

      -- Debug: Print when LSP attaches
      print("LSP attached: " .. client.name .. " to buffer " .. bufnr)
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- TailwindCSS with enhanced v4 support and debugging
    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- Debug: Print Tailwind specific info
        print("Tailwind LSP attached to: " .. vim.api.nvim_buf_get_name(bufnr))
        print("Root dir: " .. (client.config.root_dir or "nil"))
        print("Workspace folders: " .. vim.inspect(client.workspace_folders or {}))
      end,

      -- Enhanced filetypes for better coverage
      filetypes = {
        "css",
        "scss",
        "sass",
        "less",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
        "php",
        "twig",
        "blade",
        "markdown",
        "mdx",
        -- Add more as needed
      },

      -- Enhanced root detection for v4 and v3
      root_dir = function(fname)
        local root = util.root_pattern(
          -- Tailwind v4 patterns
          "tailwind.config.ts",
          "tailwind.config.js",
          "tailwind.config.mjs",
          "tailwind.config.cjs",
          -- CSS files that might contain @config directive (v4)
          "src/styles.css",
          "app/globals.css",
          "styles/globals.css",
          -- Traditional patterns
          "postcss.config.js",
          "postcss.config.cjs",
          "postcss.config.mjs",
          "postcss.config.ts",
          -- Package.json fallback
          "package.json",
          -- Git fallback
          ".git"
        )(fname)

        -- Debug: Print root detection
        if root then
          print("Tailwind root detected: " .. root .. " for file: " .. fname)
        else
          print("No Tailwind root found for file: " .. fname)
        end

        return root
      end,

      -- Custom initialization with user languages
      init_options = {
        userLanguages = {
          -- Common mappings that might be missing
          eelixir = "phoenix-heex",
          eruby = "erb",
          heex = "phoenix-heex",
          svelte = "html",
          blade = "html",
          twig = "html",
          php = "html",
          vue = "html",
          astro = "html",
          mdx = "javascriptreact",
        },
      },

      settings = {
        tailwindCSS = {
          -- Enable experimental features for v4
          experimental = {
            classRegex = {
              -- Standard patterns
              "class[:]\\s*['\"`]([^'\"`]*)['\"`]",
              "className[:]\\s*['\"`]([^'\"`]*)['\"`]",
              -- Template literals
              "tw\\`([^`]*)",
              "tw['\"]([^'\"]*)['\"]",
              "tw\\.\\w+\\`([^`]*)",
              "tw\\(.*?\\)\\`([^`]*)",
              -- Vue class bindings
              ':class="[^"]*"',
              'class="[^"]*"',
              -- Custom patterns for different frameworks
              "classList\\.[\\w$]+\\s*=\\s*['\"`]([^'\"`]*)['\"`]",
            },
          },

          -- Include CSS files for @config directive detection
          includeLanguages = {
            css = "css",
            scss = "css",
            sass = "css",
            less = "css",
          },

          -- Validate classes
          validate = true,

          -- Enhanced class attributes
          classAttributes = {
            "class",
            "className",
            "class:list",
            "classList",
            "ngClass",
            ":class",
            "class:",
          },

          -- Lint options
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning",
          },

          -- Enable hover documentation
          showPixelEquivalents = true,
          rootFontSize = 16,
        },
      },
    })

    -- HTML
    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- CSS and SCSS
    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- JavaScript and TypeScript (Node, Express)
    lspconfig["tsserver"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    })

    -- Go
    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    })

    -- Ruby (Solargraph)
    lspconfig["solargraph"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = util.root_pattern("Gemfile", ".git", "*.gemspec"),
      settings = {
        solargraph = {
          diagnostics = true,
        },
      },
    })

    -- Emmet (for JSX, HTML, CSS)
    lspconfig["emmet_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
    })

    -- Prisma (Optional, for database-related projects)
    lspconfig["prismals"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Lua (for Neovim configuration)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- Debug commands
    vim.api.nvim_create_user_command("TailwindInfo", function()
      local clients = vim.lsp.get_clients({ name = "tailwindcss" })
      if #clients == 0 then
        print("No Tailwind LSP clients active")
        return
      end

      for _, client in ipairs(clients) do
        print("Tailwind LSP Client Info:")
        print("  Name: " .. client.name)
        print("  Root dir: " .. (client.config.root_dir or "nil"))
        print("  Server capabilities: " .. vim.inspect(client.server_capabilities))
        print("  Attached buffers: " .. vim.inspect(vim.tbl_keys(client.attached_buffers or {})))
      end
    end, {})

    vim.api.nvim_create_user_command("TailwindRestart", function()
      vim.cmd("LspRestart tailwindcss")
    end, {})
  end,
}
