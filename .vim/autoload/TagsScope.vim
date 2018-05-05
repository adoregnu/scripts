
function! TagsScope#IsIn(prjroot)
	"echo expand('%:p')
    if match(expand('%:p'), a:prjroot) == 0
		return 1
	else
		return 0
	endif
endfunction

function! TagsScope#set(rootlist)
	if len(a:rootlist) < 1 
		return
	endif 

	let isFileInProject = 0
	for prjroot in a:rootlist
		let isFileInProject = TagsScope#IsIn(prjroot)
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

