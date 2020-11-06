Radio = m.comp do
	onbeforeupdate: !->
		@checked = @attrs.checked is @attrs.value

	onclickInput: (event) !->
		unless @checked
			@attrs.onchange? @attrs.value

	view: ->
		m \label.Radio,
			class: m.class do
				"disabled": @attrs.disabled
				@attrs.class
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			m Button,
				class: m.class do
					"Radio-input"
				color: @checked and \blue
				icon: @checked and \circle
				onclick: @onclickInput
			if @children.length
				m \.Radio-text @children
