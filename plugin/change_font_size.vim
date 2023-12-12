" Plugin:       eggbean/resize-font.gvim
" Description:  Change gvim font size using keyboard or mousewheel
" Author:       Jason Gomez <jason@jinkosystems.co.uk>
" Credit:       Originally based on https://vi.stackexchange.com/a/3104/37532

" Finish when any of the following apply:
" * Version 9 or 8.2 with patch 4807?  Use the vim9script version.
" * No GUI running or Neovim?  So, N/A.
" * Plugin already loaded?  Don't it load again!
if v:version >= 900 || (v:version == 802 && has('patch4807')) || !has('gui_running') || has('nvim') || exists('g:loaded_change_font_size')
  finish
endif
let g:loaded_change_font_size = "vimscript" " For testing which version

if has('gui_gtk')
  " gui_gtk includes gui_gtk2 and gui_gtk3 - refer :h has-patch
  autocmd GUIEnter * let g:gf_size_orig = matchstr(&guifont, '\( \)\@<=\d\+$')
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
  autocmd GUIEnter * let g:gf_size_orig = matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$')
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

" Mappings.  Only when one of the supported GUIs is running:
" - Create <Plug> mappings, and
" - Apply mappings (but only when not already specified - 'Do no harm').
" NB: 1. In Windows, the <C-Scroll*> mappings will not work with versions
"        before 8.2 with patch 5069 (they do nothing).  Refer:
"        https://github.com/vim/vim/commit/ebb01bdb273216607f60faddf791a1b378cccfa8
"     2. In Windows, <C-{char}> mappings will not work before 8.2 with
"        patch 4807, which has been set as the cut-off for using the
"        vim9script version.  Therefore, different keys are needed in
"        Windows - that's not been done here *yet* (testing of <S-F10> to
"        <S-F12> in Windows was _somewhat_ functional, though seemed to
"        stop/start working for some reason).
" So, the <C-Scroll*> and <C-{char}> mappings have been left as per Jason's
" initial setup, notwithstanding none will work in Windows and whether they
" work in *gtk* for 8.2 before patch 4807 ... ???
if has('gui_gtk') || has('gui_win32')

  map <silent> <Plug>CfsPlus <Cmd>execute "call FontSizePlus()"<CR>
  " <C-=> and/or <C-ScrollWheelUp> to FontSizePlus() when not already mapped
  execute maparg('<C-=>', 'n') == '' ? ':nnoremap <C-=> <Plug>CfsPlus' : ''
  execute maparg('<C-ScrollWheelUp>', '') == '' ? ':noremap <C-ScrollWheelUp> <Plug>CfsPlus' : ''

  map <silent> <Plug>CfsMinus <Cmd>execute "call FontSizeMinus()"<CR>
  " U+001F (, i.e., <C-_>) and/or <C-ScrollWheelDown> to FontSizeMinus() when not already mapped
  " Specifically, before v9.0 patch 1112 <C-_> will not work on Windows
  " Refer: https://github.com/vim/vim/commit/7b0afc1d7698a79423c7b066a5d8d20dbb8a295a
  " That's academic because before 8.2 patch 4807 no <C- mappings work
  " in Windows anyhow; see the "NB:" item 2, above).
  execute maparg('', 'n') == '' ? ':nnoremap  <Plug>CfsMinus' : ''
  execute maparg('<C-ScrollWheelDown>', '') == '' ? ':noremap <C-ScrollWheelDown> <Plug>CfsMinus' : ''

  map <silent> <Plug>CfsOriginal <Cmd>execute "call FontSizeOriginal()"<CR>
  " <C-0> to FontSizeOriginal() only when not already mapped
  execute maparg('<C-0>', '') == '' ? ':nnoremap <C-0> <Plug>CfsOriginal' : ''

endif
