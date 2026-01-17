@tool

extends Label

@export var value : int = 0 :
	set(x):
		value = x
		update_text()
		
@export var prefix : String:
	set(x):
		prefix = x
		update_text()

@export_range(1, 50) var digits : int = 10:
	set(x):
		digits = x
		update_text()

func _ready():
	update_text()

# I didn't fiund out how to make this work
#@export_range(1, 50) var text_size : int = 10:
	#set(x):
		#text_size = x
		#var theme_name = ''
		
		#if self.has_theme_font_size_override(theme_name):
			#self.remove_theme_font_size_override(theme_name)
			#$ValueLabel.remove_theme_font_size_override(theme_name)
		#self.add_theme_font_size_override(theme_name, x)
		#$ValueLabel.add_theme_font_size_override(theme_name, x)

func update_text():
	if self.is_node_ready():
		var txt_val = str(value)
		if $ValueLabel:
			$ValueLabel.text = prefix + txt_val.lpad(digits, ' ')
		self.text = ' '.repeat(len(txt_val)).lpad(digits, '0')
