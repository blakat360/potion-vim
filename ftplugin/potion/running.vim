if !exists("g:potion_command")
  let g:potion_command = "potion"
endif


function! PotionCompileAndRunFile()
  write
  silent !clear
  execute "!" . g:potion_command . " " . bufname("%")
endfunction

function! PotionShowBytecode()
  write

  let bffr_name = '__Potion_Bytecode__'

  " Get the bytecode.
  let bytecode = system(g:potion_command . " -c -V " . bufname("%"))

  if bytecode =~ "\vSyntax error"
    echo bytecode
    return
  endif

  " move to appropriate split and set it up 
  let bytecode_buffer = bufwinnr(bffr_name)

  if bytecode_buffer ==# -1
    execute "vsplit " . bffr_name
    normal! ggdG
    setlocal filetype=potionbytecode
    setlocal buftype=nofile
  else
    execute bytecode_buffer . "wincmd w"
  endif

  " Insert the bytecode.
  call append(0, split(bytecode, '\v\n'))
endfunction

nnoremap <buffer> <localleader>r :call PotionCompileAndRunFile()<cr>
nnoremap <buffer> <localleader>b :call PotionShowBytecode()<cr>
