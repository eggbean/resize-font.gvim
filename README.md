# resize-font.gvim

![Resizing gvim](resizing_gvim.gif)

#### (for Linux and Windows)

This plugin for gvim adds the ability to change font size (and therefore window size too) using the same methods used in most web browsers, terminal emulators and some other graphical text editors.

In console Vim or Neovim the plugin exits and doesn’t do anything.

I may add Mac support if this plugin attracts any interest.

## Usage

| Mapping | Action |
| -- | -- |
|<kbd>Ctrl</kbd> + <kbd>=</kbd>| Increases text size |
|<kbd>Ctrl</kbd> + <kbd>-</kbd>| Decreases text size |
|<kbd>Ctrl</kbd> + <kbd>0</kbd>| Resets text to original size |
|<kbd>Ctrl</kbd> + <kbd>mousewheel</kbd> | Increases/Decreases text size |

If you already have any of these keys mapped, your mappings will not be overridden.
There are also a few limitations when using older Windows gvim versions.
First, before v9.0 patch 1112 <kbd>Ctrl</kbd> + <kbd>-</kbd> will not work.
Instead, <kbd>Ctrl</kbd> + <kbd>=</kbd>, <kbd>=</kbd> has been made the default.
Second, the mousewheel mappings will not work if you’re using a version before v8.2 patch 5069.

If you don’t like these mappings, you can map your own in your .vimrc with:

```vim
nnoremap {LHS} <Plug>CfsPlus`,
nnoremap {LHS} <Plug>CfsMinus`, and
nnoremap {LHS} <Plug>CfsOriginal`
```

...where `{LHS}` is the key combination you want.

## Install

### Plugin manager

Installation can be done via a plugin manager.

For [vim-plug](https://github.com/junegunn/vim-plug) it’s:

```vim
Plug 'eggbean/resize-font.gvim'
```

### No plugin manager

If you don’t use a plugin manager you can just place [the scripts](https://github.com/eggbean/resize-font.gvim/blob/master/plugin/) `change_font_*.vim` in…

`~/.vim/plugin` on Linux, or…

`%USERPROFILE%\vimfiles\plugin` on Windows.

## Not working with your font?

This should work with all modern Unicode fonts but if you find one that doesn’t work tell me and I’ll modify the regex.  This is only likely to occur with Windows.
