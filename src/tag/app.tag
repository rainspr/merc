app
	section.container
		h3 お祈り計算v4 
			small (更新:{ document.lastModified })
		//jst
		p time
		.row
			.col-md-4
				#gnav
					#layer
						.row
							.col-xs-6
								.alert.alert-warning(type="button", tabindex="0", onclick="{ toggle(0) }")
									p.text-left 左上({ min[0] })
									p.text-left: strong { prayed[0] }
							.col-xs-6
								.alert.alert-danger(type="button", tabindex="0", onclick="{ toggle(1) }")
									p.text-left 右上({ min[1] })
									p.text-left: strong { prayed[1] }
						.row
							.col-xs-6.col-xs-offset-3
								.alert.alert-default(type="button", tabindex="0", onclick="{ toggle(2) }")
									p.text-left ゲート({ min[2] })
									p.text-left: strong { prayed[2] }
						.row
							.col-xs-6
								.alert.alert-info(type="button", tabindex="0", onclick="{ toggle(3) }")
									p.text-left 左下({ min[3] })
									p.text-left: strong { prayed[3] }
							.col-xs-6
								.alert.alert-success(type="button", tabindex="0", onclick="{ toggle(4) }")
									p.text-left 右下({ min[4] })
									p.text-left: strong { prayed[4] }
				div(show="{ show[0] }")
					p warning
					//gldpanel(pcolor="panel-warning")
				div(show="{ show[1] }")
					p danger
					//gldpanel(pcolor="panel-danger")
				div(show="{ show[2] }")
					p gate
					//gatepanel(pcolor="panel-default")
				div(show="{ show[3] }")
					p info
					//gldpanel(pcolor="panel-info")
				div(show="{ show[4] }")
					p success
					//gldpanel(pcolor="panel-success")
			.col-md-8
				p desc
				//gatedesc



	script.
		this.show = [false, false, true, false, false]
		this.min = ["-分", "-分", "-分", "-分", "-分"]
		this.prayed = ["タップしてね", "タップしてね", "タップしてね", "タップしてね", "タップしてね"]

		this.on('mount', () => {
			console.log('app.tag mounted', opts)
		})

		toggle(num) {
			this.show = [false, false, false, false, false]
			this.show[num] = true
		}


	style.
		.alert-default {
			background-color: #f5f5f5;
			border-color: #ddd;
		}
		#gnav {
			background: url("ettaso.jpeg") no-repeat center center;
			background-size: contain;
		}
		#layer {
			background-color: rgba(255,255,255,0.5);
		}
