local api = vim.api
local fn = vim.fn

local augroup = api.nvim_create_augroup('AsciiDocPreview', { clear = true })

local config = {
  convert_cmd = 'asciidoctor -o %html %adoc',
  preview_cmd = 'xdg-open %html',
  refresh_interval = 2000,
}

local function get_html_path()
  return fn.expand('%:p'):gsub('%.adoc$', '.html')
end

local function convert_to_html()
  local adoc_path = fn.expand('%:p')
  local html_path = get_html_path()

  local cmd = config.convert_cmd
    :gsub('%%adoc', adoc_path)
    :gsub('%%html', html_path)

  fn.system(cmd)

  return html_path
end

local function open_preview()
  local html_path = get_html_path()
  local cmd = string.format('%s %s', config.preview_cmd, html_path)

  fn.system(cmd)
end

local refresh_timer = nil

local function start_auto_refresh()
  if refresh_timer then
    refresh_timer:stop()
  end

  refresh_timer = vim.loop.new_timer()
  refresh_timer:start(0, config.refresh_interval, vim.schedule_wrap(function()
    if api.nvim_buf_get_option(0, 'modified') then
      api.nvim_command('write')
      convert_to_html()
    end
  end))
end

local function stop_auto_refresh()
  if refresh_timer then
    refresh_timer:stop()
    refresh_timer = nil
  end
end

api.nvim_create_user_command('AsciiDocPreviewStart', function()
  convert_to_html()
  open_preview()
  start_auto_refresh()
end, {})

api.nvim_create_user_command('AsciiDocPreviewStop', function()
  stop_auto_refresh()
end, {})

api.nvim_create_autocmd('VimLeave', {
  group = augroup,
  callback = function()
    stop_auto_refresh()
  end,
})

return {
  start_preview = function()
    convert_to_html()
    open_preview()
    start_auto_refresh()
  end,
  stop_preview = stop_auto_refresh,
  config = config
}
