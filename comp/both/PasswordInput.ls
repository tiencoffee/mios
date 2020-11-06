PasswordInput = m.comp do
	oninit: !->
		@isHidePassword = yes
		@inputVref = null

	oncontextmenu: (event) !->
		@attrs.oncontextmenu? event
		ContextMenu.open [
			* text: "#{@isHidePassword and \Hiện or \Ẩn} mật khẩu"
				icon: @isHidePassword and \eye or \eye-slash
				onclick: !~>
					not= @isHidePassword
			,,
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
					@inputVref.state.inputVref.dom.select!
		] event

	view: ->
		@inputVref =
			m TextInput,
				class:
					"PasswordInput-isHidePassword": @isHidePassword
					"disabled": @attrs.disabled
					"PasswordInput"
					@attrs.class
				minLength: @attrs.minLength
				maxLength: @attrs.maxLength
				required: @attrs.required
				placeholder: @attrs.placeholder
				value: @attrs.value
				onchange: @attrs.onchange
				oncut: m.preventDefault
				oncopy: m.preventDefault
				onclick: @attrs.onclick
				onmouseenter: @attrs.onmouseenter
				onmouseleave: @attrs.onmouseleave
				oncontextmenu: @oncontextmenu
				rightElement:
					m Button,
						minimal: yes
						icon: @isHidePassword and \eye or \eye-slash
						onclick: !~>
							not= @isHidePassword
