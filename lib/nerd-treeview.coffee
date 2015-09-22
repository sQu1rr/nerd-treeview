$ = jQuery = require 'jquery'

###
 # Copyright 2012, Digital Fusion
 # Licensed under the MIT license.
 # http://teamdf.com/jquery-plugins/license/
 #
 # @author Sam Sehnert
 # @desc A small plugin that checks whether elements are within
 #		 the user visible viewport of a web browser.
 #		 only accounts for vertical position, not horizontal.
 # @source https://github.com/customd/jquery-visible
###
$.fn.visible = (partial) ->
    $t = $(@)
    $w = $(window)
    viewTop = $w.scrollTop()
    viewBottom = viewTop + $w.height()
    _top = $t.offset().top
    _bottom = _top + $t.height()
    compareTop = if partial is true then _bottom else _top
    compareBottom = if partial is true then _top else _bottom

    return compareBottom <= viewBottom and compareTop >= viewTop

module.exports =
    openCallbacks: []

    activate: ->
        atom.commands.add('.tree-view', {
            "nerd-treeview:open": => @open(true)

            'nerd-treeview:open-stay': => @open(false)
            'nerd-treeview:open-tab-stay': => @openTab(false)

            'nerd-treeview:add-tab': => @addTab(true)
            'nerd-treeview:add-tab-stay': => @addTab(false)

            'nerd-treeview:open-split-vertical-stay': => @splitVertical(false)
            'nerd-treeview:open-split-horizontal-stay': =>
                @splitHorizontal(false)

            'nerd-treeview:close-parent': => @closeParent()
            'nerd-treeview:close-children': => @closeChildren()

            'nerd-treeview:open-tree': => @openTree(true)
            'nerd-treeview:open-tree-stay': => @openTree(false)

            'nerd-treeview:jump-up': => @jumpUp()
            'nerd-treeview:jump-down': => @jumpDown()
            'nerd-treeview:jump-root': => @jumpRoot()
            'nerd-treeview:jump-parent': => @jumpParent()
            'nerd-treeview:jump-first': => @jumpFirst()
            'nerd-treeview:jump-last': => @jumpLast()
            'nerd-treeview:jump-next': => @jumpNext()
            'nerd-treeview:jump-prev': => @jumpPrev()

            'nerd-treeview:change-root': => @changeRoot(false, false)
            'nerd-treeview:change-root-save-state': => @changeRoot(false, true)
            'nerd-treeview:up': => @changeRoot(true, false)
            'nerd-treeview:up-save-state': => @changeRoot(true, true)

            'nerd-treeview:toggle-files': => @toggleFiles()

            'nerd-treeview:remove': => @remove()
            'nerd-treeview:copy-name': => @copyName(false)
            'nerd-treeview:copy-name-ext': => @copyName(true)

            'nerd-treeview:scroll-up': => @scroll(false)
            'nerd-treeview:scroll-down': => @scroll(true)
        })

        atom.workspace.onDidOpen (e) =>
            callback(e) for callback in @openCallbacks
            @openCallbacks = []

    getTreeView: ->
        treeView = atom.packages.getActivePackage('tree-view')
        treeView = treeView?.mainModule.treeView

        root = $('.project-root')[0]
        if treeView and root and not treeView.selectedEntry()
            treeView.selectEntry(root)

        return treeView

    open: (activate) ->
        return if not treeView = @getTreeView()
        activePane = atom.workspace.getActivePane()

        selected = treeView.selectedEntry()
        if not $(selected).is('.file')
            return treeView.openSelectedEntry(activate)

        item = activePane.getActiveItem()
        replace = item and !item.isModified?()

        same = false
        for paneItem in activePane.getItems()
            if (selected.getPath() == paneItem.getPath?())
                same = true
                break

        if not (item and same)
            if replace
                treeView.openSelectedEntry(activate)
                @openCallbacks.push -> activePane.destroyItem(item)
            else treeView.openSelectedEntryDown(activate)
        else treeView.openSelectedEntry(activate)

    openTab: (activate) ->
        return if not treeView = @getTreeView()
        treeView.openSelectedEntry(activate)

    addTab: (activate) ->
        return if not treeView = @getTreeView()
        treeView.openSelectedEntry(activate)

        activePane = atom.workspace.getActivePane()
        item = activePane.getActiveItem()
        if item
            selected = treeView.selectedEntry()
            @openCallbacks.push ->
                activePane.activateItem(item)
                treeView.selectEntry(selected)

    splitVertical: (activate) ->
        return if not treeView = @getTreeView()
        treeView.openSelectedEntryDown(activate)
        @openCallbacks.push -> treeView.show()

    splitHorizontal: (activate) ->
        return if not treeView = @getTreeView()
        treeView.openSelectedEntryRight(activate)
        @openCallbacks.push -> treeView.show()

    closeParent: ->
        return if not treeView = @getTreeView()
        selected = treeView.selectedEntry()
        directory = $(selected).parents('.directory')[0]
        if directory
            directory.collapse()
            treeView.selectEntry(directory)

    closeChildren: ->
        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        directories = $(selected).find('>ol>li.directory')
        directory.collapse(true) for directory in directories

    openTree: (activate, path) ->
        return if not treeView = @getTreeView()

        if not path
            selected = treeView.selectedEntry()
            if $(selected).is('.directory')
                path = selected.getPath()

        if path
            atom.project.addPath(path)

            treeView.selectEntry($('.project-root').last()[0]) if activate

    jump: (getNode) ->
        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        node = getNode(selected)[0]
        if node
            treeView.selectEntry(node)
            $entry = $(node).find('.name').eq(0)
            if not $entry.visible()
                $entry[0]?.scrollIntoView(
                    $(node).offset().top < $(selected).offset().top
                )

    getNextEntry: (selected) ->
        node = $(selected)
        if node.is('.directory.expanded') and node.find('li:visible').size()
            li = node.find('li:visible')
            node = li.first() if li.size()
        else
            node = node.next(':visible')
            if not node.size()
                node = $(selected).parents('.directory:visible').eq(0)
                    .next(':visible')
        return node

    getPrevEntry: (selected) ->
        node = $(selected).prev(':visible')
        if not node.size()
            node = $(selected).parents('.directory:visible').eq(0)
        else if node.is('.directory.expanded')
            li = node.find('li:visible')
            node = li.last() if li.size()
        return node

    jumpUp: ->
        @jump (selected) => @getPrevEntry(selected)

    jumpDown: ->
        @jump (selected) => @getNextEntry(selected)

    jumpRoot: ->
        @jump (selected) -> $(selected).parents('.project-root:visible')

    jumpParent: ->
        @jump (selected) -> $(selected).parents('.directory:visible')

    jumpFirst: ->
        @jump (selected) -> $(selected).parent().children('li:visible').first()

    jumpLast: ->
        @jump (selected) -> $(selected).parent().children('li:visible').last()

    jumpNext: ->
        @jump (selected) -> $(selected).next(':visible')

    jumpPrev: ->
        @jump (selected) -> $(selected).prev(':visible')

    moveInArray: (array, i) ->
        array.splice(i, 0, array.splice(array.length - 1, 1)[0])

    rootIndex: (path, rootDirectories) ->
        for directory, i in rootDirectories
            if directory.getPath() == path
                return i
        return null

    fixState: (treeView, up, root, selected, index) ->
        if up
            (entries = {})[root.directory.name] = root.directory.expansionState
            state =
                isExpanded: true, entries: entries
            selection = $("span[data-path='#{selected.directory.path}]")
                .closest('li')[0]
            console.log(selected.directory)
        else
            selection = $('.project-root')[index]
            state = selected.directory.expansionState

        (expansionState = {})[treeView.roots[index].getPath()] = state
        console.log(selection, state, expansionState)
        treeView.updateRoots(expansionState)
        treeView.selectEntry(selection)

    changeRoot: (up, state) ->
        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        $selected = $(selected)
        if not $selected.is('.directory')
            selected = $selected.parents('.directory')[0]

        rootDirectories = atom.project.getDirectories()
        root = $selected.closest('.project-root')[0]
        index = @rootIndex(root.getPath(), rootDirectories)

        path = false
        path = rootDirectories[index].getParent().getPath() if up
        return if path == root.getPath()

        @openTree(false, path)
        @moveInArray(atom.project.rootDirectories, index)
        @moveInArray(atom.project.repositories, index)
        atom.project.removePath(root.getPath())

        @fixState(treeView, up, root, selected, index) if state

    toggleFiles: ->
        return if not treeView = @getTreeView()
        $(treeView).toggleClass('hide-files')

    remove: ->
        return if not treeView = @getTreeView()
        selected = treeView.selectedEntry()

        if $(selected).is('.project-root')
            treeView.removeProjectFolder(
                target: $(selected).find('.header .name')
            )
        else treeView.removeSelectedEntries()

    copyName: (ext) ->
        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        name = $(selected).find('.name').first().data('name')
        name = name.replace(/\.[^\.]+$/, '') unless ext or /^\./.test(name)
        atom.clipboard.write(name)

    scroll: (down) ->
        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()

        if down
            treeView.scrollDown()
            while not $(selected).visible()
                selected = @getNextEntry(selected)[0]
            treeView.selectEntry(selected)
        else
            treeView.scrollUp()
            while not $(selected).visible()
                selected = @getPrevEntry(selected)[0]
            treeView.selectEntry(selected)
