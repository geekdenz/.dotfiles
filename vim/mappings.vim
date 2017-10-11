"===============================================================================
" Mappings
"===============================================================================

" tags
nnoremap <f4> :! ctags <cr>

" rm file
nnoremap <leader>rm :! rm %<cr>

" escape alias
inoremap jj <esc>
inoremap jJ <esc>
inoremap Jj <esc>
inoremap JJ <esc>
nnoremap <tab> gt
nnoremap <s-tab> gT

" navigation
noremap <leader>j 10j
noremap <leader>k 10k

" buffer changing
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bp :bp<cr>

" closes buffer
nnoremap <leader>bd :bd<cr>
nnoremap <leader>bdd :bd!<cr>
nnoremap <leader>bda :bufdo %bd!<cr>
nnoremap <leader>n :NERDTree<cr>

" search
nnoremap <leader>ag :Ag! '<left>'

" * and # search for next/previous of selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" * and # search for next/previous of selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>
vnoremap <leader>ag y:Ag! '<C-R>"'
nnoremap <leader>lag :Ag<up><cr>

" saves from normal mode
nnoremap <c-s> :w<cr>
nnoremap <c-S> :w<cr>

" saves and exits insert mode
inoremap ,s <ESC>:w<cr>
inoremap ,S <ESC>:w<cr>

" Select all
nnoremap <leader>a ggVG

" new tab
nnoremap <c-w>t :tabnew<cr>

" jumps to the next position after the closest closing char
inoremap ,e <Esc>/[\]})"']<cr><Esc>:nohlsearch<cr>a

" adds arrow
inoremap <C-l> <Space>=><Space>,<left>

" Ruby old style hashes to new style hashes
vnoremap <leader>h :s/:\(\w*\) *=>/\1:/g<cr>

" Rails specific
" nnoremap <Leader>ac :sp app/controllers/application_controller.rb<cr>
vnoremap <leader>h :s/\:\([a-zA-Z_]\+\)\s\+=>/\=printf("%s:", submatch(1))/g<CR><ESC>:let @/ = ""<CR>
nnoremap <Leader>quit <ESC>:q<cr>

" reload buffer
nnoremap <Leader>rel :e<CR>

" Open vim rc
nnoremap <Leader>vimi :vsplit ~/.vimrc<CR>
nnoremap <Leader>vima :vsplit ~/.vim/abbreviations.vim<CR>
nnoremap <Leader>vimf :vsplit ~/.vim/functions.vim<CR>
nnoremap <Leader>vimm :vsplit ~/.vim/mappings.vim<CR>
nnoremap <Leader>vimp :vsplit ~/.vim/plugins.vim<CR>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Easy Motion (easymotion)
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" /easymotion


" vundle
nnoremap <Leader>bi :BundleInstall<cr>
nnoremap <Leader>bu :BundleUpdate<cr>
nnoremap <Leader>bc :BundleClean<cr>

" Fix anoying original K
nnoremap K <nop>
nnoremap U <nop>

" Find
nnoremap <leader>f <ESC>/

" convert file to latin1 and reloads
nnoremap <leader>lat1 :write ++enc=latin1<cr>:e<cr>

" Use Q for formatting the current paragraph (or selection)
vnoremap Q gq
nnoremap Q gqap

" clear search
nnoremap <silent> <leader>F :nohlsearch<CR>

" Avoid arrow keys in command mode
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>
cnoremap <C-x> <del>

" Control Ctrl and Ctrl V
vnoremap <C-c> "+y
vnoremap <leader>c "+y
inoremap <C-v> <esc>:set paste<cr>"+p:set nopaste<cr>i
nnoremap <leader>v :set paste<cr>"+p:set nopaste<cr>i

" buffer resizing mappings (shift + arrow key)
nnoremap <Up> <c-w>+
nnoremap <Down> <c-w>-
nnoremap <Left> <c-w><
nnoremap <Right> <c-w>>

" Trim all trailing whitespaces no questions asked.
nnoremap <leader>wt :call TrimWhiteSpace()<cr>

" quotes
" Single quote word
nnoremap <leader>sq ciw''<esc><left>p
" double quote word
nnoremap <leader>dq ciw""<esc><left>p

" Execute last command over a visual selection
vnoremap . :norm.<CR>

" Resolving conflics
" Vimcasts #33
nnoremap <leader>gd :Gdiff<cr>
" get target version: diff get target
nnoremap <leader>dgt :diffget //2 \| :diffupdate<cr>
" get branch version: diff get branch
nnoremap <leader>dgb :diffget //3 \| :diffupdate<cr>
nnoremap <leader>gcom :G checkout master<cr>

" quotes
nnoremap <leader>qw ciw''<esc>P
nnoremap <leader>qw ciw""<esc>P

" sort block
nnoremap <leader>sb vip:sort<cr>
nnoremap <leader>sa vi(:sort<cr>

" wrap selection inside caracter
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
vnoremap " "zdi"<C-R>z"<ESC>

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" offers to create/edit a tmp file
nnoremap <leader>et :vs ~/.tmp/

"===============================================================================
" Language specific
"===============================================================================
inoremap ć ç
inoremap Ć Ç
inoremap ,a â
inoremap ,A Â

"===============================================================================
" PHP
"===============================================================================

autocmd FileType php nnoremap <buffer> <leader>x <esc>:! clear && time php %<cr>
autocmd FileType php nnoremap <buffer> <leader>ce <esc>:vsplit curl.sh<cr>
autocmd FileType php nnoremap <buffer> <leader>cu <esc>:! clear && ./curl.sh<cr>
autocmd FileType php nnoremap <buffer> <leader>st <esc>:! clear && ./shell_test.sh<cr>
" autocmd FileType php nnoremap <buffer> <leader>t <esc>:call PHPUnitCurrentFile()<cr>
" autocmd FileType php nnoremap <buffer> <leader>at <esc>:call PHPUnitAll()<cr>
" autocmd FileType php nnoremap <buffer> <leader>nt <esc>:call PHPUnitFocused()<cr>
" autocmd FileType php nnoremap <buffer> <leader>mt <esc>:call PHPUnitZendModule()<cr>
autocmd FileType php nnoremap <buffer> <leader>av <esc>:call PHPOpenVAlternativeFile()<cr>

" php cs fixer
autocmd FileType php nnoremap <leader>cs  :call PhpFixCs('%')<cr>
autocmd FileType php nnoremap <leader>dcs :call PhpFixCs('.')<cr>

autocmd FileType php inoremap <buffer> <C-.> .
autocmd FileType php inoremap <buffer> ... ../
autocmd FileType php inoremap <buffer> .. ->
"autocmd FileType php inoremap <buffer> .a ->a
"autocmd FileType php inoremap <buffer> .b ->b
"autocmd FileType php inoremap <buffer> .c ->c
"autocmd FileType php inoremap <buffer> .d ->d
"autocmd FileType php inoremap <buffer> .e ->e
"autocmd FileType php inoremap <buffer> .f ->f
"autocmd FileType php inoremap <buffer> .g ->g
"autocmd FileType php inoremap <buffer> .h ->h
"autocmd FileType php inoremap <buffer> .i ->i
"autocmd FileType php inoremap <buffer> .j ->j
"autocmd FileType php inoremap <buffer> .k ->k
"autocmd FileType php inoremap <buffer> .l ->l
"autocmd FileType php inoremap <buffer> .m ->m
"autocmd FileType php inoremap <buffer> .n ->n
"autocmd FileType php inoremap <buffer> .o ->o
"autocmd FileType php inoremap <buffer> .p ->p
"autocmd FileType php inoremap <buffer> .q ->q
"autocmd FileType php inoremap <buffer> .r ->r
"autocmd FileType php inoremap <buffer> .s ->s
"autocmd FileType php inoremap <buffer> .t ->t
"autocmd FileType php inoremap <buffer> .u ->u
"autocmd FileType php inoremap <buffer> .v ->v
"autocmd FileType php inoremap <buffer> .x ->x
"autocmd FileType php inoremap <buffer> .v ->v
"autocmd FileType php inoremap <buffer> .y ->y
"autocmd FileType php inoremap <buffer> .w ->w
"autocmd FileType php inoremap <buffer> .z ->z
"autocmd FileType php inoremap <buffer> ._ ->_
"autocmd FileType php inoremap <buffer> ;; <esc>$a;

"===============================================================================
" Ruby
"===============================================================================

autocmd FileType ruby nnoremap <buffer> <leader>x <esc>:! clear && time ruby %<cr>
autocmd FileType ruby nnoremap <buffer> <leader><leader>ct <esc>:call SetChefTest()<cr>

"===============================================================================
" Javascript
"===============================================================================

" execute jasmine tests
" autocmd FileType javascript nnoremap <buffer> <leader>t :! clear && grunt jasmine --filter<C-R>=expand("%:t:r")<cr><cr>

autocmd FileType javascript nnoremap <leader>cs :! jscs % --fix<cr>

"===============================================================================
" C
"===============================================================================

autocmd FileType c nnoremap <buffer> <leader>x <esc>:call CompileAndRunCurrentCFile()<cr>

"===============================================================================
" BASH
"===============================================================================

autocmd FileType sh nnoremap <buffer> <leader>x <esc>:! clear && ./%<cr>
" Unmap the arrow keys
no <down> ddp
no <left> <Nop>
no <right> <Nop>
no <up> ddkP
ino <down> <Nop>
ino <left> <Nop>
ino <right> <Nop>
ino <up> <Nop>
vno <down> <Nop>
vno <left> <Nop>
vno <right> <Nop>
vno <up> <Nop>

"============== Custom Mappings ===============
" general mapping
nmap <C-Tab> :tabnext<CR>
nmap <C-S-Tab> :tabprevious<CR>
map <C-S-Tab> :tabprevious<CR>
map <C-Tab> :tabnext<CR>
imap <C-S-Tab> <ESC>:tabprevious<CR>
imap <C-Tab> <ESC>:tabnext<CR>
noremap <F7> :set expandtab!<CR>
nmap <Leader>h :tabnew %:h<CR>

"turn off search highlighting
"nmap <C-n> :noh<CR>

"custom comma motion mapping
nmap di, f,dT,
nmap ci, f,cT,
nmap ci< f<cT>
nmap ci> f<cT>
nmap da, f,ld2F,i,<ESC>l "delete argument 
nmap ca, f,ld2F,i,<ESC>a "delete arg and insert

" delete surrounding characters
noremap ds{ F{xf}x
noremap cs{ F{xf}xi
noremap ds" F"x,x
noremap cs" F"x,xi
noremap ds' F'x,x
noremap cs' F'x,xi
noremap ds( F(xf)x
noremap cs( F(xf)xi
noremap ds) F(xf)x
noremap cs) F(xf)xi

" surround with characters
noremap <Leader>sw' ea'bi'
noremap <Leader>sw" ea"bi"
noremap <Leader>sw{ ea{bi}
noremap <Leader>sw( ea(bi)
" inoremap console.log()<tab)console.log()

nmap cu ct_
nmap cU cf_

" upper or lowercase the current word
nmap g^ gUiW
nmap gv guiW

" diff
nmap ]c ]czz
nmap [c [czz

" default to very magic
no / /\v

" gO to create a new line below cursor in normal mode
nmap g<C-O> o<ESC>k
" g<Ctrl+o> to create a new line above cursor (Ctrl to prevent collision with 'go' command)
nmap gO O<ESC>j

"I really hate that things don't auto-center
nmap G Gzz
nmap n nzz
nmap N Nzz
nmap } }zz
nmap { {zz

"open tag in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"quick pairs
imap <leader>' ''<ESC>i
imap <leader>" ""<ESC>i
imap <leader>( ()<ESC>i
imap <leader>[ []<ESC>i

" replace string contents with recently copied text
nmap <Leader>r" "_di"P
nmap <Leader>c" "_di"Pa
nmap <Leader>r' '_di'P
nmap <Leader>c' '_di'Pa

autocmd FileType twig imap <leader>a[ [{[  ]}]<ESC>Bhi

nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

autocmd FileType java setlocal omnifunc=javacomplete#Complete
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
