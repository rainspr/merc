prpanel
	.panel(class="{ opts.pcolor }")
		.panel-heading
			h4.panel-title { opts.ptitle }: { this.prayed } ({ this.minUpdated })
		.panel-body
			form(ref="formref", onsubmit="return false;")
				fieldset.form-group
					label.radio-inline(each="{ elem }") #[input(type="radio", name="elemRadio", value="{ value }", onchange="{ setFilter }")] { text }
				fieldset.form-group
					select.form-control(ref="seedname")
				//fieldset.form-group
				//	select.form-control(ref="digitSelect")
				//fieldset.form-group
				//  .row
				//    .col-xs-6
				//      select.form-control(name="sizeSelect", onchange="{ setVal }")
				//        option(each="{ size }", value="{ value }") { text }
				//    .col-xs-6
				//      select.form-control(name="waveSelect", onchange="{ setVal }")
				//        option(each="{ wave }", value="{ value }") { text }

	script.
		var self = this
		import {seedDef} from '../js/seedlist.js'
		this.prayed = "-%"
		this.minUpdated = "-分"
		this.eRadio = []
		self.seedFiltered = []
		this.seedObj = {}
		this.seedSelectized = []
		this.elem = [
			{ text: "すべて", value: "all" },
			{ text: "炎", value: "fire" },
			{ text: "水", value: "water" },
			{ text: "風", value: "wind" },
			{ text: "光", value: "light" },
			{ text: "闇", value: "dark" }
		]

		setFilter() {
			console.log(this.eRadio)
			if(this.eRadio.value === "all") {
				self.seedFiltered = seedDef
			} else {
				self.seedFiltered = seedDef.filter(s => s.elm === this.eRadio.value)[0]
			}
			refreshSelect(this.seedSelectized[0], self.seedFiltered)
		}

		function refreshSelect(s,t) {
			s.selectize.clearOptions()
			s.selectize.addOption(t)
			s.selectize.refreshOptions()
		}

		this.on('mount', () => {
			this.eRadio = this.refs.formref.elemRadio
			this.eRadio[0].checked = true
			this.setFilter()
			$(function() {
				this.seedSelectized = $(self.refs.seedname).selectize({
					options: self.seedFiltered,
					valueField: "name",
					labelField: "name",
					searchField: ["extname"],
					placeholder: "シード名"
				})
			})
		})

		/*
		var self = this
		self.selectizedSeed = []
		self.selectizedDigit = []
		self.clockmin = ""
		self.objModal = {
			elemRadio: "all",
			gateRadio: "all",
			seedName: "",
			seedDesc: {},
			digitSelect: "0",
			sizeSelect: "1.72",
			waveSelect: "1.0",
			prayed: "-%",
			minUpdated: "-分"
		}
		self.seedDefault = seed.map(function(obj) {
			obj.extname += obj.name + convertToHira(obj.name)
			obj.elm += "all"
			return obj
		})
		setFilter(e) {
			self.objModal[e.target.name] = e.target.value
			filterSeed()
		}
		setVal(e) {
			self.objModal[e.target.name] = e.target.value
			calc()
		}
		obs.on('onclock', function(clockmin){
			self.clockmin = clockmin
		})
		function calc() {
			self.objModal.seedDesc = setSeed(self.objModal.seedName)
			self.objModal.prayed = setPray(self.objModal) + "%"
			self.objModal.minUpdated = self.clockmin
			self.update()
			obs.trigger('oncalc', opts.refname, self.objModal.prayed)
		}
		function convertToHira(str) {
			return str.replace(/[\u30a1-\u30f6]/g, function (match) {
				var chr = match.charCodeAt(0) - 0x60
				return String.fromCharCode(chr)
			})
		}
		function setSeed(seedname) {
			var obj = self.seedDefault.filter(function(seed,index) {
				if(seed.name === seedname) return true
			})
			if(obj) {
				return obj[0]
			}
		}
		function calcPray(seedhp,seedsize,inputhp,scale,wave) {
			return Math.round((inputhp / (seedhp/seedsize*scale) -1) * 100 / wave)
		}
		function setPray(obj) {
			var seedhp = obj.seedDesc.hp
			var seedsize = obj.seedDesc.size
			var inputhp = Number(obj.digitSelect)
			var scale = Number(obj.sizeSelect)
			var wave = Number(obj.waveSelect)
			var pray = calcPray(seedhp,seedsize,inputhp,scale,wave)
			if(pray>0) {
				return pray.toLocaleString()
			} else return "0"
		}
		function filterSeed() {
			self.seedFiltered = self.seedDefault.filter(function(seed,index) {
				if((seed.elm).indexOf(self.objModal.elemRadio) >= 0) {
					if(self.objModal.gateRadio === "gateonly") {
						if(seed.gate === true) return true
					} else return true
				}
			})
			self.selectizedSeed[0].selectize.clearOptions()
			self.selectizedSeed[0].selectize.addOption(self.seedFiltered)
			self.selectizedSeed[0].selectize.refreshOptions()
		}
		function formatDigit(val,dig) {
			return val * Math.pow(10, dig - String(val).length)
		}
		self.elem = [
			{ text: "すべて", value: "all" },
			{ text: "炎", value: "fire" },
			{ text: "水", value: "water" },
			{ text: "風", value: "wind" },
			{ text: "光", value: "light" },
			{ text: "闇", value: "dark" }
		]
		self.isgate = [
			{ text: "すべて", value: "all" },
			{ text: "ゲートから出るもののみ", value: "gateonly" }
		]
		self.size = [
			{ text: "1.72", value: 1.72 },
			{ text: "1.75", value: 1.75 },
			{ text: "1.80", value: 1.80 },
			{ text: "1.00", value: 1.00 }
		]
		self.wave = [
			{ text: "1体目", value: 1.0 },
			{ text: "2体目", value: 1.2 },
			{ text: "3体目", value: 1.4 },
			{ text: "4体目", value: 1.6 },
			{ text: "5体目", value: 1.8 }
		]
		self.on('mount', function() {
			self.refs.formref.elemRadio.value = "all"
			self.refs.formref.gateRadio.value = "all"
			self.seedFiltered = self.seedDefault

			$(function(){
				self.selectizedSeed = $(self.refs.seedName).selectize({
					options: self.seedFiltered,
					valueField: "name",
					labelField: "name",
					searchField: ["extname"],
					placeholder: "シード名"
				})
				self.selectizedDigit = $(self.refs.digitSelect).selectize({
					options: [],
					valueField: "value",
					labelField: "text",
					searchField: ["value"],
					placeholder: "体力",
					load: function(query, callback) {
						if(!query.length) return callback()
						query = Number(query)
						callback([
							{ text: formatDigit(query, 6).toLocaleString(), value: formatDigit(query, 6) },
							{ text: formatDigit(query, 7).toLocaleString(), value: formatDigit(query, 7) },
							{ text: formatDigit(query, 8).toLocaleString(), value: formatDigit(query, 8) },
							{ text: formatDigit(query, 9).toLocaleString(), value: formatDigit(query, 9) },
							{ text: formatDigit(query, 10).toLocaleString(), value: formatDigit(query, 10) }
						])
					}
				})
				self.selectizedSeed.on('change', function(){
					if(this.value){
						self.objModal.seedName = self.selectizedSeed.val()
						calc()
					}
				})
				self.selectizedDigit.on('change', function(){
					if(this.value){
						self.objModal.digitSelect = self.selectizedDigit.val()
						calc()
					}
				})
			})
		})
		*/

	style.
		.panel-heading {
			border-top-left-radius: inherit;
			border-top-right-radius: inherit;
		}
