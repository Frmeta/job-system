extends Control

@onready var option_button = $VBoxContainer/OptionButton
@onready var jobname_label = $VBoxContainer/JobnameLabel
@onready var description_label = $VBoxContainer/DescriptionLabel
@onready var skill_box = $VBoxContainer/VBoxContainer

var jobs = []


func _ready():
	
	# read csv as string
	var data = load_csv()
	
	# split by lines
	var rows = data.split("\n")
	
	# iterate without header
	for i in range(1, rows.size()): 
		
		# ignore empty rows
		if rows[i].strip_edges() == "":
			continue
			
		# split by columns
		var columns = rows[i].replace('"', '').split(";")
		
		# create job object
		var job = Job.new()
		job.jobname = columns[1]
		job.description = columns[2]
		job.skills = Array(columns).slice(3, columns.size()-1).map(func (x): return x.strip_edges() )
		
		# append to jobs
		jobs.append(job)
	
	# add item to option button
	for job in jobs:
		option_button.add_item(job.jobname)
	option_button.selected = -1
	
	# connect signal when selected
	option_button.item_selected.connect(option_button_updated)
	
func load_csv():
	# read csv as string
	var file = FileAccess.open("res://resources/class.csv", FileAccess.READ)
	var content = file.get_as_text()
	return content
	
func option_button_updated(idx:int):
	
	# update jobname
	jobname_label.text = jobs[idx].jobname
	
	# update description
	description_label.text = jobs[idx].description
	
	# update skill
	var skill_labels = skill_box.get_children()
	
	for i in range(jobs[idx].skills.size()):
		skill_labels[i].visible = true
		skill_labels[i].text = "- " + jobs[idx].skills[i]
		
	for i in range(jobs[idx].skills.size(), skill_labels.size()):
		skill_labels[i].visible = false
		
