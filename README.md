# Nerd TreeView

The Nerd TreeView package will transform the native atom Tree View to somewhat
similar to the famous NERD Tree Vim plugin - hence the name

Some of the NERD Tree's functionality is present in the native Tree View by
default, but it doesn't expose any interface so apart from CSS developers
can't really change much. This package will try to replicate Vim's original
NERD Tree functionality

## Current functionality
* Most of the key VIM NERD Tree default key bindings are working
* Completely replaces standard Tree View bindings
* Smooth scroll (NERD Tree like scroll - still unstable)

## Planned/Not Available functionality
* Bookmarks (Integrate with Core Bookmarks?)
* NERD Tree menu (Subtree management)
* cd/CD (through ex-mode extention)
* Try to use vim-mode functionality where/if possible
* Expose API through service
* Search highlight

## Installation Notes
* **This is first, and very unstable version**
* Best to use in conjunction with [vim-mode](https://atom.io/packages/vim-mode)
and [ex-mode](https://atom.io/packages/ex-mode)
* Better to disable default Tree View bindings in Tree View package settings

## Tips
#### Use ZZ to save-and-close current tab/split
See [vim-mode-zz](https://atom.io/packages/vim-mode-zz)

## Default key bindings and events

### General

Key | Event | Description
--- | ----- | -----------
C-\, D-\ (mac), C-k C-b, D-k D-b (mac) | tree-view:toggle | toggle the tree (default)
A-\, C-0 (mac) | tree-view:toggle-focus | activate the tree (default)
C-&#124;, D-&#124; (mac) | tree-view:reveal-active-file | jump selection to the active file
ZZ, q | tree-view:toggle | hides tree View
? | nerd-treeview:quick-help | shows quick help menu

### Open Files

Key | Event | Description
--- | ----- | -----------
o, <CR> | nerd-treeview:open | open file or toggle folder
go | nerd-treeview:open-stay | same as "o" but tree stays active
t | tree-view:open-selected-entry | open selected file in a new tab
gt | nerd-treeview:open-tab-stay | same as "t" but tree stays active
T | nerd-treeview:add | same as "t" but current tab will stay active
gT | nerd-treeview:add-tab-stay | same as "T" but tree stays active
i | tree-view:open-selected-entry-down | split open file vertically downwards
gi | nerd-treeview:open-split-vertical-stay | same as "i" but tree stays active
s | tree-view:open-selected-entry-right | split open file horizontally to the right
gs | nerd-treeview:open-split-horizontal-stay | same as "s" but tree stays active

### Interact with Folders

Key | Event | Description
--- | ----- | -----------
O | tree-view:recursive-expand-directory | recursively expand directory
x | nerd-treeview:close-parent | close parent directory
X | nerd-treeview:close-children | close children directories recursively
e | nerd-treeview:open-tree | add selected folder as a new project root
E | nerd-treeview:open-tree-stay | same as "e" but cursor stays where it is

### Navigation

Key | Event | Description | Can be prefixed
--- | ----- | ----------- | ---------------
j, +, down | nerd-treeview:jump-down | move cursor down | YES
k, -, up | nerd-treeview:jump-up | move cursor up | YES
K | nerd-treeview:jump-first | jump cursor to the first element in this folder | YES
J | nerd-treeview:jump-last | jump cursor to the last element in this folder | YES
C-J | nerd-treeview:jump-next | jump to the next sibling | YES
C-K | nerd-treeview:jump-prev | jump to the previous sibling | YES
gg | core:move-to-top | move to the top | **NO**
G | nerd-treeview:jump-line | move to the bottom | YES
P | nerd-treeview:jump-root | jump cursor to the current root folder | **NO**
p | nerd-treeview:jump-parent | jump cursor to the parent folder | YES
H | nerd-treeview:move-to-top-of-screen | Select top line | **NO**
L | nerd-treeview:move-to-bottom-of-screen | Select bottom line | **NO**
M | nerd-treeview:move-to-middle-of-screen | Select middle line | **NO**

### Tree modification

Key | Event | Description
--- | ----- | -----------
c | nerd-treeview:change-root | set selected directory as root
C | nerd-treeview:change-root | set selected directory as root saving folder expansion state
u | nerd-treeview:change-root | set root's parent directory as root
U | nerd-treeview:change-root | set root's parent directory as root saving folder expansion state
I | tree-view:toggle-ignored-names | toggle visibility of hidden files
H | tree-view:toggle-vcs-ignored-files | toggle visibility of hidden VCS files
F | tree-view:toggle-files | toggle visibility of files

### Filesystem interaction

Key | Event | Description
--- | ----- | -----------
Y | tree-view:copy-full-path | copy full path of the selected file
yn | nerd-treeview:copy-name | copy file name **without** extension
yN | nerd-treeview:copy-name-ext | copy file name **with** extension
a | tree-view:add-file | create new file
A | tree-view:add-folder | create new folder
D | nerd-treeview:remvoe | delete file or folder, or remove project root from workspace
mm | tree-view:move | rename/move
mp | tree-view:paste | paste
yp | tree-view:duplicate | duplicate
yy | tree-view:copy | copy
dd | tree-view:cut | cut

### Scroll

Key | Event | Description
--- | ----- | -----------
C-u | nerd-treeview:scroll-half-screen-up | Scroll half screen up
C-b | nerd-treeview:scroll-full-screen-up | Scroll full screen up
C-d | nerd-treeview:scroll-half-screen-down | Scroll half screen down
C-f | nerd-treeview:scroll-full-screen-down | Scroll full screen down
C-e | nerd-treeview:scroll-down | Scroll Down
C-y | nerd-treeview:scroll-up | Scroll Up

### Zoom

Key | Event | Description
--- | ----- | -----------
z<CR>, zt | nerd-treeview:scroll-cursor-to-top | scroll current line to the top
z., zz | nerd-treeview:scroll-cursor-to-middle | scroll current line to the middle
z-, zb | nerd-treeview:scroll-cursor-to-bottom | scroll current line to the bottom

### Search

Key | Event | Description
--- | ----- | -----------
/ | nerd-treeview:search | search
? | nerd-treeview:reverse-search | reverse search
n | nerd-treeview:repeat-search | go to the next match (can be prefixed)
N | nerd-treeview:repeat-search-backwards | go to the previous match (can be prefixed)
