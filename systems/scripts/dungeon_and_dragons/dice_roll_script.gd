extends Node 
class_name dice_roll

## size = amount of sides on the die.
func roll_dice(size:int) -> int:
	return randi_range(1,size)

## Rolls multiple die and returns the highest if adv = true, lowest if false.
func roll_advantage(die:int=20,adv:bool=true,rolls:int=1) -> int:
	var rolled_numbers:Array[int]
	rolled_numbers.append(roll_dice(die))
	for roll in rolls:
		rolled_numbers.append(roll_dice(die))
	rolled_numbers.sort()
	return rolled_numbers.back() if adv else rolled_numbers.front()
