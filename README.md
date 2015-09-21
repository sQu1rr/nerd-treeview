# Nerd TreeView

The Nerd TreeView package will transform the native atom Tree View to somewhat
similar to the famous NERD Tree VIM plugin - hence the name

Some of the NERD Tree's functionality is present in the native Tree View by
default, but it doesn't expose any interface so apart from CSS developers
can't really change much. This package will try to replicate Vim's original
NERD Tree functionality

Current functionality
* Most of the key VIM NERD Tree default key bindings are working
* Completely replaces standard Tree View bindings

Planned/Not Available functionality
* Bookmarks
* Quick Help
* NERD Tree menu
* cd/CD
* Expose API
* Search and other vim-mode key bindings (zz, C-D, C-U, etc)
* Auto-Scroll when cursor jumps

Installation Notes:
Please disable default Tree View bindings
This is first, and very unstable version

Default key bindings and events

Key | Event | Description
--- | ----- | -----------
ZZ, q | tree-view:toggle | hides tree View
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
O | tree-view:recursive-expand-directory | recursively expand directory
x | nerd-treeview:close-parent | close parent directory
X | nerd-treeview:close-children | close children directories recursively
e | nerd-treeview:open-tree | add selected folder as a new project root
E | nerd-treeview:open-tree-stay | same as "e" but cursor stays where it is
P | nerd-treeview:jump-root | jump cursor to the current root folder
p | nerd-treeview:jump-parent | jump cursor to the parent folder
K | nerd-treeview:jump-first | jump cursor to the first element in this folder
J | nerd-treeview:jump-last | jump cursor to the last element in this folder
C-J | nerd-treeview:jump-next | jump to the next sibling
C-K | nerd-treeview:jump-prev | jump to the previous sibling
c | nerd-treeview:change-root | set selected directory as root
C | nerd-treeview:change-root | set selected directory as root saving folder expansion state
u | nerd-treeview:change-root | set root's parent directory as root
U | nerd-treeview:change-root | set root's parent directory as root saving folder expansion state
I | tree-view:toggle-ignored-names | toggle visibility of hidden files
H | tree-view:toggle-vcs-ignored-files | toggle visibility of hidden VCS files
F | tree-view:toggle-files | toggle visibility of files
j | core:move-down | move cursor down
k | core:move-up | move cursor up
gg | core:move-to-top | move to the top
G | core:move-to-bottom | move to the bottom
a | tree-view:add-file | create new file
A | tree-view:add-folder | create new folder
D | nerd-treeview:remvoe | delete file or folder, or remove project root from workspace
Y | tree-view:copy-full-path | copy full path of the selected file
mm | tree-view:move | rename/move
mp | tree-view:paste | paste
yp | tree-view:duplicate | duplicate
yy | tree-view:copy | copy
dd | tree-view:cut | cut
