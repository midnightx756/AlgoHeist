class_name ArtifactData
extends Node2D

@export var artifactName: String = "";
@export var artifactWeight: int = 0;
@export var artifactProfit: float = 0.0;
@export var artifactHolder: BasicShelf
@export var Icon: Texture2D;

func setup(Name, Weight, Profit, Holder, AIcon) -> void:
	self.artifactName = Name
	self.artifactWeight = Weight
	self.artifactProfit = Profit
	self.artifactHolder = Holder
	self.Icon = AIcon
	
