Slider = m.comp do
	oninit: !->
		@isHasPointerCapture = no
		@popper = null
		@popperEl = null
		@thumbVref = null

	onbeforeupdate: !->
		@attrs.width ?= 180
		@attrs.min ?= 0
		@attrs.max ?= 10
		@attrs.step or= 1
		@attrs.labelPrecision ?= 2
		@attrs.labelStep or= @attrs.step
		@range = @attrs.max - @attrs.min
		@values = @generatePoints @attrs.step
		@labels = @generatePoints @attrs.step, @attrs.labelPrecision, @attrs.labelRenderer
		@percent = _.clamp (@attrs.value - @attrs.min) / @range * 100 0 100

	generatePoints: (step, precision, renderer) ->
		{min, max} = @attrs
		points = []
		el = document.createElement \input
		el.type = \range
		el.min = min
		el.max = max
		el.step = step
		el.value = min
		loop
			{value} = el
			points.push +value
			el.stepUp!
			break if value is el.value
		for val, i in points
			value = switch
				| renderer => renderer val, i
				| precision? => +val.toFixed precision
				else val
			percent = (val - min) / @range * 100
			points[i] = {value, percent}
		points

	remove: !->
		if @popper
			@popper.destroy!
			@popper = null
			m.mount @popperEl
			@popperEl.remove!
			@popperEl = null

	onpointerdown: (event) !->
		event.target.setPointerCapture event.pointerId
		@attrs.onpointerdown? event
		@isHasPointerCapture = yes
		@popperEl = document.createElement \div
		@popperEl.className = "Slider-tooltip"
		@dom.appendChild @popperEl
		comp =
			view: ~>
				@attrs.value
		m.mount @popperEl, comp
		@popper = m.popper @thumbVref.dom, @popperEl,
			placement: @attrs.vertical and \left or \top
			offsets: [0 4]
			flips: @attrs.vertical and <[top right]> or <[right bottom]>
			allowedFlips: @attrs.vertical and <[left top right]> or <[top right bottom]>
		@onpointermove event, yes

	onpointermove: (event, isPointerDown) !->
		unless isPointerDown
			event.redraw = no
			@attrs.onpointermove? event
		if @isHasPointerCapture
			rect = @dom.getBoundingClientRect!
			percent =
				if @attrs.vertical
					(rect.bottom - event.y - 9) / (rect.height - 18) * 100
				else
					(event.x - rect.x - 9) / (rect.width - 18) * 100
			point = @values.reduce (a, b) ~>
				if Math.abs(a.percent - percent) < Math.abs(b.percent - percent) => a else b
			unless point.value is @attrs.value
				@attrs.onchange? point.value
				@$tick @popper.update
				m.redraw!

	onlostpointercapture: (event) !->
		@isHasPointerCapture = no
		@remove!
		@attrs.onpointerup? event

	onremove: !->
		@remove!

	view: ->
		m \.Slider,
			class: m.class do
				"Slider-isHasPointerCapture": @isHasPointerCapture
				"Slider-fill": @attrs.fill
				"disabled": @attrs.disabled
				"Slider-#{@attrs.vertical and \vertical or \horizontal}"
				@attrs.class
			style: m.style do
				(@attrs.vertical and \height or \width): @attrs.width
				@attrs.style
			onclick: @attrs.onclick
			onmouseenter: @attrs.onmouseenter
			onmouseleave: @attrs.onmouseleave
			onpointerdown: @onpointerdown
			onpointermove: @onpointermove
			onlostpointercapture: @onlostpointercapture
			m \.Slider-input,
				m \.Slider-track,
					style: m.style do
						backgroundImage: "linear-gradient(
							#{if @attrs.vertical => 0 else 90}deg,
							#17b 0,#17b #@percent%,#0000 #@percent%,#0000 100%
						)"
				m \.Slider-labels,
					@labels.map (point) ~>
						m \.Slider-label,
							style: m.style do
								(@attrs.vertical and \bottom or \left): point.percent + \%
							point.value
				@thumbVref =
					m Button,
						class: \Slider-thumb
						style:
							(@attrs.vertical and \bottom or \left): @percent + \%
						active: @isHasPointerCapture
						color: \blue
						ontransitionend: !~>
							@popper?update!
