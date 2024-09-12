extends Control
var workMinutes: int = 25
var workSeconds: int = 0
var breakMinutes: int = 5
var breakSeconds: int = 0
var breakMode: bool = false
var minutes: int = 0
var seconds: int = 0
var timeString
var workString
var timerUsed: bool = false

@onready var workLabel = $timerLabels/workTimeLabel
@onready var breakLabel = $timerLabels/breakTimeLabel
@onready var workTimeSlider = $sliders/workTime/workTimeSlider
@onready var breakTimeSlider = $sliders/breakTime/breakTimeSlider
@onready var timer = $timer
@onready var bigLabel = $bigTimeElements
@onready var sliders = $sliders
@onready var workTitle = $bigTimeElements/workTitle
@onready var breakTitle = $bigTimeElements/breakTitle

func _ready() -> void:
	workTimeSlider.value = workMinutes
	breakTimeSlider.value = breakMinutes
	workTimeSlider.connect("value_changed", Callable(self, "_on_work_time_slider_changed"))
	breakTimeSlider.connect("value_changed", Callable(self, "_on_break_time_slider_changed"))
	
func _process(_delta):
	#labelUpdater()
	updateWorkLabel()
	updateBreakLabel()
	updateBigLabel()
	
func _on_timer_timeout() -> void:
	if seconds <= 0:
		if minutes > 0:
			minutes-=1
			seconds = 59
		else:
			timerEnd()
	else:
		seconds -= 1
	print(minutes, ":", seconds)
	if seconds == 0 and minutes == 0:
		timerEnd()
		
func timerEnd():
	timer.stop()
	if breakMode == false:
		switchToBreakTimer()
		breakMode = true
	else:
		switchToWorkTimer()
		breakMode = false
	timer.start()
	
func startTimer():
	#starts in workMode
	if timerUsed == false:
		freshStart()
		timerUsed = true
	timer.start()
	bigTimerModeOn()

func stopTimer():
	timer.stop()
	
func resetTimer():
	timer.stop()
	breakMode = false
	bigTimerModeOff()
	workMinutes = workTimeSlider.value
	workSeconds = 0
	breakMinutes = breakTimeSlider.value
	breakSeconds = 0
	timerUsed = false
	
func _on_work_time_slider_changed(value):
	workMinutes = int(value)
	workSeconds = 0

	
func _on_break_time_slider_changed(value):
	breakMinutes = value
	breakSeconds = 0
	print(breakMinutes)

func format_time(minute, second = 0):
	timeString = "%02d:%02d" % [minute, second]
	return timeString
	
func updateWorkLabel():
	workString = format_time(workTimeSlider.value, workSeconds)
	workMinutes = workTimeSlider.value
	valueStorage.workSlideValue = workString
	
func updateBreakLabel():
	timeString = format_time(breakTimeSlider.value, workSeconds)
	breakMinutes = breakTimeSlider.value
	valueStorage.breakSlideValue = timeString
	
func updateBigLabel():
	var bigString = format_time(minutes, seconds)
	valueStorage.bigTimeValue = bigString
	
func bigTimerModeOn():
	sliders.hide()
	workLabel.hide()
	breakLabel.hide()
	bigLabel.show()

func bigTimerModeOff():
	sliders.show()
	bigLabel.hide()
	workLabel.show()
	breakLabel.show()

func _on_start_button_pressed() -> void:
	startTimer()

func _on_stop_button_pressed() -> void:
	stopTimer()

func _on_reset_button_pressed() -> void:
	resetTimer()

func freshStart():
	breakTitle.hide()
	workTitle.show()
	minutes = workMinutes
	seconds = 0
	
func switchToWorkTimer():
	breakTitle.hide()
	workTitle.show()
	audioPlayer.playGlobalSound(valueStorage.breakOverSound)
	minutes = workMinutes
	seconds = 0
	
func switchToBreakTimer():
	workTitle.hide()
	breakTitle.show()
	audioPlayer.playGlobalSound(valueStorage.workOverSound)
	minutes = breakMinutes
	seconds = 0
