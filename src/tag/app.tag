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
								button.btn-block.alert.alert-warning(value="0" tabindex="0", onclick="{ toggle }")
									p.text-left 左上({ min[0] })
									p.text-left: strong { prayed[0] }
							.col-xs-6
								button.btn-block.alert.alert-danger(value="1" tabindex="0", onclick="{ toggle }")
									p.text-left 右上({ min[1] })
									p.text-left: strong { prayed[1] }
						.row
							.col-xs-6.col-xs-offset-3
								button.btn-block.alert.alert-default(value="2" tabindex="0", onclick="{ toggle }")
									p.text-left ゲート({ min[2] })
									p.text-left: strong { prayed[2] }
						.row
							.col-xs-6
								button.btn-block.alert.alert-info(value="3", tabindex="0", onclick="{ toggle }")
									p.text-left 左下({ min[3] })
									p.text-left: strong { prayed[3] }
							.col-xs-6
								button.btn-block.alert.alert-success(value="4",tabindex="0", onclick="{ toggle }")
									p.text-left 右下({ min[4] })
									p.text-left: strong { prayed[4] }
				div(show="{ show[0] }")
					p warning
					prpanel(ptitle="左上", pcolor="panel-warning")
				div(show="{ show[1] }")
					p danger
					prpanel(ptitle="右上", pcolor="panel-danger")
				div(show="{ show[2] }")
					p gate
					//gtpanel(ptitle="", pcolor="panel-default")
				div(show="{ show[3] }")
					p info
					prpanel(ptitle="左下", pcolor="panel-info")
				div(show="{ show[4] }")
					p success
					prpanel(ptitle="右下", pcolor="panel-success")
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

		toggle(e) {
			this.show = [false, false, false, false, false]
			let num = Number(e.currentTarget.value)
			this.show[num] = true
			this.prayed[num] = "123,456%"
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
