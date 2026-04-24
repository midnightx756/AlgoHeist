extends BasicShelf 

func loot():
	# Delegate to the Parent node
	get_parent().loot()

func returnItem():
	# Delegate to the Parent node
	get_parent().returnItem()

func get_ShelfName():
	return get_parent().Aname
	
func get_ShelfWeight():
	return get_parent().weight
	
func get_ShelfProfit():
	return get_parent().profit
	
func get_ShelfItem():
	return get_parent().lootItem
	
func is_lootable():
	return get_parent().is_lootable()
#func get_stats():
	# Delegate to the Parent node
	#return get_parent().get_stats()
