extends Node2D

@onready var item_list: ItemList = $ItemList
@onready var capacity_container: HBoxContainer = $Bg/CapacityContainer
@onready var profit_container: HBoxContainer = $Bg/ProfitContainer

@export var capacity:int = 10
func _ready() -> void:
	updateLabels(0,0.0)
	var screen_size = get_viewport_rect().size
	position = screen_size / 2
	
	#add_item_to_inventory("Graham", 9,100000, null, preload("res://Assets/Sprites/AIPrototype.jpg"))
	#add_item_to_inventory("Dragoon", 900,100000, null, preload("res://Assets/Sprites/Leonardo-da-Vincis-codex-Leicester.jpg"))

func updateLabels(newcap, newprof) -> void:
	var weightValueLabel = capacity_container.get_child(1)
	weightValueLabel.text = "%d/%d kg" % [newcap, capacity]
	var profitValueLabel = profit_container.get_child(1)
	profitValueLabel.text = "%.3f $" % newprof

func add_item_to_inventory(aname, weight, profit, shelf, icon):
	if(item_list.getStats()["Weight"] + weight > capacity):
		print("Item Cannot be added, inventory is full, ",(item_list.getStats()["Weight"] + weight))
		return false
	var artifactd = ArtifactData.new()
	artifactd.setup(aname, weight, profit, shelf, icon)
	var stats = item_list.add_artifact_to_inventory(artifactd)
	updateLabels(stats["Weight"], stats["Profit"])
	return true
	
func _on_item_list_item_activated(index: int) -> void:
	var artifact = item_list.get_item_metadata(index)
	
	# Send the shelf reference back to the manager
	GameManager.return_item_to_shelf(artifact.artifactHolder)
	
	# UI housekeeping
	item_list.remove_item(index)
	item_list.updateItemStats()
	var stats = item_list.getStats()
	updateLabels(stats["Weight"], stats["Profit"])

func return_inventory_stats_clear():
	var meta = null
	var stats_arr = []
	if item_list == null:
		print("Bruh")
		return null
	for i in range(item_list.get_item_count()):
		meta = item_list.get_item_metadata(i)
		if meta == null: continue
		stats_arr.append({"Name": meta.artifactName,
										"Weight": meta.artifactWeight, 
										"Profit" : meta.artifactProfit,
										"Shelf" : meta.artifactHolder,
										"Item" : meta.Icon
										})
	item_list.clear()
	print("Done")
	updateLabels(0,0.0)
	item_list.reset()
	return stats_arr
	
