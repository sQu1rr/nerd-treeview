{TextEditor, CompositeDisposable, Disposable} = require 'atom'

module.exports =
    class SearchView
        nochange: false

        constructor: (@callback) ->
            @disposables = new CompositeDisposable()

            # root
            @element = document.createElement('div')
            @element.classList.add('tree-view-dialog')

            # blur
            @miniEditor = new TextEditor({mini: true})
            blurHandler = => @close() if document.hasFocus()
            @miniEditor.element.addEventListener('blur', blurHandler)
            @disposables.add(new Disposable(=>
                @miniEditor.element.removeEventListener('blur', blurHandler)
            ))

            # colour change
            @miniEditor.onDidStopChanging(=>
                if not @nochange
                    @miniEditor.element.style.color = 'white'
            )

            # append to root
            @element.appendChild(@miniEditor.element)

            atom.commands.add @element,
                'core:confirm': => @confirm()
                'core:cancel': => @close()

        attach: ->
            @panel = atom.workspace.addModalPanel(item: this)
            @miniEditor.element.focus()
            @miniEditor.scrollToCursorPosition()

        close: ->
            panelToDestroy = @panel
            @panel = null
            panelToDestroy?.destroy()
            @disposables.dispose()
            @miniEditor.destroy()
            document.querySelector('.tree-view')?.focus()

        confirm: ->
            @nochange = true
            text = @miniEditor.getText()

            try
                @callback(new RegExp(text, 'i'))
                @close()
            catch e
                @miniEditor.element.style.color = 'red'
                setTimeout((=> @nochange = false), 400)
