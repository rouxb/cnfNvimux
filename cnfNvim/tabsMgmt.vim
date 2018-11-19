" layer for  Tabsmgmt{{{
" External plugins load {{{
"}}}

" global layers variables {{{
let g:usrTabName = {}
let g:prvTab = 1
let g:curTab = 1
" }}}

" Custom functions {{{
function! tabsMgmt#RegisterTab(tabName) "{{{
  let a:tabDescr = {}
  "" tabs uid
  "let a:tabDescriptor['uid'] = TODO
  " tabs name
  if a:tabName ==# ''
    let a:tabDescr['name'] = init#AskUser('Enter tab name: ')
  else
    let a:tabDescr['name'] = a:tabName
  endif
  " tabs zoom status
  let a:tabDescr['zoom'] = 0
  "tabs buffers list
  let a:tabDescr['buffers'] = []
  "tabs terminals list
  let a:tabDescr['terms'] = []
  return a:tabDescr
endfunction " }}}

function! tabsMgmt#ToggleZoom() "{{{
  if t:tabDescriptor['zoom'] == 1
    exec t:zoom_winrestcmd
    let t:tabDescriptor['zoom'] = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:tabDescriptor['zoom'] = 1
  endif
endfunction "}}}

function! tabsMgmt#RenameTab() "{{{
  let t:tabDescriptor['name'] = init#AskUser('Rename tab: ')
  "update usrTabName
  let g:usrTabName[tabpagenr()] = t:tabDescriptor['name']
endfunction "}}}

function! tabsMgmt#ToggleTab() "{{{
  execute 'tabnext ' . g:prvTab
endfunction "}}}

function! tabsMgmt#OpenTabTerm() "{{{
  let luid = reltime()[0]
  let termName = 'term://'.t:tabDescriptor['name'].'_'.luid
  execute 'terminal'
  execute 'file term://'. termName
  execute 'stopinsert'
  let t:tabDescriptor['terms'] += [{'name':termName, 'bufid': bufnr('%')}]
endfunction "}}}

function! tabsMgmt#UpdtTabName() "{{{
  "update usrTabName
  let g:usrTabName[tabpagenr()] = t:tabDescriptor['name']
  "update history
  let g:prvTab = g:curTab
  let g:curTab = tabpagenr()
endfunction "}}}

function! tabsMgmt#UpdtAllTab() "{{{
  " Store position
  let s:prvTabStored = g:prvTab
  let s:curTabStored = tabpagenr()
  "Update name 
  execute 'tabdo call tabsMgmt#UpdtTabName()'
  " Restore position and history
  execute 'tabnext ' . s:curTabStored
  let g:curTab = s:curTabStored
  let g:prvTab = s:prvTabStored
endfunction "}}}

function! tabsMgmt#FirstTab_hook() "{{{
  let t:tabDescriptor = tabsMgmt#RegisterTab('Sandbox')
  "update usrTabName
  let g:usrTabName[tabpagenr()] = t:tabDescriptor['name']
endfunction " }}}

function! tabsMgmt#TabNew_hook() "{{{
  let t:tabDescriptor = tabsMgmt#RegisterTab('')
endfunction " }}}

function! tabsMgmt#TabEnter_hook() "{{{
  call tabsMgmt#UpdtTabName()
endfunction " }}}

function! tabsMgmt#TabClosed_hook() "{{{
endfunction " }}}
" }}}

" Custom remap {{{
  command! TabsZoomToggle call tabsMgmt#ToggleZoom()
  nnoremap <C-z> :TabsZoomToggle <CR>
  command! TabsToggle call tabsMgmt#ToggleTab()
  nnoremap g<C-I> :TabsToggle <CR>
  let g:lmap.t = { 'name' : '+Tabs'}
  let g:lmap.t.r = ['call tabsMgmt#RenameTab()', 'rename-tab']
  let g:lmap.t.u = ['call tabsMgmt#UpdtAllTab()', 'updtAll-tab']
  let g:lmap.t.n = ['tabnew', 'new-tab']
  let g:lmap.t.h = ['-tabmove', 'mv-tab-left']
  let g:lmap.t.l = ['tabmove', 'mv-tab-right']
  let g:lmap.t.t = ['call tabsMgmt#OpenTabTerm()', 'open-term']
  let g:lmap.t.z = ['call tabsMgmt#ToggleZoom()', 'zoom-toggle']
  let g:lmap.t['<C-I>'] = ['call tabsMgmt#ToggleTab()', 'toggle-tab']
  let g:lmap.t.c = ['tabclose', 'close-tab']
" }}}

augroup tabsMgmtAutocmd "{{{
  autocmd!
  autocmd VimEnter *  call tabsMgmt#FirstTab_hook()
  autocmd TabNew *  call tabsMgmt#TabNew_hook()
  autocmd TabEnter * call tabsMgmt#TabEnter_hook()
  autocmd TabClosed * call tabsMgmt#TabClosed_hook()
augroup END
" }}}
" }}}
" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0

