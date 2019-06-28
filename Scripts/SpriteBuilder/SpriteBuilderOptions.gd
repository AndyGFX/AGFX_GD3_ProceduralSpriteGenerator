extends Node

class_name SpriteBuilderOptions

var colored:bool=true
var edgeBrightness:float = 0.2
var colorVariations:float = 0.2
var brightnessNoise:float = 0.3
var saturation:float = 0.5
var renderMode:int = 1							# 1-original generator 2-modified (ignored colored option)
var colorOutline:Color = Color.black
var colorEmpty:Color = Color(1,1,1,0)
var colorSolid:Color = Color.green
var colorSkin1:Color = Color.red
var colorSkin2:Color = Color.blue


func Save(filename:String)->void:
	
	var json_opt = {
		"colored":self.colored,
		"edgeBrightness":self.edgeBrightness,
		"colorVariations":self.colorVariations,
		"brightnessNoise":self.brightnessNoise,
		"saturation":self.saturation,
		"renderMode":self.renderMode,
		"colorOutline":self.colorOutline.to_html(),
		"colorEmpty":self.colorEmpty.to_html(true),
		"colorSolid":self.colorSolid.to_html(true),
		"colorSkin1":self.colorSkin1.to_html(true),
		"colorSkin2":self.colorSkin2.to_html(true)
		}
	
	Utils.SaveJSON("res://Resources/ProceduralSprite/"+filename+".option",json_opt,true)
	pass


func Load(filename:String)->void:
	
	var json_opt = Utils.LoadJSON("res://Resources/ProceduralSprite/"+filename+".option")
	
	self.colored = json_opt.colored
	self.edgeBrightness = json_opt.edgeBrightness
	self.colorVariations = json_opt.colorVariations
	self.brightnessNoise = json_opt.brightnessNoise
	self.saturation = json_opt.saturation
	self.renderMode = int(json_opt.renderMode)
	self.colorOutline = Color(json_opt.colorOutline)
	self.colorEmpty = Color(json_opt.colorEmpty)
	self.colorSolid = Color(json_opt.colorSolid)
	self.colorSolid = Color(json_opt.colorSolid)
	self.colorSkin2 = Color(json_opt.colorSkin2)
	
	pass