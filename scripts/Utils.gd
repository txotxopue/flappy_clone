# Utils.gd

extends Node2D

func _ready():
    pass

func get_main_node():
    var root_node = get_tree().get_root()
    return root_node.get_child(root_node.get_child_count()-1)

# Gets an array of the digits of the given number.
func get_digits(number):
    var str_number = str(number)
    var digits     = []

    for i in range(str_number.length()):
        digits.append(str_number[i].to_int())

    return digits
    pass