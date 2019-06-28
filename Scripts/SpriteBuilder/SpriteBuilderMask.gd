extends Node


class_name SpriteBuilderMask

var width:int = 0
var height:int = 0
var data:Array
var mirrorX:bool = false
var mirrorY:bool = false

func SetMask(data:Array, width:int, height:int, mirrorX:bool, mirrorY:bool)->void:
	self.width = width
	self.height = height
	self.data = data
	self.mirrorX = mirrorX
	self.mirrorY = mirrorY	
	pass
	
func Save(filename:String)->void:
	
	var json_data = { 
		"width":self.width,
		"height":self.height,
		"mirrorX":self.mirrorX,
		"mirrorY":self.mirrorY,
		"data":self.data
		}
	Utils.SaveJSON("res://Resources/ProceduralSprite/"+filename+".mask",json_data,true)

func Load(filename:String)->void:
	
	var json_data = Utils.LoadJSON("res://Resources/ProceduralSprite/"+filename+".mask")
	
	self.width = int(json_data.width)
	self.height = int(json_data.height)
	self.mirrorX = int(json_data.mirrorX)
	self.mirrorY = int(json_data.mirrorY)
	self.data = json_data.data

func BuildFromImage(filename)->void:
	var txt:Texture = load("res://Resources/ProceduralSprite_ImageMask/"+filename+".png")
	var img:Image = txt.get_data()
	
	self.width = img.get_width()
	self.height = img.get_height()
	if self.width<self.height:
		self.mirrorX = true
	if self.width>self.height:
		self.mirrorY = true
		
	self.data.clear()
	for y in range(self.height):
		for x in range(self.width):
			self.data.append(0)
	
	img.lock()
	
	for y in range(self.height):
		for x in range(self.width):
			var pix:Color = img.get_pixel(x,y)
			
			match pix:
				Color(0,0,0,1):
					self.data[y*self.width+x]=0
				Color.green:
					self.data[y*self.width+x]=-1
				Color.red:
					self.data[y*self.width+x]=1
				Color.blue:
					self.data[y*self.width+x]=2
			
	img.unlock()
	pass