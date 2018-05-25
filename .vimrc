syn on

set tabstop=4
set shiftwidth=4
"set expandtab "tab is space
"set smarttab
set cindent
set autoindent

set fileformats=unix,dos
set fileencodings=utf-8

""cscop relate
set nocst    "do not use cscope database for tag search
set nocsverb "do not print cscope vorbos message ex) database add message

set hlsearch
"set nohlsearch   
set incsearch
set autowrite
set nostartofline
set showmatch

"set backup
"set backupdir=~/.vim/backup

"comment 
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " disable auto comment

"miniBufExpl
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 
map <S-l> :bn<CR>
map <S-h> :bp<CR>

"When editing a file, always jump to the last known cursor position
"Don't do it when the position is invalid or when inside an event handler
"" (happeds when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\	exe "normal g`\"" |	
	\ endif

"set formatoption=tcroq
set formatoptions=croql

if has("gui_running")
	"set textwidth=80
	set guioptions-=T "remove Toolbar
	set guioptions+=b
	"set guioptions-=m "remove memu bar
	"set guioptions+=b "bottom scroll bar 
	"set nowrap 

	set gfn=Courier\ New:h10
	map <A-SPACE> :simalt~x <CR>
	map <C-SPACE> :simalt~r <CR>

	winp 0 0
	win 80 60
	set scrolloff=3
endif

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

function SetProject()
	let core = '/projects/GPS_KR_DEV1/P4_home/byungseok/client/core/'
	let allPartners='/allPartners/deliverables'
	let deliverables='/proprietary/deliverables'
	let sharedCode='/customers/samsung/shared_code'

	let rels = ['dev/v10', 'rel/Samsung/Zero/Zero_19.CLU3.CLL5.4_22.19.16.234678', 'rel/Samsung/V/V_19.CLU3.CLL5.4_22.19.19.257460']
	for rel in rels
		let project = [core.rel.allPartners, core.rel.deliverables, core.rel.sharedCode]
		let ret = TagsScope#set(project)
		if ret == 1 
			break
		endif
	endfor
endfunction

call SetProject()

" NERDTree
let g:NERDTreeWinPos = "right"
" Open and close all the three plugins on the same time 
nmap <F7>  :NERDTree<CR>

nmap <silent>  ;=  :call AlignAssignments()<CR>

" comment one line "
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>


" C syntex rule -----------------------------------------------------
let c_gnu                  =1
let c_space_errors         =1
let c_no_trail_space_error =1
"let c_comment_strings     =1
let c_ansi_typedefs        =1
let c_ansi_constants       =1

" curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" PlugInstall, PlugUpdate, ...
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/seoul256.vim'
Plug 'scrooloose/nerdtree'
Plug 'francoiscabrol/ranger.vim'
"Plug 'skywind3000/vim-preview' " requirement : ctags --fields=+nS
call plug#end()

let g:seoul256_background = 233
colo seoul256
"colo elflord
let g:airline_powerline_fonts = 1

