@icon("res://systems/components/inventory/manager/icon_inventory_manager.png")
extends Node

#####################
### WORK IN PROGRESS ###
#####################


signal new_current_item(item:InventoryItem)
signal inventory_full
#signal new_inventory_item(item:InventoryItem)

## The inventory contains the items.
@export var inventory: Array[InventoryItem] = []

## The amount of inventory slots.
@export_range(1,128,1) var inventory_max_size: int

@onready var current_item: InventoryItem = inventory.front():
	set(value):
		new_current_item.emit(value)
		print(value," is new item")
		return value
		
var current_item_index: int:
	get:
		return inventory.find(current_item)

## Cycles through the items in the inventory. 
func selected_item_cycle(forward:bool) -> void:
	var value = 1 if forward else -1
	var new_index:int = current_item_index + value
	if new_index <= 0 or new_index > inventory.size():
		if new_index > inventory.size(): 
			selected_item_set(inventory.back())
		else: 
			selected_item_set(inventory.front())
		return
	selected_item_set(current_item_index + value)

## Sets the current item. Can make use of index:int or InventoryItem.
func selected_item_set(item:Variant) -> void:
	match typeof(item):
		TYPE_INT:
			if item != clampi(item ,1 ,inventory.size()):
				push_error("ERROR: ",inventory," doe not have index ", item)
				return
			current_item = inventory.get(item)
		InventoryItem:
			if !inventory.has(item): 
				push_error("ERROR: ",inventory," doe not have ", item)
				return
			current_item = inventory[item]

## Add an item to the inventory array.
func item_add(item:InventoryItem):
	inventory.append(item)
	if is_inventory_full(): inventory_full.emit()

## Remove an item from the inventory, inventory array.
func item_remove(item:Variant):
	match typeof(item):
		TYPE_INT:
			inventory.pop_at(item)
		InventoryItem:
			inventory.pop_at(inventory.get(item))

## Returns true if inventory is full.
func is_inventory_full() -> bool:
	var output:bool = inventory.size() >= inventory_max_size
	return output
