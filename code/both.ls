os = null

m <<<
	uniqIdVal: 0
	requiredPkgs: []
	cssUnitless:
		animationIterationCount: yes
		borderImageOutset: yes
		borderImageSlice: yes
		borderImageWidth: yes
		boxFlex: yes
		boxFlexGroup: yes
		boxOrdinalGroup: yes
		columnCount: yes
		columns: yes
		flex: yes
		flexGrow: yes
		flexPositive: yes
		flexShrink: yes
		flexNegative: yes
		flexOrder: yes
		gridArea: yes
		gridRow: yes
		gridRowEnd: yes
		gridRowSpan: yes
		gridRowStart: yes
		gridColumn: yes
		gridColumnEnd: yes
		gridColumnSpan: yes
		gridColumnStart: yes
		fontWeight: yes
		lineClamp: yes
		lineHeight: yes
		opacity: yes
		order: yes
		orphans: yes
		tabSize: yes
		widows: yes
		zIndex: yes
		zoom: yes
		fillOpacity: yes
		floodOpacity: yes
		stopOpacity: yes
		strokeDasharray: yes
		strokeDashoffset: yes
		strokeMiterlimit: yes
		strokeOpacity: yes
		strokeWidth: yes

	class: (...clses) ->
		res = []
		for cls in clses
			if Array.isArray cls
				res.push m.class ...cls
			else if cls instanceof Object
				for k, v of cls
					res.push k if v
			else if cls?
				res.push cls
		res * " "

	style: (...styls) ->
		res = {}
		for styl in styls
			if Array.isArray styl
				styl = m.style ...styl
			if styl instanceof Object
				for k, val of styl
					res[k] = val
					res[k] += \px if not m.cssUnitless[k] and +val
		res

	event: (name, init) ->
		currentTarget: init.currentTarget or init.target
		target: init.target
		timeStamp: performance.now!
		type: name

	bind: (obj, thisArg = obj) ->
		for k, val of obj
			if typeof val is \function and val.name isnt /(bound|class) /
				obj[k] = val.bind thisArg
		obj

	rand: (min, max) ->
		switch &length
		| 0 =>
			max = 1
			min = 0
		| 1 =>
			max = min
			min = 0
		Math.floor min + Math.random! * (1 + Math.abs max - min)

	uuid: ->
		"u#{m.rand 9e9}#{m.uniqId!}#{Date.now!}"

	uniqId: ->
		++m.uniqIdVal

	resultFn: (fn, thisArg, ...args) ->
		if typeof fn is \function => fn.apply thisArg, args else fn

	resultObj: (obj, prop) ->
		if typeof! obj is \Object => obj[prop] else obj

	preventDefault: !->
		it.preventDefault!

	fetch: (url, dataType = \text) ->
		type = dataType
		type = \text if type is \yaml
		data = await (await fetch url)[type]!
		if dataType is \yaml
			data = m.loadYaml data
		data

	tabToSpace: (code) ->
		code.replace /(?<=^|\n)\t*(?!\n)/g ~> "  " * it.length

	indent: (code, lv = 1, noFirstLine) ->
		regex = noFirstLine and /(?<=\n)\t*(?!\n)/g or /(?<=^|\n)\t*(?!\n)/g
		code.replace regex, ~>
			len = it.length + lv
			len = 0 if len < 0
			\\t * len

	loadYAML: (text) ->
		text = m.tabToSpace text
		jsyaml.safeLoad text

	dumpYAML: (data) ->
		jsyaml.safeDump data

	require: (...pkgs) !->
		code = ""
		for pkg in pkgs
			unless m.requiredPkgs[pkg]
				code += await (await fetch "//cdn.jsdelivr.net/npm/#pkg")text!
				m.requiredPkgs[pkg]
		window.eval code if code

	popper: (refEl, popperEl, attrs = {}) ->
		modifiers =
			* name: \offset
				options:
					offset: attrs.offsets
			* name: \preventOverflow
				options:
					padding: attrs.padding
			* name: \flip
				options:
					fallbackPlacements: attrs.flips
					allowedAutoPlacements: attrs.allowedFlips
			* name: \transformOrigin
				enabled: yes
				phase: \beforeWrite
				fn: ({state}) !~>
					if arrow = state.modifiersData.arrow
						{x, y} = arrow
						state.styles{}popper <<<
							webkitTransformOriginX: x + \px
							webkitTransformOriginY: y + \px
		if attrs.sameWidth
			modifiers.push do
				name: \sameWidth
				enabled: yes
				phase: \beforeWrite
				fn: ({state}) !~>
					if sameWidth = attrs.sameWidth
						{width} = state.rects.reference
						if typeof sameWidth is \number
							width <?= sameWidth
						state.styles{}popper.minWidth = width + \px
		Popper.createPopper refEl, popperEl,
			placement: attrs.placement ? \auto
			strategy: \fixed
			modifiers: modifiers

	comp: (opts,, statics) ->
		comp = ->
			old = null
			ticks = []
			vdom = {}
			vdom <<< opts
			vdom <<<
				$$oninit: opts.oninit or ->
				$$oncreate: opts.oncreate or ->
				$$onbeforeupdate: opts.onbeforeupdate or ->
				$$onupdate: opts.onupdate or ->
				$$onbeforeremove: opts.onbeforeremove or ->
				$$onremove: opts.onremove or ->
				$tick: (fn) !->
					ticks.push fn if typeof fn is \function
				oninit: !->
					@{attrs or {}, children or []} = it
					@dom = null
					old :=
						attrs: {...@attrs}
						children: [...@children]
						dom: null
					@$$oninit!
					@$$onbeforeupdate old, yes
				oncreate: !->
					@dom = it.dom
					@$$oncreate!
					@$$onupdate old, yes
				onbeforeupdate: ->
					@{attrs or {}, children or []} = it
					@$$onbeforeupdate old
				onupdate: !->
					@dom = it.dom
					if ticks.length
						for tick in ticks
							tick!
						ticks := []
					@$$onupdate old
					old :=
						attrs: {...@attrs}
						children: [...@children]
						dom: @dom
				onbeforeremove: ->
					@$$onbeforeremove!
				onremove: !->
					@$$onremove!
			m.bind vdom
		comp <<< statics
		m.bind comp
