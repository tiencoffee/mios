ContextMenu = m.bind do
	popper: null
	popperEl: null

	open: (items, evt) !->
		unless @popper
			refEl =
				getBoundingClientRect: ~>
					left: evt.x
					top: evt.y
					right: evt.x
					bottom: evt.y
					width: 0
					height: 0
			@popperEl = document.createElement \div
			@popperEl.className = "Portal ContextMenu Menu-popper"
			@popperEl.tabIndex = 0
			portalsEl.appendChild @popperEl
			@popper = m.popper refEl, @popperEl,
				placement: \right-start
				flips: [\left-start]
				allowedFlips: <[right-start left-start]>
			addEventListener \mousedown @onmousedownWindow, yes
			comp =
				view: ~>
					m Menu,
						items: items
						isContextMenu: yes
						onitemclick: @close
			m.mount @popperEl, comp

	close: !->
		if @popper
			@popper.destroy!
			@popper = null
			m.mount @popperEl, null
			@popperEl.remove!
			@popperEl = null
			removeEventListener \mousedown @onmousedownWindow, yes

	onmousedownWindow: (event) !->
		unless event.target.closest \.ContextMenu
			@close!
