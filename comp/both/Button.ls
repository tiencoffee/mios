Button = m.comp do
	onbeforeupdate: !->
		@attrs.color or= \gray

	view: ->
		m \button.Button,
			class: m.class do
				"Button-minimal": @attrs.minimal
				"Button-onlyIcon": not @children.length
				"active": @attrs.active
				"disabled": @attrs.disabled
				"Button-#{@attrs.color}"
				@attrs.class
			style: m.style do
				width: @attrs.width
				@attrs.style
			onclick: @attrs.onclick
			onmousedown: @attrs.onmousedown
			onmousemove: @attrs.onmousemove
			onmouseup: @attrs.onmouseup
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			onpointerdown: @attrs.onpointerdown
			onpointermove: @attrs.onpointermove
			onpointerup: @attrs.onpointerup
			onlostpointercapture: @attrs.onlostpointercapture
			ontransitionend: @attrs.ontransitionend
			if @attrs.icon
				m Icon,
					class: "Button-icon Button-leftIcon"
					name: that
			if @children.length
				m \.Button-text,
					style: m.style do
						textAlign: @attrs.alignText
					@children
			if @attrs.rightIcon
				m Icon,
					class: "Button-icon Button-rightIcon"
					name: that
