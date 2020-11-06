Icon = m.comp do
	onbeforeupdate: !->
		@attrs.width ?= 16
		{name} = @attrs
		name += ""
		[@kind, @val] = match name
		| /^\/\//
			[\https name]
		| /^\d+$/
			[\flaticon name]
		| /^(?!fa[srldb]?:)/
			[\fas name]
		else name / \:
		match @kind
		| \flaticon
			@val = "//flaticon.com/svg/static/icons/svg/#{@val.slice 0 -3}/#@val.svg"
		| /fa[srldb]?/
			@val = "#@kind fa-#@val"

	onload: !->
		@attrs.onload? it
		m.redraw!

	view: ->
		switch @kind
		| \https \http \flaticon
			m \img.Icon.Icon-img,
				class: m.class @attrs.class
				style: m.style @attrs.style
				src: @val
				width: @attrs.width
				height: @attrs.width
				onload: @onload
		else
			m \.Icon.Icon-text,
				class: m.class do
					@val
					@attrs.class
				style: m.style do
					fontSize: @attrs.width
					@attrs.style
