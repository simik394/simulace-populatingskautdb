let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Obsi/Prods/04-škola/_out/simulace-simsys
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +44 simulace-nobatch.jl
badd +1421 term://~/Obsi/Prods/04-škola/_out/simulace-simsys//67749:/bin/bash
badd +1 simulation.log
badd +3 qruna.sh
badd +1 ~/.config/nvim_m01/lua/custom/plugins/fugitive.lua
argglobal
%argdel
$argadd simulace-nobatch.jl
set stal=2
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit simulace-nobatch.jl
argglobal
balt ~/.config/nvim_m01/lua/custom/plugins/fugitive.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 44 - ((10 * winheight(0) + 22) / 44)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 44
normal! 037|
tabnext
argglobal
if bufexists(fnamemodify("term://~/Obsi/Prods/04-škola/_out/simulace-simsys//67749:/bin/bash", ":p")) | buffer term://~/Obsi/Prods/04-škola/_out/simulace-simsys//67749:/bin/bash | else | edit term://~/Obsi/Prods/04-škola/_out/simulace-simsys//67749:/bin/bash | endif
if &buftype ==# 'terminal'
  silent file term://~/Obsi/Prods/04-škola/_out/simulace-simsys//67749:/bin/bash
endif
balt simulace-nobatch.jl
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1421 - ((43 * winheight(0) + 22) / 44)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1421
normal! 057|
tabnext
edit qruna.sh
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 3 - ((2 * winheight(0) + 22) / 44)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 3
normal! 040|
lcd ~/Obsi/Prods/04-škola/_out/simulace-simsys
tabnext 1
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
