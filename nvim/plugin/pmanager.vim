if exists('g:loaded_pmanager')
  finish
endif

command! PMInstall  lua require('pmanager').install()
command! PMUpdate   lua require('pmanager').update()
command! PMList     lua require('pmanager').list()
command! PMLog      lua require('pmanager').open_log()

let g:loaded_pmanager = 1