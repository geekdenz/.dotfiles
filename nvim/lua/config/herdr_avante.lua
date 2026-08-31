local M = {}

local agent = "avante"
local source = "avante.nvim"
local metadata_source = source .. ":metadata"
local sequence = 0
local streaming_wrapped = false
local provider_switching_wrapped = false

local provider_labels = {
  codex = "Codex ACP",
  cursor = "Cursor ACP",
}

local function is_available()
  return vim.env.HERDR_ENV == "1"
    and vim.env.HERDR_PANE_ID ~= nil
    and vim.env.HERDR_PANE_ID ~= ""
    and vim.fn.executable("herdr") == 1
end

local function run(args, callback)
  vim.system(vim.list_extend({ "herdr", "pane" }, args), { text = true }, function(result)
    if callback then vim.schedule(function() callback(result) end) end
  end)
end

local function current_provider(provider)
  if provider then return provider end

  local ok, config = pcall(require, "avante.config")
  if ok then return config.provider end

  return "unknown"
end

function M.report(state, provider)
  if not is_available() then return end

  sequence = sequence + 1
  local report_sequence = tostring(sequence)
  local pane = vim.env.HERDR_PANE_ID
  local provider_name = current_provider(provider)
  local provider_label = provider_labels[provider_name] or provider_name

  run({
    "report-agent",
    pane,
    "--source",
    source,
    "--agent",
    agent,
    "--state",
    state,
    "--message",
    provider_label,
    "--seq",
    report_sequence,
  }, function()
    run({
      "report-metadata",
      pane,
      "--source",
      metadata_source,
      "--agent",
      agent,
      "--applies-to-source",
      source,
      "--display-agent",
      "Avante",
      "--token",
      "provider=" .. provider_label,
      "--seq",
      report_sequence,
    })
  end)
end

local function release()
  if not is_available() then return end

  sequence = sequence + 1
  vim.system({
    "herdr",
    "pane",
    "release-agent",
    vim.env.HERDR_PANE_ID,
    "--source",
    source,
    "--agent",
    agent,
    "--seq",
    tostring(sequence),
  }, { text = true }):wait(500)
end

local function wrap_streaming()
  local llm = require("avante.llm")
  if streaming_wrapped then return end

  local original_stream = llm.stream
  llm.stream = function(opts)
    M.report("working")

    local original_on_stop = opts.on_stop
    opts.on_stop = function(...)
      M.report("idle")
      if original_on_stop then return original_on_stop(...) end
    end

    local ok, result = pcall(original_stream, opts)
    if not ok then
      M.report("idle")
      error(result)
    end
    return result
  end

  streaming_wrapped = true
end

local function wrap_provider_switching()
  local api = require("avante.api")
  if provider_switching_wrapped then return end

  local original_switch_provider = api.switch_provider
  api.switch_provider = function(target)
    local result = original_switch_provider(target)
    M.report("idle", target)
    return result
  end

  provider_switching_wrapped = true
end

function M.setup()
  if not is_available() then return end

  wrap_streaming()
  wrap_provider_switching()

  local group = vim.api.nvim_create_augroup("HerdrAvante", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = release,
    desc = "Release Avante agent state from Herdr",
  })

  M.report("idle")
end

return M
