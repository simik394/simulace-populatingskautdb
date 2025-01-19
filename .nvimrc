version 6.0
let s:cpo_save=&cpo
set cpo&vim
cnoremap <silent> <Plug>(TelescopeFuzzyCommandSearch) e "lua require('telescope.builtin').command_history { default_text = [=[" . escape(getcmdline(), '"') . "]=] }"
inoremap <C-W> u
inoremap <C-U> u
nnoremap  
nnoremap <NL> <NL>
nnoremap  
nnoremap  
nmap  d
tnoremap  
nnoremap  <Cmd>nohlsearch
omap <silent> % <Plug>(MatchitOperationForward)
xmap <silent> % <Plug>(MatchitVisualForward)
nmap <silent> % <Plug>(MatchitNormalForward)
nnoremap & :&&
xnoremap <silent> <expr> @ mode() ==# 'V' ? ':normal! @'.getcharstr().'' : '@'
vnoremap H ^
nnoremap H ^
vnoremap L $
nnoremap L $
xnoremap <silent> <expr> Q mode() ==# 'V' ? ':normal! @=reg_recorded()' : 'Q'
nnoremap Y y$
omap <silent> [% <Plug>(MatchitOperationMultiBackward)
xmap <silent> [% <Plug>(MatchitVisualMultiBackward)
nmap <silent> [% <Plug>(MatchitNormalMultiBackward)
omap <silent> ]% <Plug>(MatchitOperationMultiForward)
xmap <silent> ]% <Plug>(MatchitVisualMultiForward)
nmap <silent> ]% <Plug>(MatchitNormalMultiForward)
xmap a% <Plug>(MatchitVisualTextObject)
omap <silent> g% <Plug>(MatchitOperationBackward)
xmap <silent> g% <Plug>(MatchitVisualBackward)
nmap <silent> g% <Plug>(MatchitNormalBackward)
xnoremap <silent> sa :lua MiniSurround.add('visual')
nnoremap <Plug>PlenaryTestFile :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))
xmap <silent> <Plug>(MatchitVisualTextObject) <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward)
onoremap <silent> <Plug>(MatchitOperationMultiForward) :call matchit#MultiMatch("W",  "o")
onoremap <silent> <Plug>(MatchitOperationMultiBackward) :call matchit#MultiMatch("bW", "o")
xnoremap <silent> <Plug>(MatchitVisualMultiForward) :call matchit#MultiMatch("W",  "n")m'gv``
xnoremap <silent> <Plug>(MatchitVisualMultiBackward) :call matchit#MultiMatch("bW", "n")m'gv``
nnoremap <silent> <Plug>(MatchitNormalMultiForward) :call matchit#MultiMatch("W",  "n")
nnoremap <silent> <Plug>(MatchitNormalMultiBackward) :call matchit#MultiMatch("bW", "n")
onoremap <silent> <Plug>(MatchitOperationBackward) :call matchit#Match_wrapper('',0,'o')
onoremap <silent> <Plug>(MatchitOperationForward) :call matchit#Match_wrapper('',1,'o')
xnoremap <silent> <Plug>(MatchitVisualBackward) :call matchit#Match_wrapper('',0,'v')m'gv``
xnoremap <silent> <Plug>(MatchitVisualForward) :call matchit#Match_wrapper('',1,'v'):if col("''") != col("$") | exe ":normal! m'" | endifgv``
nnoremap <silent> <Plug>(MatchitNormalBackward) :call matchit#Match_wrapper('',0,'n')
nnoremap <silent> <Plug>(MatchitNormalForward) :call matchit#Match_wrapper('',1,'n')
nnoremap <C-K> 
nnoremap <C-J> <NL>
nnoremap <C-H> 
nmap <C-W><C-D> d
nnoremap <C-L> 
inoremap  u
inoremap  u
let &cpo=s:cpo_save
unlet s:cpo_save
set clipboard=unnamedplus
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep\ -uu\ 
set helplang=en
set ignorecase
set inccommand=split
set indentkeys=0),0],!^F,o,O,e,=end,=else,=catch,=finally,),],}
set listchars=nbsp:␣,tab:»\ ,trail:·
set noloadplugins
set mouse=a
set operatorfunc=v:lua.require'vim._comment'.operator
set packpath=~/apps/nvim-linux64/share/nvim/runtime
set runtimepath=~/.config/nvim_m01,~/.local/share/nvim_m01/lazy/lazy.nvim,~/.local/share/nvim_m01/lazy/conform.nvim,~/.local/share/nvim_m01/lazy/cmp-path,~/.local/share/nvim_m01/lazy/cmp_luasnip,~/.local/share/nvim_m01/lazy/LuaSnip,~/.local/share/nvim_m01/lazy/nvim-cmp,~/.local/share/nvim_m01/lazy/telescope-ui-select.nvim,~/.local/share/nvim_m01/lazy/telescope-fzf-native.nvim,~/.local/share/nvim_m01/lazy/telescope.nvim,~/.local/share/nvim_m01/lazy/which-key.nvim,~/.local/share/nvim_m01/lazy/plenary.nvim,~/.local/share/nvim_m01/lazy/todo-comments.nvim,~/.local/share/nvim_m01/lazy/gitsigns.nvim,~/.local/share/nvim_m01/lazy/nvim-treesitter,~/.local/share/nvim_m01/lazy/nvim-dev-container,~/.local/share/nvim_m01/lazy/mini.nvim,~/.local/share/nvim_m01/lazy/cmp-nvim-lsp,~/.local/share/nvim_m01/lazy/fidget.nvim,~/.local/share/nvim_m01/lazy/mason-tool-installer.nvim,~/.local/share/nvim_m01/lazy/mason-lspconfig.nvim,~/.local/share/nvim_m01/lazy/mason.nvim,~/.local/share/nvim_m01/lazy/nvim-lspconfig,~/.local/share/nvim_m01/lazy/vim-fugitive,~/.local/share/nvim_m01/lazy/vim-sleuth,~/.local/share/nvim_m01/lazy/tokyonight.nvim,~/apps/nvim-linux64/share/nvim/runtime,~/apps/nvim-linux64/share/nvim/runtime/pack/dist/opt/matchit,~/apps/nvim-linux64/lib/nvim,~/.local/state/nvim_m01/lazy/readme,~/.local/share/nvim_m01/lazy/cmp-path/after,~/.local/share/nvim_m01/lazy/cmp_luasnip/after,~/.local/share/nvim_m01/lazy/cmp-nvim-lsp/after
set scrolloff=10
set noshowmode
set smartcase
set splitbelow
set splitright
set statusline=%{%v:lua.MiniStatusline.active()%}
set termguicolors
set timeoutlen=300
set undofile
set updatetime=250
set window=46
" vim: set ft=vim :
