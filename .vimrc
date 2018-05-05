syn on
colorscheme elflord

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

"set list "show spacial chars
""cygwin vimrc hangul 
"set encoding=cp949 

"set backup
"set backupdir=~/.vim/backup

"comment 
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " disable auto comment

let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

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

" status bar
set laststatus=2
set statusline=\(%n\)%<%f\ %h%m%r%=0x%B\ \ \ \ %-14.(%l,%c%V%)\ %P


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

function IsFileInProject(prjroot)
	"echo expand('%:p')
    if match(expand('%:p'), a:prjroot) == 0
		return 1
	else
		return 0
	endif
endfunction

function SetTagsScope(rootlist)
	if len(a:rootlist) < 1 
		return
	endif 

	let isFileInProject = 0
	for prjroot in a:rootlist
		let isFileInProject = IsFileInProject(prjroot)
		if isFileInProject == 1
			break
		endif
	endfor 

	if isFileInProject != 1
		return
	endif

	let ltags = ''
	for prjroot in a:rootlist
		"echo prjroot.'/cscope.out'
		if filereadable(prjroot.'/cscope.out') == 0
			continue
		endif

		exec "cs add" prjroot.'/cscope.out '.prjroot
		let ltags.=prjroot.'/tags,'
	endfor 

	let &tags='./tags,'.ltags
	return isFileInProject
endfunction

function SetProject()
	let core = '/projects/GPS_KR_DEV1/P4_home/byungseok/client/core/'
	let allPartners='/allPartners/deliverables'
	let deliverables='/proprietary/deliverables'
	let sharedCode='/customers/samsung/shared_code'

	let rels = ['dev/v10', 'rel/Samsung/Zero/Zero_19.CLU3.CLL5.4_22.19.16.234678', 'rel/Samsung/V/V_19.CLU3.CLL5.4_22.19.19.257460']
	for rel in rels
		let project = [core.rel.allPartners, core.rel.deliverables, core.rel.sharedCode]
		let ret = SetTagsScope(project)
		if ret == 1 
			break
		endif
	endfor

"  let prjList=[ 
"    \[v10allPartners,     v10diliverables,     v10shared_code],
"    \[ZeroRelallPartners, ZeroReldiliverables, ZeroRelshared_code],
"    \[VRelallPartners,    VReldiliverables,    VRelshared_code],
"  \]

"  for prj in prjList
"    let ret = SetTagsScope(prj)
"    if ret == 1 
"      break
"    endif
"  endfor
endfunction

call SetProject()

let g:NERDTreeWinPos = "right"

function AlignAssignments ()
    "Patterns needed to locate assignment operators...
    let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
    let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)'

    "Locate block of code to be considered (same indentation, no blanks)
    let indent_pat = '^' . matchstr(getline('.'), '^\s*') . '\S'
    let firstline  = search('^\%('. indent_pat . '\)\@!','bnW') + 1
    let lastline   = search('^\%('. indent_pat . '\)\@!', 'nW') - 1
    if lastline < 0
        let lastline = line('$')
    endif 
    
    "Find the column at which the operators should be aligned...
    let max_align_col = 0
    let max_op_width  = 0
    for linetext in getline(firstline, lastline)
        "Does this line have an assignment in it?
        let left_width = match(linetext, '\s*' . ASSIGN_OP)

        "If so, track the maximal assignment column and operator width...
        if left_width >= 0
            let max_align_col = max([max_align_col, left_width])

            let op_width      = strlen(matchstr(linetext, ASSIGN_OP))
            let max_op_width  = max([max_op_width, op_width+1])
        endif
    endfor

    "Code needed to reformat lines so as to align operators...
    let FORMATTER = '\=printf("%-*s%*s", max_align_col, submatch(1),
                    \                                    max_op_width,  submatch(2))'

    " Reformat lines with operators aligned in the appropriate column...
    for linenum in range(firstline, lastline)
        let oldline = getline(linenum)
        let newline = substitute(oldline, ASSIGN_LINE, FORMATTER, "")
        call setline(linenum, newline)
    endfor
endfunction

nmap <silent>  ;=  :call AlignAssignments()<CR>

" Open and close all the three plugins on the same time 
nmap <F7>  :NERDTree<CR>

" comment one line "
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>


" C syntex rule -----------------------------------------------------
let c_gnu                  =1
let c_space_errors         =1
let c_no_trail_space_error =1
"let c_comment_strings     =1
let c_ansi_typedefs        =1
let c_ansi_constants       =1

"for omnicpp
"set nocp
"filetype plugin on
