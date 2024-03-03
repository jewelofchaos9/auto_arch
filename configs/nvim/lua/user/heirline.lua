local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = { bg = "#F6F8FA" }
}

local WinBarFileName = {
  init = function(self)
    self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  
    self.bg = "#F6F8FA"
    self.fg = "#000000"
    if self.filename == "NvimTree_1" then
      self.fg = "#F6F8FA"
    end
  end,
  provider = function(self)
    return self.filename
  end,
  hl = function(self)
      return { bg = self.bg, fg = self.fg }
  end
}

local FileName = {
  provider = function(self)
  local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then return "[No Name]" end

    if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
    end
    return " " .. filename .. " "
  end,
}

FileNameBlock = utils.insert(FileNameBlock,
    FileName,
    { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
)

local Fill = {
  provider = "%=",
}

local StatusLineFill = {
  Fill,
  hl = {
    bg = "#F6F8FA",
    fg = "#F6F8FA"
  }
}

local ViModeBg = {
  static = {
    mode_colors = {
      n = "#acbcc3",
      i = "#673ab7",
      v = "cyan",
      V =  "cyan",
      ["\22"] =  "cyan",
      c =  "#ffab91",
      s =  "purple",
      S =  "purple",
      ["\19"] =  "purple",
      R =  "orange",
      r =  "orange",
      ["!"] =  "red",
      t =  "red",
    },
  },

  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return { fg = "#ffffff", bg = self.mode_colors[mode], bold = false, }
  end
}

local Diagnostics = {
  static = {
    error_icon = " ",
    warn_icon = " "
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  end,
  {
    provider = " "
  },
  {
      provider = function(self)
          return self.error_icon .. ( self.errors > 0 and self.errors or 0 ) .. " "
      end,
  },
  {
      provider = function(self)
          return self.warn_icon .. ( self.warnings > 0 and self.warnings or 0 ) .. " "
      end,
  }

}

Diagnostics = utils.insert(ViModeBg, Diagnostics)

local CurrentLine = {
    provider = "%l:%c ",
    hl = { fg = "#90a4ae", bg = "#F6F8FA" }
}
--[[ CurrentLine = utils.insert(ViModeBg, CurrentLine) ]]

local Blank = {
  provider = " "
}
local nonblank = {
  provider = "AnotherProvider"
}

local FileType = {
    provider = function()
        return string.upper(vim.bo.filetype)
    end
}
local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%L%):%2c",

}

local TablineBufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. ". "
  end
}

local TablineFileName = {
  provider = function(self)
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return filename
  end,
  hl = function(self)
    if self.is_active then
      return { bg = "#ACBCC3", fg = "#FFFFFF" }
    end
    return { bg = "#F6F8FA" }
    --[[ return { bg = "#FF82FF", fg = "#000000", bold = self.is_active or self.is_visible } ]]
  end
}
local TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return "TabLineSel"
    end
    return "TabLine"
  end,
  TablineFileName
}

local TablineBufferBlock = utils.surround({ "█", "█" }, function(self)
    if self.is_active then
      return "#acbcc3"
    else
      return "#F6F8FA"
    end
end, { TablineFileNameBlock })

local BufferLine = utils.make_buflist(
  TablineBufferBlock,
  { provider = "", hl = { fg = "gray" } }, 
  { provider = "", hl = { fg = "gray" } }
)

require("heirline").setup({
  statusline = { Diagnostics, StatusLineFill, CurrentLine },
  tabline = { BufferLine },
})
-- winbar = { StatusLineFill, WinBarFileName },
