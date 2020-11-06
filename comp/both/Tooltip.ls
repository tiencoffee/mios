Tooltip = m.comp do
	oninit: !->
		@isOpen = no
		@popper = null
		@popperEl = null
		@oldWidth = 0
		@oldHeight = 0

	onupdate: (old) !->
		if @attrs.content?
			if @dom
				unless @dom is old.dom
					@dom.$$tooltip = @
					@dom.dataset.tooltip = ""
				@updateIsOpen!
			else
				@changeIsOpen no
		else
			@changeIsOpen no
		@popper?update!

	changeIsOpen: (isOpen) !->
		unless @isOpen is isOpen
			@isOpen = isOpen
			@updateIsOpen!
			@attrs.onchange? isOpen

	updateIsOpen: !->
		if @isOpen
			unless @popper
				@popperEl = document.createElement \div
				@popperEl.className = "Portal Tooltip"
				portalsEl.appendChild @popperEl
				comp =
					view: ~>
						m \.Tooltip-content,
							m.resultFn @attrs.content,, @
				m.mount @popperEl, comp
				@popper = m.popper @dom, @popperEl,
					offsets: [0 4]
				m.redraw!
		else
			if @popper
				@popper.destroy!
				@popper = null
				m.mount @popperEl
				@popperEl.remove!
				@popperEl = null
				m.redraw!

	onremove: !->
		@changeIsOpen no

	view: ->
		@children.0
	,,

	onmouseoverWindow: (event) !->
		if event.target instanceof Element
			if tooltipEl = event.target.closest '[data-tooltip]'
				tooltip = tooltipEl.$$tooltip
				unless tooltip.isOpen
					tooltip.changeIsOpen yes
					onmouseleaveTooltip = !~>
						unless document.activeElement is tooltipEl
							tooltip.changeIsOpen no
							tooltipEl.removeEventListener \mouseleave onmouseleaveTooltip
							tooltipEl.removeEventListener \blur onmouseleaveTooltip
					tooltipEl.addEventListener \mouseleave onmouseleaveTooltip
					tooltipEl.addEventListener \blur onmouseleaveTooltip

addEventListener \mouseover Tooltip.onmouseoverWindow, yes
addEventListener \focus Tooltip.onmouseoverWindow, yes
