let mapleader='\'
lang en_GB.UTF-8

set nocompatible
filetype plugin on
filetype indent on

set title " change title-bar of xterm
set vb t_vb=
set noerrorbells
set showcmd
autocmd GUIEnter * set vb t_vb=
set backupdir=~/tmp/vim-backup,~/.tmp,/var/tmp/vim,/var/tmp,/tmp,.
set directory=~/tmp/vim-backup,~/.tmp,/var/tmp/vim,/var/tmp,/tmp,.

set backspace=2
set autoindent
set nosmartindent
set showmatch
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4
set scrolloff=3
set hlsearch
set incsearch
set spelllang=pl,en
set hidden " multiple buffers at once
set nowrap

syn sync fromstart

set foldlevel=100

command! TrailingWS %s/\s\+$//

set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
set guioptions=grL
set cursorline
set ruler
set number
syntax on
colorscheme zmrok
hi Cursor  guifg=Black guibg=Green gui=none
hi link pythonBuiltin Constant
" uncomment for wombat
"colorscheme wombat
"hi Normal  guifg=#f6f3e8 guibg=#202020 gui=none
"hi String  guifg=#95e454 gui=none
"hi Special guifg=#f6f3b8

let html_use_css=1
let cursor_follows_alphabet=1
map <F1> <F2>

inoremap <c-b> ()<Left>
inoremap <c-l> <Right>

inoremap <s-cr> <C-o>o
inoremap <s-c-cr> <C-o>O
nnoremap <c-space> :noh<CR>
inoremap <c-space> <c-x><c-o>

vmap <C-s> <Plug>Vsurround
vmap <C-S> <Plug>VSurround
nmap <C-s> <Plug>Ysurround

nnoremap <Leader>v "+p
vnoremap <Leader>c "+y
vnoremap <Leader>x "+d

set selection=exclusive

" Mental sanity
nmap Y y$
nmap cw dwi
for i in range(1, 9)
    exec 'nmap c'.i.'w ' . ' d'.i.'wi'
    exec 'nmap g'.i.'s '.i.'gs'
    exec 'nmap g'.i.'S '.i.'gS'
endfor

" Vrapper compatibility
nnoremap <M-Up> "rddk"rP
nnoremap <M-Down> "rdd"rp
inoremap <M-Up> <Esc>"rddk"rPa
inoremap <M-Down> <Esc>"rdd"rpa
inoremap <A-/> <C-p>

command! PyEvalStr    python py_eval_reg(str)
command! PyEvalRepr   python py_eval_reg(repr)
command! PyEvalStrLn  python py_eval_reg(str, '\n')
command! PyEvalReprLn python py_eval_reg(repr, '\n')


fun! MakeExecutable()
    set autoread
    silent !chmod +x %
    set autoread<
endfun

command! MakeExecutable call MakeExecutable()

" basic imports
python << EOPYTHON
import vim
import sys, os
sys.path.append(os.environ['HOME'] + '/.vim/python')
EOPYTHON

" utility functions
python << EOPYTHON
def dq_escape(string):
    return string.replace('\\', r'\\').replace('"', r'\"')
def sq_escape(string):
    return string.replace('\\', r'\\').replace("'", r"\'")
EOPYTHON

python << EOPYTHON
def vim_re_escape(text):
    for bit in ['\\', '$', '.', '[', ']', '^', '*', '~']:
        text = text.replace(bit, '\\' + bit)
    return text

try:
    import REgen
    REgen.GLOB_REPR = '\(.*\)'
    REgen.escape = vim_re_escape

    def loreto(prefix):
        lines = vim.eval('getreg("r")').rstrip().split('\n')
        globs = REgen.generate(*lines)
        before = globs.as_re()
        after = globs.as_backref().replace(r'\ ', ' ').replace(r'\,', ',')
        subst = prefix + "s/%s/%s/g" % (before.replace('/', r'\/'), after.replace('/', r'\/'))
        vim.eval('setreg("r", "%s")' % dq_escape(subst))
except:
    pass
EOPYTHON

nnoremap <Leader>r "ryj:python loreto('%')<CR>q:"rp02f/l
vnoremap <Leader>r "ry:python loreto("'<,'>")<CR>q:"rp02f/l

" py_eval_reg
python << EOPYTHON
def py_eval_reg(encoding, trailer='', mode='eval'):
    register = vim.eval('@@')
    code = compile(register.lstrip(), '\" register', mode)
    result = eval(code)
    output = repr(encoding(result))[1:-1] + trailer
    vim.command('let @@="%s"' % dq_escape(output))
EOPYTHON

" split and turn into python-style list
nnoremap <Leader>l dd:let @@=string(split(substitute(@@, '\n', '', ''), '\s\+')).substitute('!', '!', '\n', '')<CR>P

vnoremap <Leader>er x:PyEvalRepr<CR>P
vnoremap <Leader>es x:PyEvalStr<CR>P
nnoremap <Leader>er :PyEvalRepr<CR>
nnoremap <Leader>es :PyEvalStr<CR>
nnoremap <Leader>eR :PyEvalReprLn<CR>
nnoremap <Leader>eS :PyEvalStrLn<CR>
nnoremap <Leader>ex dd:PyEvalStrLn<CR>P
nnoremap <Leader>eX dd:PyEvalReprLn<CR>P
nnoremap <Leader>ee ddP:PyEvalStrLn<CR>p
nnoremap <Leader>eE ddP:PyEvalReprLn<CR>p

autocmd FileType gitconfig     set noexpandtab
autocmd FileType tags,automake,makefile set noexpandtab
autocmd FileType tags,automake,makefile set tabstop=8
autocmd FileType tags,automake,makefile set softtabstop=8
autocmd FileType tags,automake,makefile set shiftwidth=8

autocmd BufRead,BufNewFile *.jinja set filetype=htmldjango
autocmd BufRead,BufNewFile *.dtl set filetype=htmldjango
autocmd BufRead,BufNewFile DESIGN set filetype=asciidoc
autocmd BufRead,BufNewFile rebar.config set filetype=erlang
autocmd BufRead,BufNewFile *.app,*.app.src set filetype=erlang

autocmd FileType html,asciidoc,tex set spell

map <F1> <Esc>
map <F2> :source ~/.vimrc<Esc>
nmap <F3> "zyiw:execute "grep -- \"\\b" . @z . "\\b\""<CR>
command! TuneMySettings split ~/.vimrc

iabbr #!E # coding: <C-r>=&encoding<Cr>
iabbr ##I #ifndef __<C-r>=substitute(expand('%'), '\W', '_', 'g')<CR>__<Esc>BgU$"xy$o#define <C-o>"xp<Cr><Cr><Esc>"xpgccI#endif <C-CR><Esc>kkO

set grepprg=ack-grep
command! GlobalSearch execute "grep \"" . substitute(@/, '"', '\\"', "g") . "\""
command! -nargs=? VimGrepSearch execute "vimgrep /" . substitute(@/, '"', '\\"', "g") . "/ **/*<args>"

command! UseRebar set makeprg=./rebar\ compile\ skip_deps=true

fun! TagsAndStuff()
    !./gen_tags &
    FuzzyFinderRemoveCache
    return ''
endfun

nmap <F5> :make<CR>
nmap <F6> :copen<CR>
nmap <F7> :cclose<CR>
nmap <F8> :cp<CR>
nmap <F9> :cn<CR>
nmap <F12> :call TagsAndStuff()<CR><CR>
imap <F12> <C-r>=TagsAndStuff()<CR><CR>

nmap <C-S-N> :tn<CR>
nmap <C-S-P> :tp<CR>

" Python

let g:pysmell_matcher='camel-case-sensitive'
autocmd FileType python setlocal omnifunc=pysmell#Complete

let python_highlight_numbers = 1
let python_highlight_builtins = 1
let python_highlight_exceptions = 1
let python_highlight_space_errors = 1

nmap <Leader>b :FufBuffer<CR>
nmap <Leader>f :FufFile<CR>
nmap <Leader>c :FufQuickfix<CR>
nmap <Leader>t :FufTag<CR>
vmap <Leader>g y:Cprint <C-r>"<CR>
nmap <Leader>g y:Cprint <C-r>=expand('<cword>')<CR><CR>
nmap <Leader><S-F><S-R> :FufRenewCache<CR>

autocmd filetype tex,latex inoremap <C-a> \item
let g:haddock_browser="firefox"
let g:translit_map='planslit'
let g:translit_toggle_keymap='<C-q>'
set keywordprg=/home/goj/bin/gterman
let g:ropevim_vim_completion = 1
let g:ropevim_autoimport_modules = ['os', 'sys', 'math']

" trailing whitespace stolen from Kamil Dworakowski
highlight BadWhitespace guibg=#300000
au ColorScheme * highlight ExtraWhitespace guibg=#300000
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufEnter * match MixTabsAndSpaces /^[ ]\+\t\+/
au BufEnter * match MixTabsAndSpaces /^\t\+[ ]\+/
au filetype erlang,python match BadTabIndentation /^[ ]*\t\+/
au filetype erlang inoremap <buffer> <C-z> <<>><Left><Left>
au filetype erlang inoremap <buffer> <S-C-z> <<"">><Left><Left><Left>
au filetype erlang inoremap <buffer> <C-CR> <CR>%<Space>
au filetype erlang set tabstop=8
au filetype erlang set softtabstop=8
highlight link ExtraWhitespace BadWhitespace
highlight link BadTabIndentation BadWhitespace
highlight link MixTabsAndSpaces BadWhitespace

if executable('gotags')
    autocmd BufWrite *.go execute ":silent !gotags **/*.go > tags"
endif

call pathogen#runtime_append_all_bundles()
autocmd BufNewFile,BufRead *.coco set filetype=coffee
