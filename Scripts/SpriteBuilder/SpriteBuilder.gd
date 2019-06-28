extends Node

class_name SpriteBuilder

var width:int = 0
var height:int = 0
var data:Array
var mask:SpriteBuilderMask = SpriteBuilderMask.new()
var options:SpriteBuilderOptions = SpriteBuilderOptions.new()
var spriteImage:Image

func _init(mask:SpriteBuilderMask,options:SpriteBuilderOptions)->void:
	
	self.width = mask.width * (2 if mask.mirrorX==true else 1)
	self.height = mask.height * (2 if mask.mirrorY==true else 1)
	self.mask = mask
	self.options = options
	self.spriteImage = Image.new()
	self.spriteImage.create(self.width,self.height,false,Image.FORMAT_RGBA8)
	pass
	
# -----------------------------------------------------------
func Build():
	
	randomize()
	seed(randi())
	
	self.InitData()
	self.ClearImage()
	self.ApplyMask()	
	self.GenerateRandomSample()
	
	
	if self.mask.mirrorX:
		self.MirrorX()
		pass
	if self.mask.mirrorY:
		self.MirrorY()
		pass
	
	self.GenerateEdges()
	match (self.options.renderMode):
		1:
			self.RenderPixelData1()
		2:
			self.RenderPixelData2()
	

# -----------------------------------------------------------
func ClearImage()->void:

	for y in range(self.height):
		for x in range(self.width):
			SetPixel(x,y,Color.white);
	pass

# -----------------------------------------------------------
func InitData()->void:

	self.data.clear()
	for cell in range(self.width*self.height):
		self.data.append(-1)

# -----------------------------------------------------------
func ApplyMask()->void:
	
	for y in range(self.mask.height):
		for x in range(self.mask.width):
			self.SetData(x,y,self.mask.data[y*self.mask.width+x])

# -----------------------------------------------------------
func GetData(x:int, y:int)->int:
	return self.data[y * self.width + x]

# -----------------------------------------------------------
func SetData(x:int, y:int, value:int)->void:
	self.data[y * self.width + x] = value

# -----------------------------------------------------------
func GenerateRandomSample()-> void:
	
	var h = self.height
	var w = self.width
	var x = 0
	var y = 0
	var val = 0
	
	for y in range(h):
		for x in range(w):
			
			val = self.GetData(x,y)
			
			if (val == 1):
				#val =  val * randf()
				if randf()>0.5: val = 0
			elif val == 2:
				if rand_range(0.0,1.0)>0.5:
					val = 2
				else:
					val =-1
			
			self.SetData(x,y,val)

# -----------------------------------------------------------
func GenerateEdges() -> void:
	
	var h = self.height
	var w = self.width
	var x = 0
	var y = 0
	var edge_idx:int = -1; 
	
	
	match (self.options.renderMode):
		1:
			edge_idx = -1
		2:
			edge_idx = -2
			
	for y in range(h):
		for x in range(w):
			if (self.GetData(x, y) > 0):
				if (y - 1 >=0 and self.GetData(x, y - 1) == 0):
					self.SetData(x, y - 1, edge_idx)
				if (y + 1 < h and self.GetData(x, y + 1) == 0):
					self.SetData(x, y + 1, edge_idx)
				if (x - 1 >= 0 and self.GetData(x - 1, y) == 0):
					self.SetData(x - 1, y, edge_idx)
				if (x + 1 < w and self.GetData(x + 1, y) == 0):
					self.SetData(x + 1, y, edge_idx)
				pass
		pass

# -----------------------------------------------------------
func RenderPixelData1()->void:
	
	var isVerticalGradient = randf() > 0.5;
	var saturation = max(min(rand_range(0.0,1.0) * self.options.saturation, 1.0), 0.0)
	var hue = rand_range(0.0,1.0)
	var u = 0
	var v = 0
	var ulen = 0
	var vlen = 0

	var isNewColor = 0.0
	var val = 0.0
	var color = Color.black
	var brightness = 0.0
	
	var x = 0
	var y = 0
	
	if (isVerticalGradient):
		ulen = self.height
		vlen = self.width
	else:
		ulen = self.width
		vlen = self.height
		
	for u in range(ulen):
		
		isNewColor = abs(((rand_range(0.0,1.0) * 2.0 - 1.0) 
		+ (rand_range(0.0,1.0) * 2.0 - 1.0) 
		+ (rand_range(0.0,1.0) * 2.0 - 1.0)) / 3.0)
		
		if (isNewColor > (1.0 - self.options.colorVariations)):
			hue =rand_range(0.0,1.0)
			
			
		for v in range(vlen):
			if isVerticalGradient:
				val = self.GetData(v,u)
				x = v
				y = u
			else:
				val = self.GetData(u,v)
				x = u
				y = v
			
			color = Color(1,1,1,0)
			
			if val!=0:
				if self.options.colored:
					brightness = sin((u / ulen) *  3.14159265359) * (1.0 - self.options.brightnessNoise) + randf()*3.0 * self.options.brightnessNoise;
					color = SetHSL(color, hue, saturation, brightness)
					
					if val==-1:
						color.r *= self.options.edgeBrightness
						color.g *= self.options.edgeBrightness
						color.b *= self.options.edgeBrightness
					
					color.a = 1.0
				else:
					if val==-1:
						
						color.r = 0
						color.g = 0
						color.b = 0
						color.a = 1
					
				
			self.SetPixel(x,y,color)
			if self.mask.mirrorX: self.SetPixel(self.width-x-1,y,color)
			if self.mask.mirrorY: self.SetPixel(x,self.height-y-1,color);
	pass


func RenderPixelData2()->void:
	
	for y in range(self.height):
		for x in range(self.width):
			var cell = self.GetData(x,y)
			
			match cell:
				-2: # outline color
					self.SetPixel(x,y,self.options.colorOutline)
					pass
				-1: # solid color
					self.SetPixel(x,y,self.options.colorSolid)
					pass
				0: #empty
					self.SetPixel(x,y,self.options.colorEmpty)
					pass
				1: # skin color 1
					self.SetPixel(x,y,self.options.colorSkin1)
					pass
				2: # skin color 2
					self.SetPixel(x,y,self.options.colorSkin2)
					pass
				
			
			pass
# -----------------------------------------------------------
func SetPixel(x:int,y:int,color:Color)->void:
	self.spriteImage.lock()
	self.spriteImage.set_pixel(x,y,color)
	self.spriteImage.unlock()

# -----------------------------------------------------------
func MirrorX()->void:
	var h = self.height
	var w = floor(self.width/2)
	
	for y in range(h):
		for x in range(w):
			self.SetData(self.width-x-1,y,self.GetData(x,y))
	pass

# -----------------------------------------------------------
func MirrorY()->void:
	var h = floor(self.height/2)
	var w = self.width
	
	for y in range(h):
		for x in range(w):
			self.SetData(x,self.height-y-1,self.GetData(x,y))
	pass
	
# -----------------------------------------------------------
func SetHSL(inputColor:Color,h:float, s:float, l:float)->Color:
	var i:int = 0
	var f:float = 0.0
	var p:float = 0.0
	var q:float = 0.0
	var t:float = 0.0
	
	i = floor(h*6)
	f = h * 6 - i
	p = l * (1 - s)
	q = l * (1 - f * s)
	t = l * (1 - (1 - f) * s)
	
	match (i % 6):
		0:
			inputColor.r = l;
			inputColor.g = t;
			inputColor.b = p;
			pass
		1:
			inputColor.r = q; 
			inputColor.g = l; 
			inputColor.b = p;
			pass
		2:
			inputColor.r = p; 
			inputColor.g = l; 
			inputColor.b = t;
			pass
		3:
			inputColor.r = p; 
			inputColor.g = q; 
			inputColor.b = l;
			pass
		4:
			inputColor.r = t; 
			inputColor.g = p; 
			inputColor.b = l;
			pass
		5:
			inputColor.r = l; 
			inputColor.g = p; 
			inputColor.b = q; 
			pass
		
	return inputColor
	pass

func Save(name:String):
	
	self.mask.Save(name)
	self.options.Save(name)
	
func Load(name:String):
	
	self.mask.Load(name)
	self.options.Load(name)
	