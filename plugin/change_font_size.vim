" File:         change_font_size.vim
" Description:  Change gvim font size using keyboard or mousewheel
" Author:       Jason Gomez <jason@jinkosystems.co.uk>

if exists('g:loaded_change_font_size') || !has('gui_running')
  finish
endif
let g:loaded_change_font_size= 1

if has('gui_gtk2') || has('gui_gtk3')
  let g:gf_size_orig = matchstr(&guifont, '\( \)\@<=\d\+$')
  function! FontSizePlus()
    let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
    if l:gf_size_whole < 28
      let l:gf_size_whole = l:gf_size_whole + 1
      let l:new_font_size = ' '.l:gf_size_whole
      let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
    endif
  endfunction
  function! FontSizeMinus()
    let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
    if l:gf_size_whole > 1
      let l:gf_size_whole = l:gf_size_whole - 1
      let l:new_font_size = ' '.l:gf_size_whole
      let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
    endif
  endfunction
  function! FontSizeOriginal()
    let &guifont = substitute(&guifont, ' \d\+$', ' '.g:gf_size_orig, '')
  endfunction
elseif has('gui_win32')
  let g:gf_size_orig = matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$')
  function! FontSizePlus()
    let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$')
    let l:gf_weight = matchstr(&guifont, '\(:W\d\+\)\?$')
    let l:gf_bold = matchstr(&guifont, '\(:b\)\?$')
    let l:gf_cansi = matchstr(&guifont, '\(:cANSI\)\?$')
    let l:gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?$')
    if l:gf_size_whole < 28
      let l:gf_size_whole = l:gf_size_whole + 1
      let l:new_font_size = ':h'.l:gf_size_whole
      let &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$', l:new_font_size.l:gf_weight.l:gf_bold.l:gf_cansi.l:gf_qdraft, '')
    endif
  endfunction
  function! FontSizeMinus()
    let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$')
    let l:gf_weight = matchstr(&guifont, '\(:W\d\+\)\?$')
    let l:gf_bold = matchstr(&guifont, '\(:b\)\?$')
    let l:gf_cansi = matchstr(&guifont, '\(:cANSI\)\?$')
    let l:gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?$')
    if l:gf_size_whole > 1
      let l:gf_size_whole = l:gf_size_whole - 1
      let l:new_font_size = ':h'.l:gf_size_whole
      let &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$', l:new_font_size.l:gf_weight.l:gf_bold.l:gf_cansi.l:gf_qdraft, '')
    endif
  endfunction
  function! FontSizeOriginal()
    let l:gf_weight = matchstr(&guifont, '\(:W\d\+\)\?$')
    let l:gf_bold = matchstr(&guifont, '\(:b\)\?$')
    let l:gf_cansi = matchstr(&guifont, '\(:cANSI\)\?$')
    let l:gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?$')
    let &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$', ':h'.g:gf_size_orig.l:gf_weight.l:gf_bold.l:gf_cansi.l:gf_qdraft, '')
  endfunction
endif
if has('gui_running')
  nmap <C-=> :call FontSizePlus()<CR>
  nmap     :call FontSizeMinus()<CR>
  nmap <C-0> :call FontSizeOriginal()<CR>
  map <silent> <C-ScrollWheelUp>   :call FontSizePlus()<CR>
  map <silent> <C-ScrollWheelDown> :call FontSizeMinus()<CR>
endif
