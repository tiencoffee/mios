NumberInput = m.comp do
	oninit: !->
		@inputVref = null

	onbeforeupdate: !->
		@attrs.width ?= 180

	step: (delta) !->
		method = delta > 0 and \stepUp or \stepDown
		inputEl = @inputVref.state.inputVref.dom
		for i til Math.abs delta
			inputEl[method]!
		evt = m.event \input,
			target: inputEl
		@onchangeInput inputEl.value, evt
		m.redraw!

	onmousedownButton: (delta) !->
		@step delta
		@buttonTimeoutId = setTimeout !~>
			@step delta
			@buttonIntervalId = setInterval !~>
				@step delta
			, 50
		, 300
		addEventListener \mouseup @onmouseupWindow

	onmouseupWindow: !->
		clearTimeout @buttonTimeoutId
		clearInterval @buttonIntervalId
		removeEventListener \mouseup @onmouseupWindow

	onchangeInput: (val, evt) !->
		@attrs.onchange? val, evt

	onwheelInput: !->

	onremove: !->
		@onmouseupWindow!

	view: ->
		m ControlGroup,
			class:
				"disabled": @attrs.disabled
				"NumberInput"
				@attrs.class
			width: @attrs.width
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			@inputVref =
				m TextInput,
					class: "NumberInput-input"
					type: \number
					min: @attrs.min
					max: @attrs.max
					step: @attrs.step
					required: @attrs.required
					placeholder: @attrs.placeholder
					value: @attrs.value
					tooltip: @attrs.tooltip
					onchange: @onchangeInput
					onwheel: @onwheelInput
			m \.NumberInput-buttons,
				m Button,
					class: "NumberInput-button NumberInput-buttonUp"
					icon: \far:angle-up
					onmousedown: !~>
						@onmousedownButton 1
					onmouseup: @mouseupButton
				m Button,
					class: "NumberInput-button NumberInput-buttonDown"
					icon: \far:angle-down
					onmousedown: !~>
						@onmousedownButton -1
					onmouseup: @mouseupButton
