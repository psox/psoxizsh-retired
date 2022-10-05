local util = require 'psoxizsh.lsp.util'

-- Map of preset lspconfig server definitions
--
-- Module users can then use these definitions either
-- directly, or by adding custom overrides via `with`
-- `M['<Server>'].with { ... }`
--
-- A couple examples:
--
-- ```lua
-- local Server = require 'psoxizsh.lsp.preset'
--
-- -- Basic setup for Rust development
-- {
--    Server.Rust, Server.Toml
-- }
--
-- -- Setup for Webdev.
-- {
--    Server.JavaScript, Server.TypeScript,
--    Server.CSS, Server.HTML
-- }
--
-- -- Complex setup for a Poetry based Python environment,
-- -- including a Postgres DB
-- {
--    Server.Python.with {
--      settings = { python = {
--        venvPath = '~/.poetry/venv',
--        analysis = { typeCheckingMode = 'strict' }
--    }}},
--
--    Server.SQL.with { settings = { sqls = { connections = {
--      { driver = 'postgres', dataSourceName = vim.env.PGCONN }
--    }}}},
-- }
-- ```
local M = {}
setmetatable(M, { __newindex = function(self, k, v) rawset(self, k, util.Server.new(v)) end })

local use_defaults = {}

M.Json = {
  name  = 'jsonls',
  ft    = { 'json', 'jsonc' },
  setup = use_defaults
}

M.Yaml = {
  name  = 'yamlls',
  ft    = { 'yaml', 'yml', 'yaml.docker-compose' },
  setup = use_defaults
}

M.Vim = {
  name  = 'vimls',
  ft    = 'vim',
  setup = use_defaults,
}

M.Lua = {
  name  = 'sumneko_lua',
  ft    = 'lua',
  setup = function(server, settings, override)
    -- Globally enable Neovim support
    require('lua-dev').setup(override({
      override = function(_, o)
        o.enabled = true
        o.runtime = true
        o.types   = true
        o.plugins = true
      end
    }))

    server.setup(settings)
  end,
}

M.Rust = {
  name  = 'rust_analyzer',
  ft    = 'rust',
  setup = function(_, settings, override)
    -- github.com/simrat39/rust-tools.nvim#configuration
    local options = {
      crate_graph = false,
      server = settings,
    }

    require('rust-tools').setup(override(options))
  end,
}

M.Go = {
  name  = 'gopls',
  ft    = { 'go', 'gomod', 'gowork', 'gotmpl' },
  setup = use_defaults,
}

M.Awk = {
  name  = 'awk_ls',
  ft    = 'awk',
  setup = use_defaults,
}

M.Bash = {
  name  = 'bashls',
  ft    = { 'sh', 'bash' },
  setup = use_defaults,
}

M.C = {
  name  = 'clangd',
  ft    = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  setup = use_defaults,
}

M.CXX = M.C

M.CMake = {
  name  = 'cmake',
  ft    = 'cmake',
  setup = use_defaults,
}

M.CSS = {
  name  = 'cssls',
  ft    = { 'css', 'scss', 'less' },
  setup = use_defaults,
}

M.DockerFile = {
  name  = 'dockerls',
  ft    = 'dockerfile',
  setup = use_defaults,
}

M.Elixir = {
  name  = 'elixirls',
  ft    = { 'elixir', 'eelixir', 'heex' },
  setup = use_defaults,
}

M.GraphQL = {
  name  = 'graphql',
  ft    = { 'graphql', 'typescriptreact', 'javascriptreact' },
  setup = use_defaults,
}

M.HTML = {
  name  = 'html',
  ft    = 'html',
  setup = use_defaults,
}

M.JavaScript = {
  name  = 'tsserver',
  ft    = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  setup = use_defaults,
}

M.Jsonnet = {
  name  = 'jsonnet_ls',
  ft    = { 'jsonnet', 'libsonnet' },
  setup = use_defaults,
}

M.Markdown = {
  name  = 'marksman',
  ft    = 'markdown',
  setup = use_defaults,
}

M.Perl = {
  name  = 'perlnavigator',
  ft    = 'perl',
  setup = use_defaults,
}

M.PHP = {
  name  = 'phpactor',
  ft    = 'php',
  setup = use_defaults,
}

M.Python = {
  name  = 'pyright',
  ft    = 'python',
  setup = use_defaults,
}

M.Ruby = {
  name  = 'solargraph',
  ft    = 'ruby',
  setup = use_defaults,
}

-- Note this LS *requires* configuration parameters for connecting to the database
-- By default we try to look for standard Postgres / MySQL / SQLite env vars, but you'll
-- likely to need to configure this yourself.
M.SQL = {
  name  = 'sqls',
  ft    = { 'sql', 'mysql' },
  setup = function(server, settings, override)
    local e = vim.env

    local postgres = {
      alias = e.PGAPPNAME,  user = e.PGUSER,  passwd = e.PGPASSWORD,
      host = e.PGHOST,      port = e.PGPORT,  dbName = e.PGDATABASE,
      -- Can be either a URI (postgres://) or DSN style ('host=... port=... user=...')
      -- and takes precedence over all over values.
      -- See www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING
      dataSourceName = e.PGCONN,
    }
    if vim.tbl_isempty(postgres) then postgres = nil end

    local mysql = {
      alias = e.DBI_USER,   user = e.DBI_USER,  passwd = e.MYSQL_PWD,
      host = e.MYSQL_HOST,  dbName = e.MYSQL_DATABASE,
      port = e.MYSQL_TCP_PORT or e.MYSQL_UNIX_PORT,

      -- Expected format: [username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]
      -- See github.com/go-sql-driver/mysql#dsn-data-source-name
      dataSourceName = e.DBI_DSN,
    }
    if vim.tbl_isempty(mysql) then mysql = nil end

    local sqlite = {
      -- Expected format: file:<database.db>[?param=value&...]
      -- See github.com/mattn/go-sqlite3#connection-string
      dataSourceName = e.SQLITE3_DSN
    }
    if vim.tbl_isempty(sqlite) then sqlite = nil end

    local env = (postgres or mysql or sqlite)
      and { settings = { sqls = { connections = { postgres, mysql, sqlite } } } }
      or {}

    server.setup(override(vim.tbl_deep_extend('keep', env, settings)))
  end,
}

M.Toml = {
  name  = 'taplo',
  ft    = 'toml',
  setup = use_defaults,
}

M.Terraform = {
  name  = 'terraformls',
  ft    = 'terraform',
  setup = use_defaults,
}

M.TypeScript = M.JavaScript

M.TailwindCSS = {
  name  = 'tailwindcss',
  ft    = {
    'aspnetcorerazor' , 'astro'    , 'astro-markdown' , 'blade'           , 'django-html'     ,
    'htmldjango'      , 'edge'     , 'eelixir'        , 'elixir'          , 'ejs'             ,
    'erb'             , 'eruby'    , 'gohtml'         , 'haml'            , 'handlebars'      ,
    'hbs'             , 'html'     , 'html-eex'       , 'heex'            , 'jade'            ,
    'leaf'            , 'liquid'   , 'markdown'       , 'mdx'             , 'mustache'        ,
    'njk'             , 'nunjucks' , 'php'            , 'razor'           , 'slim'            ,
    'twig'            , 'css'      , 'less'           , 'postcss'         , 'sass'            ,
    'scss'            , 'stylus'   , 'sugarss'        , 'javascript'      , 'javascriptreact' ,
    'reason'          , 'rescript' , 'typescript'     , 'typescriptreact' , 'vue'             ,
    'svelte'
  },
  setup = use_defaults,
}

M.XML = {
  name  = 'lemminx',
  ft    = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
  setup = use_defaults,
}

return M
