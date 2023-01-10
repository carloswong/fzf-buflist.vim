
command! BufList call fzf#run(fzf#wrap({
  \ 'source': fzf_buflist#list_buffers(),
  \ 'sink*': { lines -> fzf_buflist#handle_buffers(lines) },
  \ 'options': ['+m', '-x', '--prompt','BufList> ', '--multi','--reverse','--bind','ctrl-a:select-all+accept']
\ }))
