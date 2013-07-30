"============================================================================
"File:        opencl.vim
"Description: OpenCL syntax checking plugin for syntastic.vim
"Maintainer:  petRUShka <petrushkin at yandex dot ru>
"License:     GPLv3
"
"============================================================================
if exists("loaded_opencl_syntax_checker")
    finish
endif
let loaded_opencl_syntax_checker = 1

"fail if the user doesn't have opencl installed
if !executable("clcc")
    finish
endif

function! SyntaxCheckers_opencl_GetLocList()
    let makeprg = 'clcc '.shellescape(expand('%'))

    " NVIDIA driver format
    let errorformat =   '%E:%l:%c: error: %m,%-Z%p^\[ ~\]%#,'.
                       \'%W:%l:%c: warning: %m,%-Z%p^\[ ~\]%#,'.
                       \'%I:%l:%c: note: %m,%-Z%p^\[ ~\]%#,'
    " AMD driver format
    let errorformat .=  '%E"%f"\, line %l: catastrophic error: %m,%+C%.%#,%-Z%p^,'.
                       \'%E"%f"\, line %l: error: %m,%+C%.%#,%-Z%p^,'.
                       \'%W"%f"\, line %l: warning: %m,%-C%.%#,'
    " Other lines should be hidden
    let errorformat .= '%-G%.%#'

	let loclist = SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })

    "the file name isnt in the output so stick in the buf num manually
	for i in loclist
      let i['bufnr'] = bufnr("")
	endfor

    return loclist
endfunction
