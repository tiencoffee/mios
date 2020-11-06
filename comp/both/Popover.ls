Popover = m.comp do
	oninit: !->
		@isModel = \isOpen of @attrs
		@isOpen = no
		@popper = null
		@popperEl = null
		@uid = m.uniqId!
		@uids = null
		@rootPopover = void

	onbeforeupdate: (old, first) !->
		unless first
			if @isModel
				@isOpen = @attrs.isOpen

	onupdate: (old) !->
		if @dom
			unless @dom is old.dom
				@dom.$$popover = @
				@dom.dataset.popover = @uid
			@updateIsOpen!
		else
			@changeIsOpen no

	changeIsOpen: (isOpen) !->
		unless @isOpen is isOpen
			@isOpen = isOpen
			@updateIsOpen!
			@attrs.onchange? isOpen

	updateIsOpen: !->
		if @isOpen
			unless @popper
				@popperEl = document.createElement \div
				@popperEl.className = "Portal Popover"
				Popover.insts[@uid] = @
				@uids = [@uid]
				if parentEl = @dom.closest \.Popover
					@uids ++= parentEl.dataset.popovers / \,
					@rootPopover = Popover.insts[@uids[* - 1]]
					@rootPopover.dom.offsetParent.addEventListener \scroll @onscrollOffsetParent, {+passive}
				@popperEl.dataset.popovers = @uids * \,
				portalsEl.appendChild @popperEl
				comp =
					view: ~>
						m \.Popover-content,
							onanimationend: !~>
								Popover.eachOpenPopovers @popperEl, (.popper.forceUpdate!)
							m '[data-popper-arrow]'
							m.resultFn @attrs.content, @, @
				m.mount @popperEl, comp
				@popper = m.popper @dom, @popperEl,
					placement: @attrs.placement
					offsets: @attrs.offsets
					padding: @attrs.padding
					flips: @attrs.flips
					allowedFlips: @attrs.allowedFlips
					sameWidth: @attrs.sameWidth
				@popper.forceUpdate!
				m.redraw!
		else
			if @popper
				@popper.destroy!
				@popper = null
				delete Popover.insts[@uid]
				Popover.eachOpenPopovers @popperEl, (.close!)
				m.mount @popperEl
				@popperEl.remove!
				@popperEl = null
				if @rootPopover
					@rootPopover.dom.offsetParent.removeEventListener \scroll @onscrollOffsetParent, {+passive}
				m.redraw!

	close: !->
		unless @isModel
			@changeIsOpen no

	onscrollOffsetParent: !->
		@popper.update!

	onremove: !->
		@changeIsOpen no

	view: ->
		@children.0
	,,

	insts: {}

	eachOpenPopovers: (el, cb) !->
		targets = el.querySelectorAll '[data-popover]'
		for target in targets
			if popover = Popover.insts[target.dataset.popover]
				cb popover

	eachTargetEls: (el, cb) !->
		targets = el.querySelectorAll '[data-popover]'
		for target in targets
			cb target

	onclickWindow: (event) !->
		for el in event.path
			if el instanceof Element
				if popover = el.$$popover
					unless popover.isModel
						popover.changeIsOpen not popover.isOpen
						m.redraw!
					break

	onmousedownWindow: (event) !->
		if event.which is 1
			targetEl = event.path.find ~>
				it instanceof Element and it.dataset.popover
			otherEl = event.target.closest \.Menu-popper
			unless otherEl
				if popoverEl = event.target.closest \.Popover
					popovers = popoverEl.dataset.popovers
						.split \,
						.map ~> Popover.insts[it]
				else
					popovers = []
				if targetEl
					if popover = Popover.insts[targetEl.dataset.popover]
						popovers.push popover
				for uid, popover of Popover.insts
					unless popovers.includes popover
						unless popover.isModel
							popover.close!

addEventListener \click Popover.onclickWindow, yes
addEventListener \mousedown Popover.onmousedownWindow, yes
