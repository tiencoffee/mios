Img = m.comp do
	onload: !->
		@attrs.onload? it

	view: ->
		m \img,
			src: @attrs.src
			width: @attrs.width
			height: @attrs.height
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			onload: @onload
