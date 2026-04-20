extends BasicShelf 

func loot():
	# Delegate to the Parent node
	get_parent().loot()

func returnItem():
	# Delegate to the Parent node
	get_parent().returnItem()

#func get_stats():
	# Delegate to the Parent node
	#return get_parent().get_stats()
