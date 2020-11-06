ControlGroup = m.comp do
	view: ->
		m \fieldset.ControlGroup,
			class: m.class do
				"ControlGroup-fill": @attrs.fill
				"ControlGroup-alignItems-#{@attrs.alignItems}"
				"disabled": @attrs.disabled
				@attrs.class
			style: m.style do
				width: @attrs.width
				@attrs.style
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			@children
