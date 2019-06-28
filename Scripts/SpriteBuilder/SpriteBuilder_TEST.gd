extends Node2D

var spriteBuilder:SpriteBuilder
var preview:Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var spr_options = SpriteBuilderOptions.new()
	var spr_mask = SpriteBuilderMask.new()
	
#	-1 = solid cell			
#	 0 = empty
#	 1 = solid/rnd skin #1
#	 2 = solid/rnd skin #2
	
	# Space ship
	spr_mask.width = 6
	spr_mask.height = 12
	spr_mask.mirrorX = true
	spr_mask.mirrorY = false
	spr_mask.data = [
	0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 1, 1,
	0, 0, 0, 0, 1,-1,
	0, 0, 0, 1, 1,-1,
	0, 0, 0, 1, 1,-1,
	0, 0, 1, 1, 1,-1,
	0, 1, 1, 1, 2, 2,
	0, 1, 1, 1, 2, 2,
	0, 1, 1, 1, 2, 2,
	0, 1, 1, 1, 1,-1,
	0, 0, 0, 1, 1, 1,
	0, 0, 0, 0, 0, 0
	]
#	spr_mask.data = [
#	0, 0, 0, 0, 0, 0,
#	0, 0, 0, -1, 1, 2,
#	0, 0, 0, -1, 1, 2,
#	0, 0, 0, -1, 1, 0,
#	0, 0, 0, -1, 1, 0,
#	0, 0, 0, -1, 1, 2,
#	0, 0, 0, -1, 1, 2,
#	0, 0, 0, 0, 0, 1,
#	0, 0, 0, 0, 0, 1,
#	0, 0, 0, 0, 0, 1,
#	0, 0, 0, 0, 0, 1,
#	0, 0, 0, 0, 0, 0,
#	]
	
	#spr_options.Load("Sptrite_1")
	#spr_mask.Load("Sptrite_1")
	#spr_mask.BuildFromImage("PS_Mask_Box")	
	#spr_mask.Save("Sptrite_2")
	
	self.spriteBuilder = SpriteBuilder.new(spr_mask,spr_options)
	self.spriteBuilder.Save("ShipSprite")
	
	

func _on_Button_pressed():
	
	var itex = ImageTexture.new()    
	self.spriteBuilder.Build()	
	itex.create_from_image(self.spriteBuilder.spriteImage,0)	
	$Sprite1.set_texture(itex)	
	
	itex = ImageTexture.new()    
	self.spriteBuilder.Build()	
	itex.create_from_image(self.spriteBuilder.spriteImage,0)	
	$Sprite2.set_texture(itex)	
	
	itex = ImageTexture.new()    
	self.spriteBuilder.Build()	
	itex.create_from_image(self.spriteBuilder.spriteImage,0)	
	$Sprite3.set_texture(itex)	
	
	itex = ImageTexture.new()    
	self.spriteBuilder.Build()	
	itex.create_from_image(self.spriteBuilder.spriteImage,0)	
	$Sprite4.set_texture(itex)	
	
	itex = ImageTexture.new()    
	self.spriteBuilder.Build()	
	itex.create_from_image(self.spriteBuilder.spriteImage,0)	
	$Sprite5.set_texture(itex)	
	
	itex = ImageTexture.new()    
	self.spriteBuilder.Build()	
	itex.create_from_image(self.spriteBuilder.spriteImage,0)	
	$Sprite6.set_texture(itex)	
	
	pass # Replace with function body.
