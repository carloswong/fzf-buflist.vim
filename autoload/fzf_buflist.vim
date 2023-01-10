function! s:strip(str)
  return substitute(a:str, '^\s*\|\s*$', '', 'g')
endfunction

function! s:format_buffer(b)
   let name = bufname(a:b)
   let line = exists('*getbufinfo') ? getbufinfo(a:b)[0]['lnum'] : 0
   let filename = empty(name) ? '[No Name]' : fnamemodify(name, ":t")
   let fullname = empty(name) ? '' : fnamemodify(name, ":p:~:.")
   " let flag = a:b == bufnr('')  ? s:blue('%', 'Conditional') :
   "         \ (a:b == bufnr('#') ? s:magenta('#', 'Special') : ' ')
   " let modified = getbufvar(a:b, '&modified') ? s:red(' [+]', 'Exception') : ''
   " let readonly = getbufvar(a:b, '&modifiable') ? '' : s:green(' [RO]', 'Constant')
   " let extra = join(filter([modified, readonly], '!empty(v:val)'), '')
   " let target = line == 0 ? name : name.':'.line
  " return s:strip(printf("%s\t%d\t[%s] %s\t%s\t%s", target, line, s:yellow(a:b, 'Number'), flag, name, extra))
  return printf("%s\t%s\t", filename, fullname)
endfunction

function! fzf_buflist#list_buffers() 
    let buffers = fzf#vim#_buflisted_sorted()
    return map(buffers, 's:format_buffer(v:val)')
endfunction

function! fzf_buflist#handle_buffers(lines)
endfunction
