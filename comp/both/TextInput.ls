TextInput = m.comp do
	oninit: !->
		@isFocus = no
		@inputVref = null

	onbeforeupdate: !->
		@attrs.type ?= \text
		@attrs.width ?= 180
		if @attrs.icon
			@attrs.element = m Icon, name: that
		if @attrs.rightIcon
			@attrs.rightElement = m Icon, name: that

	oncontextmenu: (event) !->
		@attrs.oncontextmenu? event
		ContextMenu.open [
			* text: "Hoàn tác"
				icon: \undo
				label: \Ctrl+Z
				onclick: !~>
					document.execCommand \undo
			* text: "Làm lại"
				icon: \redo
				label: \Ctrl+Y
				onclick: !~>
					document.execCommand \redo
			,,
			* text: "Chọn tất"
				label: \Ctrl+A
				onclick: !~>
					@inputVref.dom.select!
		] event

	view: ->
		m \.TextInput,
			class: m.class do
				"TextInput-isFocus": @isFocus
				"TextInput-fill": @attrs.fill
				"disabled": @attrs.disabled
				@attrs.class
			style: m.style do
				width: @attrs.width
				@attrs.style
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			oncontextmenu: @oncontextmenu
			onfocusout: !~>
				if it.relatedTarget?closest \.ContextMenu
					it.target.focus!
			if @attrs.element
				m \.TextInput-element.TextInput-leftElement,
					that
			m Tooltip,
				content: @attrs.tooltip
				@inputVref =
					m \input.TextInput-input,
						type: @attrs.type
						min: @attrs.min
						max: @attrs.max
						minLength: @attrs.minLength
						maxLength: @attrs.maxLength
						step: @attrs.step
						required: @attrs.required
						placeholder: @attrs.placeholder
						value: @attrs.value
						oninput: !~>
							@attrs.onchange? it.target.value, it
						onfocus: !~>
							@isFocus = yes
							@attrs.onfocus? it
						onblur: !~>
							@isFocus = no
							@attrs.onblur? it
						oncut: @attrs.oncut
						oncopy: @attrs.oncopy
						onpaste: @attrs.onpaste
						onwheel: @attrs.onwheel
			if @attrs.rightElement
				m \.TextInput-element.TextInput-rightElement,
					that
