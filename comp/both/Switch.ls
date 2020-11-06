Switch = m.comp do
	onbeforeupdate: !->
		@attrs.width or= 40
		@index = Number do
			if @attrs.values => @attrs.checked is that.1
			else @attrs.checked

	onclickInput: (event) !->
		{checked, values} = @attrs
		if values
			checked = if checked is values.0 => values.1 else values.0
		else
			not= checked
		@attrs.onchange? checked

	view: ->
		m \label.Switch,
			class: m.class do
				"disabled": @attrs.disabled
				"Switch-#{@index and \on or \off}"
				@attrs.class
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			m \.Switch-input,
				style: m.style do
					width: @attrs.width
				onclick: @onclickInput
				if @attrs.labels
					m \.Switch-label that[@index]
				m \.Switch-thumb
			if @children.length
				m \.Switch-text @children
