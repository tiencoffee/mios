Checkbox = m.comp do
	onbeforeupdate: !->
		@isCheckList = Array.isArray @attrs.checked
		@checked =
			if @isCheckList => @attrs.checked.includes @attrs.value
			else @attrs.checked

	onclickInput: (event) !->
		if @isCheckList
			index = @attrs.checked.indexOf @attrs.value
			if index < 0
				@attrs.checked.push @attrs.value
			else
				@attrs.checked.splice index, 1
		@attrs.onchange? not @checked

	view: ->
		m \label.Checkbox,
			class: m.class do
				"disabled": @attrs.disabled
				@attrs.class
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			m Button,
				class: m.class do
					"Checkbox-input"
				color: @checked and \blue
				icon: @checked and \far:check
				onclick: @onclickInput
			if @children.length
				m \.Checkbox-text @children
