extends Node2D

@onready var item_list: ItemList = $ItemList
@onready var capacity_container: HBoxContainer = $Bg/CapacityContainer
@onready var profit_container: HBoxContainer = $Bg/ProfitContainer

@export var capacity:int = 10
func _ready() -> void:
	updateLabels(0,0.0)
	add_item_to_inventory("Graham", 900,100000, null, preload("res://Assets/Sprites/AIPrototype.jpg"))

func updateLabels(newcap, newprof) -> void:
	var weightValueLabel = capacity_container.get_child(1)
	weightValueLabel.text = "%d/%d kg" % [newcap, capacity]
	var profitValueLabel = profit_container.get_child(1)
	profitValueLabel.text = "%.3f $" % newprof
	
func add_item_to_inventory(aname, weight, profit, id, icon):
	var artifactd = ArtifactData.new()
	artifactd.setup(aname, weight, profit, id, icon)
	var stats = item_list.add_artifact_to_inventory(artifactd)
	updateLabels(stats["Weight"], stats["Profit"])
	
func _on_item_list_item_activated(index: int) -> void:
	await get_tree().create_timer(0.5).timeout
	item_list.remove_item(index)
	item_list.updateItemStats()
	var stats = item_list.getStats()
	updateLabels(stats["Weight"], stats["Profit"])
