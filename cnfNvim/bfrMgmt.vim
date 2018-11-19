" Layer for  buffers and windows Mgmt {{{
" External plugins load {{{
call dein#add('Shougo/denite.nvim')
call dein#add('majutsushi/tagbar')
call dein#add('godlygeek/tabular')
"}}}

" Custom functions {{{
function! bfrMgmt#SetNumberDisplay() "{{{
" Varies the display of numbers.
"
" This is not a 'mode' specific setting, so a simple autocommand won't work.
" Numbers should not show up in a terminal buffer, regardless of if that
" buffer is in terminal mode or not.
  let l:buffername = @%
  if l:buffername =~ 'term://*'
    setlocal nonumber
    setlocal norelativenumber
  else
    setlocal number
    setlocal relativenumber
  endif
endfunction "}}}

function! bfrMgmt#Preserve(command) "{{{
  " preparation: save last search and cursor position
  let l:_s = @/
  let l:l = line(".")
  let l:c = col(".")
  " do the business
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/ = l:_s
  call cursor(l:l, l:c)
endfunction "}}}

function! bfrMgmt#StripTrailingWhitespace() "{{{
  call NvimPreserve("%s/\\s\\+$//e")
endfunction "}}}
" }}}

" Custom remap {{{
  let g:lmap.b        = { 'name' : '+Bfr'}
  let g:lmap.b.t      = ['TagbarToggle', 'tagbar-toggle']
  let g:lmap.b.a      = { 'name' : '+Align'}
  let g:lmap.b.a['|'] = [ 'Tabularize /|', 'align |']
  let g:lmap.b.a['='] = [ 'Tabularize /= ', 'align = ']
  let g:lmap.b.a[':'] = [ 'Tabularize /:', 'align :']
  let g:lmap.b.a[','] = [ 'Tabularize /,', 'align ,']
" }}}

augroup BfrWinAutocmd "{{{
  autocmd!
" Nvim terminal emulator {{{
" when in a neovim terminal, add a buffer to the existing vim session
" instead of nesting (credit justinmk)
autocmd VimEnter * if !empty($NVIM_LISTEN_ADDRESS) && $NVIM_LISTEN_ADDRESS !=# v:servername
  \ |let g:r=jobstart(['nc', '-U', $NVIM_LISTEN_ADDRESS],{'rpc':v:true})
  \ |let g:f=fnameescape(expand('%:p'))
  \ |noau bwipe
  \ |call rpcrequest(g:r, "nvim_command", "edit ".g:f)
  \ |call rpcrequest(g:r, "nvim_command", "call bfrMgmt#SetNumberDisplay()")
  \ |qa
  \ |endif

" turn numbers on for normal buffers; turn them off for terminal buffers
if has('nvim')
  autocmd TermOpen,BufWinEnter * call bfrMgmt#SetNumberDisplay()
endif
"}}}
augroup END
" }}}
" }}}
" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0


