extends Node
class_name BuffController

#{
#    "Name": "LifeLeech",
#    "Level": 1,
#    "Subject": "this.hitbox",
#    "Attribute": "life_leech_percent",
#    "Value": 5,
#    "When": null,
#    "Description": "Steal {x}% HP per hit."
#}
### And we append "BuffType"
## Need to consider attaching buffs to outgoing Dash / OnMove / OnPlayer skills

export var buffs = [] ## debuffs are subjective... calling everything a 'buff' for ease.
onready var this = get_parent()

func add_buff(buff_name, buff_skill_level, buff_type=null):
	print({"buff_name": buff_name, "level": buff_skill_level, "type": buff_type})
	if !(["buff", "debuff"].has(buff_type)):
		var buff_def = GameData.get_skill_data(buff_name, 0)
		for def in buff_def:
			if def["Attribute"] == "subtype":
				buff_type = def["Value"]
	var buff_data = GameData.get_skill_data(buff_name, buff_skill_level)[0]
	buff_data["BuffType"] = buff_type
	var subject
	if buff_data["Subject"].find(".") != -1:
		## Contains a '.'
		var subject_arr = buff_data["Subject"].split(".")
		if subject_arr[0] == "this":
			subject = this
			
		subject = subject.get(subject_arr[1])
		
	elif buff_data["Subject"] == "self":
		subject = self
	else:
		subject = get(buff_data["Subject"])
	if subject:
		if typeof(buff_data["Attribute"]) == TYPE_STRING && buff_data["Attribute"][buff_data["Attribute"].length() - 1] == ')':
			## Is a method call...
			var method_call = buff_data["Attribute"].split("(")[0]
			var params = buff_data["Value"]
			subject.callv(method_call, params)
		elif typeof(buff_data["Value"]) == TYPE_ARRAY:
			var new_arr = []
			for arr_item in buff_data["Value"]:
				if typeof(arr_item) == TYPE_STRING && arr_item.find("res://") != -1:
					new_arr.push_front(load(arr_item))
				else:
					new_arr.push_front(arr_item)
			buff_data["Value"] = new_arr
			subject.set(buff_data["Attribute"], buff_data["Value"])
		elif typeof(buff_data["Value"]) == TYPE_INT || typeof(buff_data["Value"]) == TYPE_REAL:
			var cur_value = subject.get(buff_data["Attribute"])
			print("buffing: ", buff_data["Attribute"], buff_data["Value"])
			var new_value = buff_data["Value"] + cur_value
			subject.set(buff_data["Attribute"], new_value)
		else:
			subject.set(buff_data["Attribute"], buff_data["Value"])
	buffs.push_back(buff_data)
#	print("buffs list: ", buffs)

func remove_buff(buff_name:String, buff_level:int):
	var buff_to_remove
	var buff_index
	for b in buffs.size():
		var buff = buffs[b]
		buff_index = b
		if buff["Name"] == buff_name && buff["Level"] == buff_level:
			buff_to_remove = buff
	if buff_to_remove:
		var subject
		if buff_to_remove["Subject"].find(".") != -1:
			## Contains a '.'
			var subject_arr = buff_to_remove["Subject"].split(".")
			if subject_arr[0] == "this":
				subject = this
				
			subject = subject.get(subject_arr[1])
			
		elif buff_to_remove["Subject"] == "self":
			subject = self
		else:
			subject = get(buff_to_remove["Subject"])
		
		if subject:
			if typeof(buff_to_remove["Attribute"]) == TYPE_STRING && buff_to_remove["Attribute"][buff_to_remove["Attribute"].length() - 1] == ')':
				return
			elif typeof(buff_to_remove["Value"]) == TYPE_ARRAY:
				subject.set(buff_to_remove["Attribute"], [])
			elif typeof(buff_to_remove["Value"]) == TYPE_INT || typeof(buff_to_remove["Value"]) == TYPE_REAL:
				var cur_value = subject.get(buff_to_remove["Attribute"])
				var new_value = cur_value - buff_to_remove["Value"]
				subject.set(buff_to_remove["Attribute"], new_value)
			else:
				subject.set(buff_to_remove["Attribute"], null)
		print("new val: ", subject.get(buff_to_remove["Attribute"]))
		buffs.remove(buff_index)
