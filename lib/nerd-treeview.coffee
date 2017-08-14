$ = jQuery = require 'jquery'
SearchView = require './search-view'

# influenced by https://github.com/customd/jquery-visible
visible = ($e, $tree) ->
    top = $e.offset().top
    bottom = top + $e.height()
    treeTop = $tree.offset().top
    treeBottom = treeTop + $tree.height()
    return top >= treeTop and bottom <= treeBottom

scrollIfInvisible = ($e, $tree) ->
    if not visible($e, $tree)
        $e[0]?.scrollIntoView($e.offset().top < $tree.offset().top)

toggleConfig = (keyPath) ->
    atom.config.set(keyPath, not atom.config.get(keyPath))

wrapTreeView = (treeView) ->
    if !(treeView instanceof jQuery)
        if treeView.nodeType == 1
            return $(treeView)
        else if treeView.element.nodeType == 1
            return $(treeView.element)
    return treeView

module.exports =
    num: 0

    regex: null

    openCallbacks: []

    activate: ->
        atom.commands.add('body', {
            'nerd-treeview:toggle': =>
                if not @delegate('toggle')
                    atom.commands.dispatch(
                        atom.views.getView(atom.workspace),
                        'tree-view:toggle'
                    )
            'nerd-treeview:reveal-active-file': =>
                @delegate('revealActiveFile')
            'nerd-treeview:toggle-focus': =>
                @delegate('toggleFocus')
        })
        atom.commands.add('.tree-view', {
            'nerd-treeview:open': => @open(true)
            'nerd-treeview:open-stay': => @open(false)
            'nerd-treeview:open-tab': => @openTab(true)
            'nerd-treeview:open-tab-stay': => @openTab(false)

            'nerd-treeview:add-tab': => @addTab(true)
            'nerd-treeview:add-tab-stay': => @addTab(false)

            'nerd-treeview:open-split-vertical': => @splitVertical(true)
            'nerd-treeview:open-split-vertical-stay': => @splitVertical(false)
            'nerd-treeview:open-split-horizontal': => @splitHorizontal(true)
            'nerd-treeview:open-split-horizontal-stay': =>
                @splitHorizontal(false)

            'nerd-treeview:expand': => @expand(true)

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
            'nerd-treeview:jump-top': => @jumpLine(1)
            'nerd-treeview:jump-line': => @jumpLine()

            'nerd-treeview:change-root': => @changeRoot(false, false)
            'nerd-treeview:change-root-save-state': => @changeRoot(false, true)
            'nerd-treeview:up': => @changeRoot(true, false)
            'nerd-treeview:up-save-state': => @changeRoot(true, true)

            'nerd-treeview:toggle-ignored-names':
                -> toggleConfig 'tree-view.hideIgnoredNames'
            'nerd-treeview:toggle-vcs-ignored-files':
                -> toggleConfig 'tree-view.hideVcsIgnoredFiles'
            'nerd-treeview:toggle-files': => @toggleFiles()

            'nerd-treeview:add-file': => @delegate('add', true)
            'nerd-treeview:add-folder': => @delegate('add')
            'nerd-treeview:copy-full-path':
                => @delegate('copySelectedEntryPath')
            'nerd-treeview:remove': => @remove()
            'nerd-treeview:copy-name': => @copyName(false)
            'nerd-treeview:copy-name-ext': => @copyName(true)

            'nerd-treeview:move': => @delegate('moveSelectedEntry')
            'nerd-treeview:paste': => @delegate('pasteEntries')
            'nerd-treeview:duplicate': => @delegate('copySelectedEntry')
            'nerd-treeview:copy': => @delegate('copySelectedEntries')
            'nerd-treeview:cut': => @delegate('cutSelectedEntries')

            'nerd-treeview:scroll-up': => @scroll(false)
            'nerd-treeview:scroll-down': => @scroll(true)
            'nerd-treeview:scroll-half-screen-up': =>
                @scrollScreen(false, false)
            'nerd-treeview:scroll-half-screen-down': =>
                @scrollScreen(true, false)
            'nerd-treeview:scroll-full-screen-up': =>
                @scrollScreen(false, true)
            'nerd-treeview:scroll-full-screen-down': =>
                @scrollScreen(true, true)

            'nerd-treeview:scroll-cursor-to-top': => @cursor(true)
            'nerd-treeview:scroll-cursor-to-middle': => @centreCursor()
            'nerd-treeview:scroll-cursor-to-bottom': => @cursor(false)

            'nerd-treeview:move-to-top-of-screen': => @move('top')
            'nerd-treeview:move-to-middle-of-screen': => @move('middle')
            'nerd-treeview:move-to-bottom-of-screen': => @move('bottom')

            'nerd-treeview:repeat-prefix': (e) => @prefix(e)
            'nerd-treeview:clear-prefix': => @clearPrefix()

            'nerd-treeview:search': => @search(false)
            'nerd-treeview:reverse-search': => @search(true)
            'nerd-treeview:repeat-search': => @find(false)
            'nerd-treeview:repeat-search-backwards': => @find(true)
            'nerd-treeview:search-clear-highlight': => @noh()
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

    clearPrefix: ->
        @num = 0

    delegate: (method, arg) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        treeView[method](arg)
        return true

    open: (activatePane) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        activePane = atom.workspace.getCenter().getActivePane()

        selected = treeView.selectedEntry()
        if not $(selected).is('.file')
            return treeView.openSelectedEntry({activatePane})

        item = atom.workspace.getCenter().getActivePaneItem()
        replace = item and !item.isModified?()

        same = false
        for paneItem in activePane.getItems()
            if (selected.getPath() == paneItem.getPath?())
                same = true
                break

        if not (item and same)
            if replace
                treeView.openSelectedEntry({activatePane})
                @openCallbacks.push -> item?.destroy()
            else
                treeView.openSelectedEntryDown()
                if not activatePane
                    @openCallbacks.push => @delegate('toggleFocus')
        else treeView.openSelectedEntry({activatePane})

    openTab: (activatePane) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        treeView.openSelectedEntry({activatePane})

    addTab: (activatePane) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        treeView.openSelectedEntry({activatePane})

        activePane = atom.workspace.getCenter().getActivePane()
        item = activePane.getActiveItem()
        if item
            selected = treeView.selectedEntry()
            @openCallbacks.push ->
                activePane.activateItem(item)
                treeView.selectEntry(selected)

    splitVertical: (activatePane) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        treeView.openSelectedEntryDown({activatePane})
        @openCallbacks.push -> treeView.focus() unless activatePane

    splitHorizontal: (activatePane) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        treeView.openSelectedEntryRight({activatePane})
        @openCallbacks.push -> treeView.focus() unless activatePane

    expand: (recursive) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        treeView.expandDirectory(recursive)

    closeParent: ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        selected = treeView.selectedEntry()
        directory = $(selected).parents('.directory')[0]
        if directory
            directory.collapse()
            treeView.selectEntry(directory)

    closeChildren: ->
        @clearPrefix()

        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        directories = $(selected).find('>ol>li.directory')
        directory.collapse(true) for directory in directories

    openTree: (activate, path) ->
        @clearPrefix()

        return if not treeView = @getTreeView()

        if not path
            selected = treeView.selectedEntry()
            if $(selected).is('.directory')
                path = selected.getPath()

        if path
            atom.project.addPath(path)

            treeView.selectEntry($('.project-root').last()[0]) if activate

            return true

    jump: (getNode) ->
        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        node = getNode(selected)[0]
        if node
            $treeView = wrapTreeView(treeView);
            treeView.selectEntry(node)
            scrollIfInvisible($(node).find('.name').eq(0), $treeView)

    getNextEntry: (selected) ->
        node = $(selected)
        if node.is('.directory.expanded') and node.find('li:visible').size()
            li = node.find('li:visible')
            node = li.first() if li.size()
        else
            while node.size() and not node.next(':visible').size()
                node = node.parents('.directory:visible').eq(0)
            node = node.next(':visible') if node.size()
        return node

    getPrevEntry: (selected) ->
        node = $(selected).prev(':visible')
        if not node.size()
            node = $(selected).parents('.directory:visible').eq(0)
        else if node.is('.directory.expanded')
            li = node.find('li:visible')
            node = li.last() if li.size()
        return node

    repeatJump: (selected, getNode) ->
        oldSelection = $('#non-existing-id')
        for _ in [0..Math.max(@num - 1, 0)]
            selected = getNode(selected)
            break unless selected.size()
            oldSelection = selected

        @clearPrefix()
        return oldSelection

    jumpUp: ->
        @jump (selected) => @repeatJump(selected, @getPrevEntry)

    jumpDown: ->
        @jump (selected) => @repeatJump(selected, @getNextEntry)

    jumpRoot: ->
        @jump (selected) -> $(selected).parents('.project-root:visible')

    jumpParent: ->
        @jump (selected) =>
            @repeatJump(selected, (selected) ->
                $(selected).parents('.directory:visible')
            )

    jumpFirst: ->
        @jump (selected) -> $(selected).parent().children('li:visible').first()

    jumpLast: ->
        @jump (selected) -> $(selected).parent().children('li:visible').last()

    jumpNext: ->
        @jump (selected) => @repeatJump(selected, (selected) ->
            $(selected).next(':visible')
        )

    jumpPrev: ->
        @jump (selected) => @repeatJump(selected, (selected) ->
            $(selected).prev(':visible')
        )

    jumpLine: (num) ->
        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);
        $elements = $treeView.find('li:visible')

        if not num
            num = if @num then @num else $elements.size()
            num = $elements.size() if num > $elements.size()

        $entry = $elements.eq(num - 1)
        treeView.selectEntry($entry[0])
        scrollIfInvisible($entry, $treeView)

        @clearPrefix()

    moveInArray: (array, i) ->
        array.splice(i, 0, array.splice(array.length - 1, 1)[0])

    rootIndex: (path, rootDirectories) ->
        for directory, i in rootDirectories
            if directory.getPath() == path
                return i
        return null

    fixState: (treeView, up, root, selected, state, index) ->
        if up
            (entries = {})[root.directory.name] = state
            state =
                isExpanded: true, entries: entries
            selection = $("span[data-path='#{selected.directory.path}]")
                .closest('li')[0]
        else
            selection = $('.project-root')[index]

        (expansionState = {})[treeView.roots[index].getPath()] = state
        treeView.updateRoots(expansionState)
        treeView.selectEntry(selection)

    changeRoot: (up, state) ->
        @clearPrefix()

        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        $selected = $(selected)
        if not $selected.is('.directory')
            selected = $selected.parents('.directory')[0]

        rootDirectories = atom.project.getDirectories()
        root = $selected.closest('.project-root')[0]
        index = @rootIndex(root.getPath(), rootDirectories)

        path = selected?.getPath()
        path = rootDirectories[index].getParent().getPath() if up
        return if path == root.getPath()

        lastIndex = rootDirectories.length
        ser = (if up then root else selected).directory
            .serializeExpansionState()
        if @openTree(false, path) and rootDirectories.length > lastIndex
            @fixState(treeView, up, root, selected, ser, lastIndex) if state
            @moveInArray(atom.project.rootDirectories, index)
            @moveInArray(atom.project.repositories, index)
            atom.project.removePath(root.getPath())

    toggleFiles: ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        wrapTreeView(treeView).toggleClass('hide-files')

    remove: ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        selected = treeView.selectedEntry()

        if $(selected).is('.project-root')
            treeView.removeProjectFolder(
                target: $(selected).find('.header .name').get(0)
            )
        else treeView.removeSelectedEntries()

    copyName: (ext) ->
        @clearPrefix()

        return if not treeView = @getTreeView()

        selected = treeView.selectedEntry()
        name = $(selected).find('.name').first().data('name')
        name = name.replace(/\.[^\.]+$/, '') unless ext or /^\./.test(name)
        atom.clipboard.write(name)

    scroll: (down) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);

        elHeight = $treeView.find('li:visible:last').height();
        curScroll = treeView.scrollTop()
        treeView.scrollTop(curScroll + elHeight * (if down then 1 else -1))

    scrollScreen: (down, full) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);
        $selected = $(treeView.selectedEntry())

        treeHeight = $treeView.height();
        elHeight = $treeView.find('li:visible:last').height();

        D = if full then 1 else 2
        @num = Math.floor(treeHeight / elHeight / D);

        if down then @jumpDown() else @jumpUp()
        if not full then @centreCursor()

    cursor: (up) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);
        $selected = $(treeView.selectedEntry()).find('.name').eq(0)

        top = $selected.offset().top
        treeTop = $treeView.offset().top

        target = if up then treeTop else treeTop + $treeView.height()
        source = if up then top else top + $selected.height()

        curScroll = treeView.scrollTop()
        treeView.scrollTop(curScroll + source - target)

    centreCursor: ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);
        $selected = $(treeView.selectedEntry()).find('.name').eq(0)

        middle = parseInt($selected.offset().top + $selected.height() / 2)
        treeMiddle = parseInt($treeView.offset().top + $treeView.height() / 2)

        curScroll = treeView.scrollTop()
        treeView.scrollTop(curScroll + middle - treeMiddle)

    move: (where) ->
        @clearPrefix()

        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);

        centre = parseInt(($treeView.offset().left + $treeView.width()) / 2)
        if where is 'top'
            point = $treeView.offset().top + 16
        else if where is 'middle'
            point = parseInt($treeView.offset().top + $treeView.height() / 2)
        else
            point = $treeView.height() - $treeView.offset().top - 16

        $e = $(document.elementFromPoint(centre, point))
            .closest('li:visible')

        if not $e.size()
            $e = $treeView.find('li:visible')
            $e = if where is 'top' then $e.first() else $e.last()

        treeView.selectEntry($e[0]) if $e.size()

    prefix: (e) ->
        keyboardEvent = e.originalEvent?.originalEvent ? e.originalEvent
        num = parseInt(atom.keymaps.keystrokeForKeyboardEvent(keyboardEvent))
        @num = @num * 10 + num

        # TODO: temp fix to prevent freeze, ideally each function should handle
        @num = 9999 if @num > 9999

    search: (backwards) ->
        @clearPrefix()

        @view = new SearchView((regex) =>
            @searchObj =
                regex: regex,
                backwards: backwards

            setTimeout((=> @find()), 1) # to prevent try/catch
        )
        @view.attach()

    find: (backwards) ->
        if not @searchObj then return
        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);

        if @searchObj.backwards then backwards = not backwards

        elements = $treeView.find('span.name').get()
        if backwards then elements.reverse()

        highlighted = treeView.selectedEntry()

        if highlighted and elements.length
            highlighted = $(highlighted).find('span.name')[0]
            while elements[0] != highlighted
                temp = elements.shift()
                elements.push(temp)
            temp = elements.shift()
            elements.push(temp)

        next = null
        for element in elements
            if element.innerText.match(@searchObj.regex)
                next = element
                if @num then @num -= 1
                else break

        $treeView.find('span.name span.match').parent().each(->
            $(@).html($(@).text())
        )

        if next
            replace = '<span class="match">$&</span>'
            next.innerHTML = next.innerText.replace(@searchObj.regex, replace)

            treeView.selectEntry($(next).parents('li')[0])
            scrollIfInvisible($(next), $treeView)

        @clearPrefix()

    noh: () ->
        @clearPrefix()

        if not @searchObj then return

        return if not treeView = @getTreeView()
        $treeView = wrapTreeView(treeView);

        $treeView.find('span.name span.match').parent().each(->
            $(@).html($(@).text())
        )
