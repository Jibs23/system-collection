@icon("res://systems/components/inventory/item/icon_inventory_item.png")
class_name InventoryItem extends Resource

@export var icon: Texture2D = preload("res://systems/components/inventory/item/inventory_item_sprite_placeholder.png")

@export_placeholder("Item Name") var item_name: String = "placeholder item"

@export_multiline var description: String = "Placeholder description"

## The maximum amount of this item that can fit in a single slot. 1 = no stack.
@export_range(1,64,1) var max_stack:int = 1

## The amount of uses this item has before it is consumed. 0 = unlimited.
@export_range(0,64,1) var max_number_of_uses:int
