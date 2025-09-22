return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    "mason.nvim",
    "mason-lspconfig.nvim",
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")
    local util = require("lspconfig/util")

    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      -- LSP keybindings
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>FzfLua lsp_references<CR>", opts)

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>FzfLua lsp_typedefs<CR>", opts)

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>FzfLua diagnostics_document<CR>", opts)

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
    end

    -- Default capabilities for LSP servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Enable completion capabilities if using blink.cmp
    capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    -- Diagnostic signs in the gutter
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Configure diagnostics
    -- Remove or comment out the entire filter section in your vim.diagnostic.config
    vim.diagnostic.config({
      virtual_text = {
        enabled = true,
        source = "if_many",
        prefix = "●",
        spacing = 4,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
      -- Remove the entire filter section - this is causing the error
      -- filter = function(diagnostic) ... end,
    })
    -- LSP Server Configurations

    -- HTML
    lspconfig.html.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "htmldjango" },
    })

    -- CSS and SCSS
    lspconfig.cssls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        less = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    })

    -- TypeScript/JavaScript
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
      single_file_support = false, -- Disable single file support to reduce duplicates
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          -- Reduce duplicate diagnostics
          preferences = {
            disableSuggestions = false,
            quotePreference = "auto",
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
            includeCompletionsWithSnippetText = true,
            includeAutomaticOptionalChainCompletions = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        -- Global TypeScript settings
        completions = {
          completeFunctionCalls = true,
        },
      },
      -- Filter specific duplicate messages
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
          if result and result.diagnostics then
            -- Filter out specific duplicate patterns
            local filtered_diagnostics = {}
            local seen_messages = {}

            for _, diagnostic in ipairs(result.diagnostics) do
              local key = diagnostic.range.start.line
                .. ":"
                .. diagnostic.range.start.character
                .. ":"
                .. diagnostic.message
              if not seen_messages[key] then
                seen_messages[key] = true
                table.insert(filtered_diagnostics, diagnostic)
              end
            end

            result.diagnostics = filtered_diagnostics
          end

          vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
        end,
      },
    })

    -- TailwindCSS with enhanced v4 support
    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- Enable colorizer for tailwind files
        if client.name == "tailwindcss" then
          require("mini.hipatterns").setup({
            highlighters = {
              hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
            },
          })
        end
      end,
      filetypes = {
        "html",
        "css",
        "scss",
        "sass",
        "less",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
        "markdown",
        "mdx",
      },
      root_dir = util.root_pattern(
        "tailwind.config.ts",
        "tailwind.config.js",
        "tailwind.config.mjs",
        "tailwind.config.cjs",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
        "package.json",
        ".git"
      ),
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              "class[:]\\s*['\"`]([^'\"`]*)['\"`]",
              "className[:]\\s*['\"`]([^'\"`]*)['\"`]",
              "tw\\`([^`]*)",
              "tw['\"]([^'\"]*)['\"]",
            },
          },
          includeLanguages = {
            css = "css",
            scss = "css",
            sass = "css",
          },
          validate = true,
          classAttributes = {
            "class",
            "className",
            "class:list",
            "classList",
            "ngClass",
          },
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning",
          },
        },
      },
    })

    -- Go
    lspconfig.gopls.setup({
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

    -- Lua
    lspconfig.lua_ls.setup({
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
          telemetry = {
            enable = false,
          },
          hint = {
            enable = true,
          },
        },
      },
    })

    -- Emmet (for HTML/CSS/JSX)
    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "vue",
        "svelte",
      },
    })

    -- Prisma (optional)
    lspconfig.prismals.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- JSON with schema support
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- Create helpful commands for Tailwind debugging
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
        print("  Attached buffers: " .. vim.inspect(vim.tbl_keys(client.attached_buffers or {})))
      end
    end, {})

    vim.api.nvim_create_user_command("TailwindRestart", function()
      vim.cmd("LspRestart tailwindcss")
    end, {})
  end,
}
