Menu = m.comp do
	oninit: !->
		@item = null
		@popper = null
		@popperEl = null

	onbeforeupdate: (old, first) !->
		@attrs.root ?= @
		@attrs.items = _.castArray @attrs.items ? []
		@isHasIcon = @attrs.items.some (?icon)
		if first
			@uclass = @attrs.root.uclass or "Menu-uclass-#{m.uniqId!}"

	setItem: (item, refEl) !->
		unless @item is item
			@item = item?items and item
			if @item
				if @popper
					@popper.state.elements.reference = refEl
				else
					@popperEl = document.createElement \div
					@popperEl.className = "Portal Menu-popper #@uclass"
					if @attrs.isContextMenu
						@popperEl.classList.add "ContextMenu"
					@popperEl.tabIndex = 0
					portalsEl.appendChild @popperEl
					@popper = m.popper refEl, @popperEl,
						placement: \right-start
						offsets: [-5 -4]
						flips: [\left-start]
						allowedFlips: <[right-start left-start]>
					if @attrs.root is @
						unless @attrs.isContextMenu
							addEventListener \mousedown @onmousedownWindow, yes
				comp =
					view: ~>
						m Menu,
							items: item.items
							root: @attrs.root
							isContextMenu: @attrs.isContextMenu
				m.mount @popperEl, comp
				@popper.forceUpdate!
				m.redraw!
			else
				if @popper
					@popper.destroy!
					@popper = null
					m.mount @popperEl
					@popperEl.remove!
					@popperEl = null
					if @attrs.root is @
						unless @attrs.isContextMenu
							removeEventListener \mousedown @onmousedownWindow, yes
					m.redraw!

	close: !->
		@setItem null

	onmousedownWindow: (event) !->
		unless event.target.closest ".#@uclass"
			@close!

	onremove: !->
		@close!

	view: ->
		m \.Menu,
			class: m.class do
				"Menu-minimal": @attrs.minimal
				"Menu-submenu": @attrs.root isnt @
				"ContextMenu-menu": @attrs.isContextMenu
				@uclass if @attrs.root is @
				@attrs.class
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			@attrs.items.map (item) ~>
				if item
					m \.Menu-item,
						class: m.class do
							"Menu-item-#{item.color or \gray}"
							"Menu-itemShowSubmenu": @item is item
							"Menu-itemNoSubmenu": not item.items
							"disabled": item.disabled
						onmouseenter: !~>
							@setItem item, it.target
						onclick: !~>
							unless item.items
								item.onclick?!
								@attrs.root.close!
								@attrs.root.attrs.onitemclick? item
						if @isHasIcon
							m \.Menu-itemIcon,
								if item.icon
									m Icon,
										name: that
						m \.Menu-itemText,
							item.text
						m \.Menu-itemLabel,
							if item.items
								m Icon, name: \far:chevron-right
							else item.label
				else
					m \.Menu-divider
