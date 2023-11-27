# resize-font.gvim

![Resizing gvim](resizing_gvim.gif)

#### (for Linux and Windows)

This plugin for gvim adds the ability to change font size (and therefore window size too) using the same methods used in most web browsers, terminal emulators and some other graphical text editors.

I may add Mac support if this plugin attracts any interest.

## Usage

| Mapping | Action |
| -- | -- |
|<kbd>Ctrl</kbd> + <kbd>=</kbd>| Increases text size |
|<kbd>Ctrl</kbd> + <kbd>-</kbd>| Decreases text size |
|<kbd>Ctrl</kbd> + <kbd>0</kbd>| Resets text to original size |
|<kbd>Ctrl</kbd> + <kbd>mousewheel</kbd>| Resize text |

In terminal vim or neovim the plugin exits and doesn't do anything.

## Install

### Plugin manager
Installation can be done via a plugin manager.

For [vim-plug](https://github.com/junegunn/vim-plug) it's:

```vim
Plug 'eggbean/resize-font.gvim'
```
### No plugin manager

If you don't use a plugin manager you can just place [the script](https://github.com/eggbean/resize-font.gvim/blob/master/plugin/change_font_size.vim) in...

`~/.vim/plugin` on Linux, or...

`%USERPROFILE%\vimfiles\plugin` on Windows.

## Not working with your font?

This should work with all modern Unicode fonts, but if you find one which doesn't work tell me and I'll modify the regex. This is only likely to occur with Windows.
