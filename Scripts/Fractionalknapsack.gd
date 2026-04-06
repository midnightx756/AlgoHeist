# Handles gold loot using greedy fractional knapsack
# Used when player loots "Gold Dust" items

class_name FractionalKnapsack

func solve(gold_items: Array, bag_capacity: float) -> Dictionary:
    
    # Remove already looted items (important for game state)
    var available_items = []
    for item in gold_items:
        if item.is_looted == false:
            available_items.append(item)

    # Sort based on value/weight ratio (highest first)
    available_items.sort_custom(func(a, b):
        var r1 = a.value / a.weight
        var r2 = b.value / b.weight
        return r1 > r2
    )

    var total_loot_value = 0.0
    var remaining_capacity = bag_capacity
    var loot_taken = []

    # Go through each gold item
    for item in available_items:

        if remaining_capacity <= 0:
            break  # bag is full

        # If full item can fit
        if item.weight <= remaining_capacity:
            total_loot_value += item.value
            remaining_capacity -= item.weight

            loot_taken.append({
                "item": item,
                "fraction": 1.0
            })

        else:
            # Only part of item can be taken
            var part = remaining_capacity / item.weight

            total_loot_value += item.value * part

            loot_taken.append({
                "item": item,
                "fraction": part
            })

            remaining_capacity = 0  # bag filled

    return {
        "total_value": total_loot_value,
        "items": loot_taken
    }
