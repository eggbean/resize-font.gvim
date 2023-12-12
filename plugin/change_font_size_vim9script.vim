"
"     Δ       FFFF   OOO   NNN  TTT    SSS  III ZZZZ  EEEE
"    Δ Δ      F     O   O  N  N  T     S     I    ZZ  E
"   Δ   Δ     FFFF  O   O  N  N  T      SSS  I   ZZ   EEE
"  Δ     Δ    F     O   O  N  N  T        S  I  ZZ    E
" ΔΔΔΔΔΔΔΔΔ   F      OOO   N  N  T     SSS  III ZZZZ  EEEE
"
" File:        change_font_size_vim9script.vim
" Description: Change gvim font size using keyboard or mousewheel
" Author:      Peter Kenny
" Credit:      Based on Jason Gomez's github.com/eggbean/resize-font.gvim,
"              (itself citing vi.stackexchange.com/a/3104/37532)
"
" vim9-mix for running vim9script.
" Finish when any of the following apply:
" * Version < 8.2 (inclusive of any version of Neovim, which returns 801)
" * Version 8.2 without patch 4807 (Win32 64-bit gvim at/above that works)
" * Console version, so no GUI is running, or
" * The plugin has already been loaded.
if (v:version < 802 || (v:version == 802 && !has('patch4807')) || !has('gui_running') || exists('g:loaded_change_font_size'))
  finish
endif

vim9script

g:loaded_change_font_size = "vim9script"

# initialisation of variables
var gf_size_whole: number
var new_font_size: string
var gf_weight: string
var gf_bold: string
var gf_cansi: string
var gf_qdraft: string

# gui_gtk2 and gui_gtk3 - refer :h has-patch (gui_gtk does addresses both)
if has('gui_gtk')
  autocmd GUIEnter * g:gf_size_orig = matchstr(&guifont, '\( \)\@<=\d\+$')
  def g:FontSizePlus(): void
    gf_size_whole = str2nr(matchstr(&guifont, '\( \)\@<=\d\+$'))
    if gf_size_whole < 28
      gf_size_whole += 1
      new_font_size = ' ' .. gf_size_whole
      &guifont = substitute(&guifont, ' \d\+$', new_font_size, '')
    endif
  enddef
  def g:FontSizeMinus(): void
    gf_size_whole = str2nr(matchstr(&guifont, '\( \)\@<=\d\+$'))
    if gf_size_whole > 1
      gf_size_whole -= 1
      new_font_size = ' ' .. gf_size_whole
      &guifont = substitute(&guifont, ' \d\+$', new_font_size, '')
    endif
  enddef
  def g:FontSizeOriginal(): void
    &guifont = substitute(&guifont, ' \d\+$', ' ' .. g:gf_size_orig, '')
  enddef
elseif has('gui_win32')
  autocmd GUIEnter * g:gf_size_orig = matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$')
  def g:FontSizePlus(): void
    gf_size_whole = str2nr(matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$'))
    gf_weight = matchstr(&guifont, '\(:W\d\+\)\?$')
    gf_bold = matchstr(&guifont, '\(:b\)\?$')
    gf_cansi = matchstr(&guifont, '\(:cANSI\)\?$')
    gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?$')
    if gf_size_whole < 28
      gf_size_whole += 1
      new_font_size = ':h' .. gf_size_whole
      &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$', new_font_size .. gf_weight .. gf_bold .. gf_cansi .. gf_qdraft, '')
    endif
  enddef
  def g:FontSizeMinus(): void
    gf_size_whole = str2nr(matchstr(&guifont, '\(:h\)\@<=\d\+\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$'))
    gf_weight = matchstr(&guifont, '\(:W\d\+\)\?$')
    gf_bold = matchstr(&guifont, '\(:b\)\?$')
    gf_cansi = matchstr(&guifont, '\(:cANSI\)\?$')
    gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?$')
    if gf_size_whole > 1
      gf_size_whole -= 1
      new_font_size = ':h' .. gf_size_whole
      &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$', new_font_size .. gf_weight .. gf_bold .. gf_cansi .. gf_qdraft, '')
    endif
  enddef
  def g:FontSizeOriginal(): void
    gf_weight = matchstr(&guifont, '\(:W\d\+\)\?$')
    gf_bold = matchstr(&guifont, '\(:b\)\?$')
    gf_cansi = matchstr(&guifont, '\(:cANSI\)\?$')
    gf_qdraft = matchstr(&guifont, '\(:qDRAFT\)\?$')
    &guifont = substitute(&guifont, '\(:h\d\+\)\(:W\d\+\)\?\(:b\)\?\(:cANSI\)\?\(:qDRAFT\)\?$', ':h' .. g:gf_size_orig .. gf_weight .. gf_bold .. gf_cansi .. gf_qdraft, '')
  enddef
endif

# Mappings.  Only when one of the supported GUIs is running:
# - Create <Plug> mappings, and
# - Apply them only when they're not already specified ('Do no harm'!).
if has('gui_gtk') || has('gui_win32')  # has('gui_running') is too permissive

  map <silent> <Plug>CfsPlus <Cmd>execute "call g:FontSizePlus()"<CR>
  # <C-=> and/or <C-ScrollWheelUp> to FontSizePlus() when not already mapped
  execute maparg('<C-=>', 'n') == '' ? ':nnoremap <C-=> <Plug>CfsPlus' : ''
  execute maparg('<C-ScrollWheelUp>', '') == '' ? ':noremap <C-ScrollWheelUp> <Plug>CfsPlus' : ''

  map <silent> <Plug>CfsMinus <Cmd>execute "call g:FontSizeMinus()"<CR>
  # U+001F ( i.e., <C-_>) and/or <C-ScrollWheelDown> to FontSizeMinus() when not already mapped
  # NB: Before v9.0 patch 1112 <C-_> will not work on Windows - refer:
  # https://github.com/vim/vim/commit/7b0afc1d7698a79423c7b066a5d8d20dbb8a295a
  if !has('win32') || (has('win32') && v:versionlong >= 9001112)
    execute maparg('', 'n') == '' ? ':nnoremap  <Plug>CfsMinus' : ''
  else
    # <C-_> is unavailable, as noted above, so use <C-=>= instead
    execute maparg('<C-=>=', 'n') == '' ? ':nnoremap <C-=>= <Plug>CfsMinus' : ''
  endif
  execute maparg('<C-ScrollWheelDown>', '') == '' ? ':noremap <C-ScrollWheelDown> <Plug>CfsMinus' : ''

  map <silent> <Plug>CfsOriginal <Cmd>execute "call g:FontSizeOriginal()"<CR>
  # <C-0> to FontSizeOriginal() when not already mapped
  execute maparg('<C-0>', '') == '' ? ':nnoremap <C-0> <Plug>CfsOriginal' : ''

endif
