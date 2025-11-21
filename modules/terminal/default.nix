{
  extraConfigLua = ''
    --[[
      Alt + h , j , k , l ist faster than the
      default ctrl + \\  <as in blackslash> AND  CTRL + N
      at the same time ... gymnastics (esp on workman keyboard layout)
      where its j + \\ + ctrl which is ridiculously uncfortable and easy to screw up
    ]]

    vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-w>h', { noremap = true })
    vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-w>j', { noremap = true })
    vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-w>k', { noremap = true })
    vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w>l', { noremap = true })

    --[[
      exiting a terminal , eg to use visual mode on it also is anything BUT
      ergonomic so this mapping enables you to just hit Esc to achieve the same
      and very quickly go from TERMINAL (which is like  term:// 's insert mod)  to normal mode
    ]]
    vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { noremap = true })
  '';
}
