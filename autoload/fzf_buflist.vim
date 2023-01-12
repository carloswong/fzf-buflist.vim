function! s:strip(str)
  return substitute(a:str, '^\s*\|\s*$', '', 'g')
endfunction

function! s:format_buffer(b)
    let name = bufname(a:b)
    let number = bufnr(a:b)
    let fname = empty(name) ? '[No Name]' : fnamemodify(name, ":t")
    return printf("%s\t\033[90m%s [%s]\033[0m", fname, name, number)
endfunction

function! fzf_buflist#list_buffers() 
    let buffers = fzf#vim#_buflisted_sorted()
    return map(buffers, 's:format_buffer(v:val)')
endfunction

function! s:find_open_window(b)
  let [tcur, tcnt] = [tabpagenr() - 1, tabpagenr('$')]
  for toff in range(0, tabpagenr('$') - 1)
    let t = (tcur + toff) % tcnt + 1
    let buffers = tabpagebuflist(t)
    for w in range(1, len(buffers))
      let b = buffers[w - 1]
      if b == a:b
        return [t, w]
      endif
    endfor
  endfor
  return [0, 0]
endfunction

function! s:jump(t, w)
  execute a:t.'tabnext'
  execute a:w.'wincmd w'
endfunction

function! s:bufopen(lines)
  echo 'hello bufopen: ' . len(a:lines) . ' ' . join(a:lines,' ')
  let b = matchstr(a:lines[0], '\[\zs[0-9]*\ze\]')
  if empty(a:lines[0]) && get(g:, 'fzf_buffers_jump')
    let [t, w] = s:find_open_window(b)
    if t
      call s:jump(t, w)
      return
    endif
  endif
  execute 'buffer' b
endfunction

function! fzf_buflist#binding()
    let [query, args] = (a:0 && type(a:1) == type('')) ?
        \ [a:1, a:000[1:]] : ['', a:000]
    let buffers = fzf#vim#_buflisted_sorted()
    let header_lines = '--header-lines=' . (bufnr('') == get(buffers, 0, 0) ? 1 : 0)
    let tabstop = 2 "len(max(buffers)) >=4 ? 15 : 15

    call fzf#run(fzf#wrap({
      \ 'source': map(buffers, 's:format_buffer(v:val)'),
      \ 'sink*': function('s:bufopen'),
      \ 'options': ['+m', '-x', '--tiebreak=index', header_lines, '--ansi', '-d', '\t', '--prompt', 'BufList> ', '--query', query, '--preview-window', '+{2}-/2', '--tabstop', tabstop]
  \}))
endfunction
