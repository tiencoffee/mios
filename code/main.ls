App = m.comp do
	oninit: !->
		@colors = <[gray red yellow green blue]>
		@textInput = "Văn bản"
		@numberInput = 13
		@checks = <[farfetchd eiscue]>
		@radio = 200
		@popoverIsOpen = yes
		@bool = yes
		@isShowPopoverComp = yes
		@isShowPopoverButton = yes
		@disabled = no
		@menuItems =
			* text: "Chọn"
				color: \blue
				icon: \check-circle
			,,
			* text: "Sắp xếp theo"
				icon: \sort-amount-down
				items:
					* text: "Tên"
						onclick: !~>
							console.log 4
					* text: "Ngày"
					* text: "Loại"
					,,
					* text: "Tùy chỉnh..."
			* text: "Làm mới"
				color: \green
			,,
			* text: "Xóa"
				color: \red
				icon: \trash-alt
				label: \Delete
			* text: "Ngôn ngữ"
				color: \yellow
				items:
					* text: "Việt Nam"
						icon: 197473
					* text: "Anh"
						icon: 197374
						items:
							* text: "Anh"
								icon: 197374
							* text: "Mỹ"
								icon: 197484
							* text: "Canada"
								icon: 197430
							* text: "Úc"
								icon: 197507
					* text: "Nhật Bản"
						icon: 197604
					* text: "Hàn Quốc"
						icon: 197582
					* text: "Trung Quốc"
						icon: 197375
					* text: "Nga"
						icon: 197408
					* text: "Các tiểu vương quốc Ả Rập thống nhất"
						icon: 197569
					* text: "Pháp"
						icon: 197560
					* text: "Đức"
						icon: 197571
					* text: "Tây Ban Nha"
						icon: 197593
						items:
							* text: "Tây Ban Nha"
								icon: 197593
							* text: "Mexico"
								icon: 197397
					* text: "Bồ Đào Nha"
						icon: 197463
						items:
							* text: "Bồ Đào Nha"
								icon: 197463
							* text: "Brazil"
								icon: 197386
					* text: "Thái Lan"
						icon: 197452
			* text: "Tìm kiếm trên Google"
				disabled: yes
				icon: \fab:google
			* text: "Thông tin..."
				icon: \info
		@selectItems =
			* text: "Rết"
				value: \ret
			* text: "Vượn đen má trắng"
				value: yes
			* text: "Rồng đất"
				value: no
			* text: "Khủng long bạo chúa"
				value: null
			,,
			* text: "Sao biển"
				value: p: 2
			* text: "Rái cá"
				value: "rai ca"
			* text: "Chim cánh cụt hoàng đế"
				value: 1
			"Khỉ đầu chó"
			-493.1024
			,,
			* text: "Gà 🐔"
				value: [4 \chicken]
			,,
			* text: 123
				value: 456
			* text: "<empty>"
				value: ""
			* text: "Đại bàng"
				value: \dai-bang
		@table =
			* text: "Samurott"
				icon: \//serebii.net/pokedex-swsh/icon/503.png
				type: "Water"
			* text: "Beedrill (Mega)"
				icon: \//serebii.net/pokedex-swsh/icon/015-m.png
				type: "Bug / Poison"
			* text: "Stonjourner"
				icon: \//serebii.net/pokedex-swsh/icon/874.png
				type: "Rock"
			* text: "Darmanitan (Galarian Form Zen Mode)"
				icon: \//serebii.net/pokedex-swsh/icon/555-gz.png
				type: "Ice / Fire"
			* text: "Exeggutor (Galarian Form)"
				icon: \//serebii.net/pokedex-swsh/icon/103-a.png
				type: "Grass / Dragon"
			* text: "Gyarados"
				icon: \//serebii.net/pokedex-swsh/icon/130.png
				type: "Water / Flying"
			* text: "Sawsbuck (Autumn Form)"
				icon: \//serebii.net/pokedex-swsh/icon/586-a.png
				type: "Normal / Grass"
			* text: "Shellos (East Sea)"
				icon: \//serebii.net/pokedex-swsh/icon/422-e.png
				type: "Water"
			* text: "Kyurem"
				icon: \//serebii.net/pokedex-swsh/icon/646.png
				type: "Dragon / Ice"
		@selectVal = "rai ca"
		addEventListener \contextmenu @oncontextmenu
		addEventListener \keydown @onkeydown

	oncontextmenu: (event) !->
		event.preventDefault!
		ContextMenu.open @menuItems, event

	onkeydown: (event) !->
		{ctrlKey, shiftKey, altKey} = event
		switch event.code
		| \KeyD
			if !ctrlKey and !shiftKey and !altKey
				not= @popoverIsOpen
				m.redraw!

	view: ->
		m \.full.scroll.p-3,
			m \p Math.round performance.now!
			m Button,
				class: \mr-3
				onclick: !~>
					not= @bool
				"Bool: #@bool"
			m Checkbox,
				class: \mr-3
				checked: @disabled
				onchange: (@disabled) !~>
				"Disabled"
			m Dialog
			m Table,
				class: \my-3
				bordered: yes
				striped: yes
				interactive: yes
				maxHeight: 200
				header:
					m \tr,
						m \th \Icon
						m \th \Tên
						m \th \Hệ
				@table.map (item) ~>
					m \tr,
						m \td,
							m Icon,
								name: item.icon
								size: \auto
						m \td item.text
						m \td item.type
			m Slider,
				class: \m-1
				disabled: @disabled
				min: 4.3
				max: 10.7
				step: 1.3
				value: @numberInput
				onchange: (@numberInput) !~>
			m Slider,
				class: \m-1
				vertical: yes
				disabled: @disabled
				min: 4.3
				max: 10.7
				step: 1.3
				value: @numberInput
				onchange: (@numberInput) !~>
			m Button,
				onclick: !~>
					not= @popoverIsOpen
				+@popoverIsOpen
			if @isShowPopoverComp
				m Popover,
					content: (popover) ~>
						m \.p-3,
							m \b.mb-3.block "Nhập tên bạn:"
							m TextInput,
								fill: yes
								tooltip: "Viết IN HOA không dấu"
							m \b.mt-3.block "Tuổi của bạn:"
							m Slider,
								class: \mb-3
								fill: yes
								value: @numberInput
								onchange: (@numberInput) !~>
							m ControlGroup,
								class: \mt-3
								fill: yes
								alignItems: \right
								m Button,
									onclick: !~>
										not= @popoverIsOpen
									+@popoverIsOpen
								m Popover,
									isOpen: @popoverIsOpen
									onchange: (@popoverIsOpen) !~>
									content:
										m \.p-3.w-min,
											m \b.mb-3.block "Shizukumo"
											m Img,
												src: \//cdn.bulbagarden.net/upload/thumb/4/41/Dewpider_anime.png/800px-Dewpider_anime.png
												width: 320
											m \p,
												"Shizukumo tạo ra một quả bóng nước ở sau rồi lấy nó che đầu. Khi gặp bạn bè, chúng sẽ so sánh kích cỡ bóng nước."
									m Button,
										"Mở tiếp..."
								m Popover,
									parent: popover
									content: (popover2) ~>
										m Menu,
											minimal: yes
											items: @menuItems
											onitemclick: popover2.close
									m Button,
										"Mở menu..."
								m Button,
									color: \red
									onclick: popover.close
									"Đóng"
					if @isShowPopoverButton
						m Button,
							class: \m-1
							disabled: @disabled
							"Mở popover..."
			m Button,
				onclick: !~>
					not= @isShowPopoverComp
				"comp: #@isShowPopoverComp"
			m Button,
				onclick: !~>
					not= @isShowPopoverButton
				"button: #@isShowPopoverButton"
			m PasswordInput,
				class: \m-1
				disabled: @disabled
			m Tooltip,
				content: "Đây là tooltip"
				m \b.inline-block.m-3,
					"m Button, 45"
			m Select,
				disabled: @disabled
				items: @selectItems
				value: @selectVal
				onchange: (@selectVal) !~>
			m NumberInput,
				class: \m-1
				disabled: @disabled
				value: @numberInput
				tooltip: "Giá trị hiện tại là: #@numberInput"
				onchange: (@numberInput) !~>
			m ControlGroup,
				class: \m-1
				disabled: @disabled
				m TextInput
				m Button,
					"A"
				m Button,
					color: \red
					"B"
				m Button,
					"C"
			m Switch,
				class: \mr-3
				disabled: @disabled
				checked: @radio
				values: [100 200]
				onchange: (@radio) !~>
			m Switch,
				class: \mr-3
				disabled: @disabled
				checked: @radio
				values: [100 200]
				labels: <[Tắt Bật]>
				onchange: (@radio) !~>
			m Radio,
				class: \mr-3
				disabled: @disabled
				checked: @radio
				value: 100
				onchange: (@radio) !~>
				100
			m Radio,
				class: \mr-3
				disabled: @disabled
				checked: @radio
				value: 200
				onchange: (@radio) !~>
				200
			m \p @radio
			m Checkbox,
				disabled: @disabled
				class: \mr-3
				checked: @checks
				value: \farfetchd
				"farfetch'd"
			m Checkbox,
				disabled: @disabled
				class: \mr-3
				checked: @checks
				value: \tapuKoko
				"Tapu Koko"
			m Checkbox,
				disabled: @disabled
				class: \mr-3
				checked: @checks
				value: \muk
				"Muk"
			m Checkbox,
				disabled: @disabled
				class: \mr-3
				checked: @checks
				value: \eiscue
				"Eiscue"
			m Checkbox,
				disabled: @disabled
				checked: @checks
				value: \nidoranF
				"Nidoran♀"
			m \p @checks * ", "
			m Menu,
				items: @menuItems
			m TextInput,
				class: \m-1
				disabled: @disabled
				icon: 679675
				rightElement:
					m Button,
						minimal: yes
						icon: \far:smile
			m TextInput,
				class: \m-1
				disabled: @disabled
				value: @textInput
				onchange: (@textInput) !~>
			m \p @textInput
			[1 to 6]map ~>
				m "h#it" "Tiêu đề H#it"
			m \p m.trust 'Được biết, <b>Asbestos</b> có nghĩa là amiăng - một loại sợi độc hại gây <small>ung thư</small>. Cho rằng cái tên này <i>"quá độc hại"</i>, nên người dân trong vùng quyết định đổi sang cái tên mới. Trong tương lai, thị trấn sẽ có tên khác là Val-des-Sources (tạm dịch: thung lũng của những con suối), mặc dù trước đó, người dân địa phương từng rất tự hào về cái tên cũ của họ.'
			m Icon,
				name: \keyboard
			m Icon,
				name: 679679
			m Button,
				class: \m-1
				disabled: @disabled
				"Abg"
			m Button,
				class: \m-1
				disabled: @disabled
				icon: \search
				"Tìm kiếm"
			m Button,
				class: \m-1
				disabled: @disabled
				rightIcon: \backspace
				"Xóa"
			m Button,
				class: \m-1
				disabled: @disabled
				icon: \car-side
			@colors.map (color) ~>
				m Button,
					class: \m-1
					disabled: @disabled
					color: color
					color
			@colors.map (color) ~>
				m Button,
					class: \m-1
					minimal: yes
					disabled: @disabled
					color: color
					color

m.mount appEl, App
