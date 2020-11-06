Select = m.comp do
	oninit: !->
		@popper = null
		@popperEl = null
		@uuid = m.uuid!
		@width = void

	oncreate: !->
		unless @attrs.width?
			{textContent} = @dom.firstChild
			@width = 0
			for item in @attrs.items
				text = m.resultObj item, \text
				@dom.firstChild.textContent = text
				@width >?= @dom.offsetWidth
			@dom.firstChild.textContent = textContent
			m.redraw!

	onbeforeupdate: !->
		@attrs.items ?= []
		@item = @attrs.items.find ~> @attrs.value in [it, it?value]
		@width? = @attrs.width

	close: !->
		@itemHover = null
		@popper.destroy!
		@popper = null
		m.mount @popperEl
		@popperEl.remove!
		@popperEl = null
		removeEventListener \mousedown @onmousedownWindow, yes

	onclick: (event) !->
		@attrs.onclick? event
		if @popper
			@close!
		else
			@itemHover = @item
			@popperEl = document.createElement \div
			@popperEl.className = "Portal Select-portal #@uuid"
			portalsEl.appendChild @popperEl
			comp =
				oncreate: (vnode) !~>
					index = @attrs.items.indexOf @item
					vnode.dom.children[index]scrollIntoView do
						block: \center
				view: ~>
					m \.Select-menu,
						style: m.style do
							height: innerHeight // 2 - @dom.offsetHeight // 2 - 24
						@attrs.items.map (item) ~>
							if item?
								m \.Select-item,
									class: m.class do
										"Select-itemHover": @itemHover is item
									onclick: !~>
										value = m.resultObj item, \value
										unless @attrs.value is value
											@attrs.onchange? value
										@close!
									onmouseenter: !~>
										@itemHover = item
									onmouseleave: !~>
										@itemHover = null
									m.resultObj item, \text
							else
								m \.Select-divider
			m.mount @popperEl, comp
			@popper = m.popper @dom, @popperEl,
				offsets: [0 -1]
				allowedFlips: <[bottom top]>
				sameWidth: yes
			@popper.forceUpdate!
			addEventListener \mousedown @onmousedownWindow, yes

	onmousedownWindow: (event) !->
		unless event.target.closest ".#@uuid"
			@close!

	onremove: !->
		@close!

	view: ->
		m Button,
			class:
				"disabled": @attrs.disabled
				"Select #@uuid"
				@attrs.class
			alignText: \left
			width: @width
			rightIcon: \sort
			onclick: @onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			m.resultObj @item, \text
