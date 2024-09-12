extends Label

var timeString


func _process(_delta):
	self.text = valueStorage.breakSlideValue
	#print("label saa signaalin:", valueStorage.breakSlideValue)
	pass
#func format_time(minute, second = 0):
	#timeString = "%02d:%02d" % [minute, second]
	#print(timeString)
	#return timeString
	
#func updateBreakLabel():
#	timeString = format_time(valueStorage.breakSlideValue, 0)
	#workLabel.text = timeString
	#print(timeString)
#	self.text = String(timeString)
