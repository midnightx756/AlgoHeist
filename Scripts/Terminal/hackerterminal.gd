extends Control

# This script finds your nodes by their names, no matter where they are hidden.
var search_btn
var big_text_box
var pattern_box
var result_label

func _ready():
	# Look for the nodes by their EXACT names from your photo
	search_btn = find_child("Search", true, false)
	big_text_box = find_child("Text", true, false)
	pattern_box = find_child("Pattern", true, false)
	result_label = find_child("Result", true, false)

	# Safety Check: If something is missing, this will tell us in the Output
	if search_btn == null: print("ERROR: Cannot find 'Search'")
	if big_text_box == null: print("ERROR: Cannot find 'Text'")
	if pattern_box == null: print("ERROR: Cannot find 'Pattern'")
	if result_label == null: print("ERROR: Cannot find 'Result'")

	# If the button exists, make it work
	if search_btn:
		search_btn.pressed.connect(_on_search_pressed)
		print("TERMINAL INITIALIZED: All systems go.")

func _on_search_pressed():
	# 1. Get the text you typed into the boxes
	var main_log = big_text_box.text
	var target = pattern_box.text
	
	# 2. Run the KMP Algorithm
	var found_at = kmp_search(main_log, target)
	
	# 3. Update the Result label
	if found_at != -1:
		result_label.text = "KEY FOUND AT INDEX: " + str(found_at)
	else:
		result_label.text = "SEARCH FAILED: KEY NOT FOUND"

# --- THE KMP ALGORITHM ---
func kmp_search(text: String, pattern: String) -> int:
	if pattern.length() == 0: return 0
	var lps = compute_lps(pattern)
	var i = 0 # text index
	var j = 0 # pattern index
	while i < text.length():
		if pattern[j] == text[i]:
			i += 1
			j += 1
		if j == pattern.length():
			return i - j
		elif i < text.length() and pattern[j] != text[i]:
			if j != 0:
				j = lps[j-1]
			else:
				i += 1
	return -1

func compute_lps(pattern: String) -> Array:
	var lps = []
	lps.resize(pattern.length())
	lps.fill(0)
	var length = 0
	var i = 1
	while i < pattern.length():
		if pattern[i] == pattern[length]:
			length += 1
			lps[i] = length
			i += 1
		else:
			if length != 0:
				length = lps[length-1]
			else:
				lps[i] = 0
				i += 1
	return lps
