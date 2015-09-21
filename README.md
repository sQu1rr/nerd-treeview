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
* Smooth (NERD Tree like scroll - still unstable)

## Planned/Not Available functionality
* Bookmarks
* Quick Help
* NERD Tree menu
* cd/CD
* Expose API
* Search and other vim-mode key bindings (zz, C-D, C-U, etc)

## Installation Notes
* **This is first, and very unstable version**
* Best to use in conjunction with [vim-mode](https://atom.io/packages/vim-mode)
and [ex-mode](https://atom.io/packages/ex-mode)
* Better to disable default Tree View bindings in Tree View package settings

## Tips
#### Use ZZ to save-and-close current tab/split
See [this gist](https://gist.github.com/sQu1rr/4621b24d1f13864e4e70)

Update your init.coffee and kaymap.cson files with the extracts in git
* Close your windows/tabs/slits (only Text Editors) with Vim's ZZ
* If the last window is closed, the focus transfers to the tree view

## Default key bindings and events

### General

Key | Event | Description
--- | ----- | -----------
ZZ, q | tree-view:toggle | hides tree View

### Open Files

Key | Event | Description
--- | ----- | -----------
o | nerd-treeview:open | open file or toggle folder
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

Key | Event | Description
--- | ----- | -----------
j | nerd-treeview:jump-down | move cursor down
k | nerd-treeview:jump-up | move cursor up
P | nerd-treeview:jump-root | jump cursor to the current root folder
p | nerd-treeview:jump-parent | jump cursor to the parent folder
K | nerd-treeview:jump-first | jump cursor to the first element in this folder
J | nerd-treeview:jump-last | jump cursor to the last element in this folder
C-J | nerd-treeview:jump-next | jump to the next sibling
C-K | nerd-treeview:jump-prev | jump to the previous sibling
gg | core:move-to-top | move to the top
G | core:move-to-bottom | move to the bottom

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
a | tree-view:add-file | create new file
A | tree-view:add-folder | create new folder
D | nerd-treeview:remvoe | delete file or folder, or remove project root from workspace
mm | tree-view:move | rename/move
mp | tree-view:paste | paste
yp | tree-view:duplicate | duplicate
yy | tree-view:copy | copy
dd | tree-view:cut | cut
