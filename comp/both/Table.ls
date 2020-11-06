Table = m.comp do
	view: ->
		m \.Table,
			class: m.class do
				"Table-bordered": @attrs.bordered
				"Table-striped": @attrs.striped
				"Table-interactive": @attrs.interactive
				"Table-fill": @attrs.fill
				"Table-hasHeader": @attrs.header
				@attrs.class
			style: m.style do
				width: @attrs.width
				maxHeight: @attrs.maxHeight
				@attrs.style
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			m \table.Table-content,
				@attrs.header
				@children
