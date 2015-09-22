## 0.3.0
* To simplify keymap management keymaps were separated into:
 * tree-view: default Tree View **toggle and focus** mappings (C-\, A-\, etc)
 * nerd-treeview: nerd treeview mappings
 * vim-mode: nerd treeview navigation (j, k, gg, G, etc)
* Added missing Vim bindings (enter, +, -, etc)
* Implemented number-prefixed jumps (5j, 6k, etc)
* G can now jump to the line
* Search and Reverse search added
* Quick help added
* Added functionality to copy selected file name (not full path)
* Fixed issue when navigating down doesn't work for opened folders without files

## 0.2.3
* Code cleaning and readme/changelog updates
* Added missing Vim mappings for navigation (top arrow, down arrow)

## 0.2.2 - Update for Readme
* Cosmetic Readme updates

## 0.2.1 - Fixed Wrong pane item
* Fixed Issue #1: When opened tab is not TextEditor (e.g. About page)
opening new file crashes

## 0.2.0 - Smooth Scroll
* j, k, J, K, C-J, C-K, gg and G will now smoothly scroll
* Fixed the issue with hidden files begin selected when moving with keyboard

## 0.1.0 - Initial Release
* Initial Release
