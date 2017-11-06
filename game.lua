local composer = require( "composer" )
 
local scene = composer.newScene()


display.setStatusBar(display.HiddenStatusBar)
local composer = require( "composer" )
local physics = require( "physics" )
local widget = require( "widget" )
physics.start()
physics.setGravity( 0, 100 )
--physics.setDrawMode("hybrid")


local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- set up forward references
local background
local castle
local hitCastle
local spawnEnemy
local numberEnemies = 15
local score = 0
local physicsData = (require "shapedefs").physicsData(1.0)
local branches_01
local branches_02
local tower_btn
local play
local maxHealth 
local currentHealth
local money = 80
local currentWave = 1
local waveText
local scoreText
local castleLife = 20
local castleLifeText
local enemySpawn
local moneyText
local waveStatus = display.newText("Wave Done!", centerX, 80, native.systemFontBold, 60)
local enemy
local enemy02


--Enemies Sprite Sheets
local enemy01SheetData = {
	width = 40,
	height = 39,
	numFrames = 6,
	sheetContentWidth = 240,
	sheetContentHeight = 40
}
local enemy01Sheet = graphics.newImageSheet("enemy01.png", enemy01SheetData)
local enemy01SequenceData = {
	name = "walking",
	start = 1,
	count = 6,
	time = 500
}

local enemy02SheetData = {
	width = 50,
	height = 50,
	numFrames = 5,
	sheetContentWidth = 256,
	sheetContentHeight = 55
}
local enemy02Sheet = graphics.newImageSheet("enemy02.png",enemy02SheetData)
local enemy02SequenceData = {
	name = "walking",
	start = 1,
	count = 5,
	time = 500
}

local enemy03SheetData = {
	width = 74,
	height = 66,
	numFrames = 4,
	sheetContentWidth = 298,
	sheetContentHeight = 66
}
local enemy03Sheet = graphics.newImageSheet("enemy03.png", enemy03SheetData)
local enemy03SequenceData = {
	name = "walking",
	start = 1,
	count = 5,
	time = 800
}


--Wave controller
local enemiesKilled = 0
local totalEnemiesSpawmed = 0
local totalEnemiesWave = 35

--Countdown 
local countDownTimer
local secondsLeft = 3
local clockText = display.newText("3", display.contentCenterX, 80, native.systemFontBold, 60)
clockText:setFillColor( 0.7, 0.7, 1 )

function spawnEnemy()
	
	for i=1,numberEnemies do
		enemy = display.newSprite(enemy01Sheet, enemy01SequenceData)
		physics.addBody(enemy,"dynamic",physicsData:get("enemy"))
		enemy:addEventListener("tap",enemyKill)
		enemy.gravityScale = -0
		enemy.isFixedRotation = true
		enemy.type = "enemy"
		local speed = 0.1
		enemy.collision = enemyTreeCollision
		enemy:addEventListener("collision",enemy)
		enemy:play()
		
		if math.random(2) == 1 then
			enemy.x = math.random(-100, -10)
			
		else
			enemy.x = math.random (display.contentWidth + 10, display.contentWidth + 100)
			enemy.xScale = -1
		end
			enemy.y = math.random(display.contentHeight)
			enemy:setLinearVelocity((castle.x - enemy.x) * speed,(castle.y - enemy.y) * speed)
			totalEnemiesSpawmed = totalEnemiesSpawmed + 1
	end
	if currentWave >= 5 then
		enemy02 = display.newSprite(enemy02Sheet, enemy02SequenceData)
		--physics.addBody(enemy02,"dynamic",physicsData:get("enemy"))
		enemy02:addEventListener("tap",enemyKill)
		--enemy02.gravityScale = -0
		--enemy02.isFixedRotation = true
		--enemy02.type = "enemy"
		--enemy02.collision = enemyTreeCollision
		--enemy02:addEventListener("collision",enemy02)
		--local speed = 0.1
		enemy02:play()

		if math.random(2) == 1 then
			enemy02.x = math.random(-100, -10)
			
		else
			enemy02.x = math.random (display.contentWidth + 10, display.contentWidth + 100)
			enemy02.xScale = -1
		end
			enemy02.tran = transition.to(enemy02, {x=castle.x, y=castle.y, time=5000, onComplete=hitCastle})
			enemy02.y = math.random(display.contentHeight)
			--enemy02:setLinearVelocity((castle.x - enemy02.x) * speed,(castle.y - enemy02.y) * speed)

	end
	if currentWave == 10 then
		--BOSS WILL BE HERE
		enemy03 = display.newSprite(enemy03Sheet, enemy03SequenceData)
		physics.addBody(enemy03,"dynamic",physicsData:get("enemy"))
		enemy03:addEventListener("tap",enemyKill)
		enemy03.gravityScale = -0
		enemy03.isFixedRotation = true
		enemy03.type = "enemy"
		enemy03.collision = enemyTreeCollision
		enemy03:addEventListener("collision",enemy03)
		local speed = 0.05
		enemy03:play()

		if math.random(2) == 1 then
			enemy03.x = math.random(-100, -10)
			
		else
			enemy03.x = math.random (display.contentWidth + 10, display.contentWidth + 100)
			enemy03.xScale = -1
		end
			enemy03.y = math.random(display.contentHeight)
			enemy03:setLinearVelocity((castle.x - enemy03.x) * speed,(castle.y - enemy03.y) * speed)
	end
	enemySpawn = timer.performWithDelay( 10000, spawnEnemy)
	numberEnemies = numberEnemies + 1
	branches_02:toFront()
	branches_01:toFront()
	enemy.enterFrame = onEnterFrame
	--Runtime:addEventListener( "enterFrame", enemy )
	scoreText:toFront()
	waveText:toFront()
	moneyText:toFront()
	if(totalEnemiesSpawmed >= totalEnemiesWave) then
		timer.cancel(enemySpawn)
	end
	
end
	

	

local function createPlaySreen()
	background = display.newImage("level01_2.png")
	background.x =  centerX 
	background.y =  centerY
	scoreText = display.newText("Score: ",-30, 0, native.systemFontBold, 20)
	scoreText.text = "Score: " .. score

	castleLifeText = display.newText("Health: ",190, 0, native.systemFontBold, 20)
	castleLifeText.text = "Health: " .. castleLife

	moneyText = display.newText("Money: ",420, 0, native.systemFontBold, 20)
	moneyText.text = "Money: " .. money

	local trunk_01 = display.newImage("trunk.png")
	trunk_01.x = 400
	trunk_01.y = 270
	trunk_01.type = "tree"
	physics.addBody(trunk_01, "static", physicsData:get("trunk"))
	branches_01 = display.newImage("branches.png")
	branches_01.x = 400
	branches_01.y = 235
	branches_01:toFront()

	local trunk_02 = display.newImage("trunk.png")
	trunk_02.y = 97
	trunk_02.type = "tree"
	physics.addBody(trunk_02, "static", physicsData:get("trunk"))
	branches_02 = display.newImage("branches.png")
	branches_02:toFront()

	castle = display.newImage("castleMenor.png")
	physics.addBody(castle, "static")
	castle.type = "castle"
	castle.x = 230
	castle.y = 120
	waveText = display.newText("Wave: ", -30, 290, native.systemFontBold, 20)
	waveText.text ="Wave: " .. currentWave 

end

local function spawnWall(event)
	--Create walls
	if money >= 20 then
		if ( "began" == event.phase ) then
		characterGroup = display.newGroup()
		characterGroup.x = centerX
		characterGroup.y = centerY
		wall = display.newImage("wall.png")
		wall.x = 0
		wall.y = 0
		characterGroup:insert(wall)
		healthBar = display.newRect(-15,-20, 30, 3)
		healthBar:setFillColor( 0, 255, 0 )
		healthBar.strokeWidth = 1
		--healthBar:setStrokeColor( 255, 255, 255, .5 )
		characterGroup:insert(healthBar)
		physics.addBody(characterGroup, "static")
		characterGroup.maxHealth = 30
		characterGroup.currentHealth = 30
		characterGroup.type = "wall"
		characterGroup.collision = wallCollision
		characterGroup:addEventListener("collision", characterGroup)
		money = money - 20
		moneyText.text = "Money: " .. money 

		end
	else
		print("INSUFICIENT MONEY")
	end
	branches_02:toFront()
	branches_01:toFront()
	characterGroup:addEventListener( "touch", moveWall )
	return true
end

local function onEnterFrame( self, event )
	print("Saiu do Frame")
   if( x < 0 or x > 320 or y < 0 or y < 480) then
      Runtime:removeEventListener( "enterFrame", self )
      display.remove( self )
   end
end


function enemyKill(event)
	local numSpawn = 0
	local enemy = event.target
	display.remove(enemy)
	transition.cancel ( event.target.trans )
	score = score + 1
	enemiesKilled = enemiesKilled + 1
	scoreText.text = "Score: " .. score
	money = money + 2
	moneyText.text = "Money: " .. money
	clockText.text = nil
	waveStatus.text = ""
	if totalEnemiesSpawmed >= totalEnemiesWave then
		if enemiesKilled >= totalEnemiesSpawmed then
			waveStatus = display.newText("Wave Done!", centerX, 80, native.systemFontBold, 60)
			waveStatus.x = centerX
			waveStatus:setFillColor( 0.7, 0.7, 1 )
			transition.fadeOut(waveStatus,{time = 1000})
			currentWave = currentWave + 1
			showButtons()
			secondsLeft = 4
			enemiesKilled = 0
			totalEnemiesSpawmed = 0
			totalEnemiesWave = totalEnemiesWave + 5
			clockText.text = ""
		end
	end
	if currentWave == 5 then
		enemy02.tran = transition.to(enemy02, {x=castle.x, y=castle.y, time=4000, onComplete=hitCastle})
	end
		Runtime:addEventListener( "enterFrame", enemy )
	return true
end


function wallCollision(self, event)

		damageBar = display.newRect(0,-20,0, 3)
		damageBar:setFillColor( 255, 0, 0 )
		self:insert(damageBar)
	if event.phase == "began" then
		if event.target.type == "wall" and event.other.type == "enemy" then
			if(self.currentHealth > 0) then 
				self.currentHealth = self.currentHealth - 0.3
				if(self.currentHealth <= 0) then
					display.remove(self)
				end
			end
			damageBar.x = self.currentHealth/2 
			damageBar.width = self.maxHealth  - self.currentHealth
			damageBar:toFront()
		end
	end
end

function enemyTreeCollision(self, event)
	if event.phase == "began" then
		local enemyX, enemyY = self:localToContent( 0, 0 )
		if event.target.type == "enemy" and event.other.type == "enemy" then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		elseif(event.target.type == "enemy" and event.other.type == "tree" or event.other.type == "tree" and event.target.type == "enemy" ) then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		elseif(event.target.type == "enemy" and event.other.type == "castle") then
			hitCastle(self)
		elseif(event.target.type == "enemy" and event.other.type == "wall") then
			timer.performWithDelay( 2000)
			self:applyForce((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)		
		end
	elseif event.phase == "moved" then
		if event.target.type == "enemy" and event.other.type == "enemy" then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		elseif(event.target.type == "enemy" and event.other.type == "tree" or event.other.type == "tree" and event.target.type == "enemy" ) then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		elseif(event.target.type == "enemy" and event.other.type == "wall") then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		elseif vent.target.type == "enemy" then
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		end
	elseif event.phase == "ended" then
		local enemyX, enemyY = self:localToContent( 0, 0 )
		if event.target.type == "enemy" and event.other.type == "enemy" then
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		elseif(event.target.type == "enemy" and event.other.type == "tree" or event.other.type == "tree" and event.target.type == "enemy" ) then
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		elseif(event.target.type == "enemy" and event.other.type == "wall") then
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
		end
	end
end

function moveWall( event )

	local touchedWall = event.target

	if event.phase == "began" then
		touchedWall.previousX = touchedWall.x
		touchedWall.previousY = touchedWall.y
	elseif event.phase == "moved" then
		touchedWall.x = (event.x - event.xStart) + touchedWall.previousX
		touchedWall.y = (event.y - event.yStart) + touchedWall.previousY
	end
end


function gameOver()
	physics.pause()
	castleLife = 0
	timer.cancel(enemySpawn)
	local shade = display.newRect( -50, 0, 600, 320 )
	shade:setFillColor( 0, 0, 0)
	shade.alpha = 0.1
	transition.fadeIn(shade,{time=2000})
	--composer.gotoScene("game_over",{time = 800, effect = "crossFade"})
	--composer.gotoScene("game_over")
	local gameOverText = display.newText("Game Over", 70, 80, native.systemFontBold, 60)
	Runtime:removeEventListener( "tap",enemyKill )
end


function updateTime()
	secondsLeft = secondsLeft - 1
	transition.fadeIn(clockText, {time = 1})
	 
	local timeDisplay = secondsLeft
	clockText.text = timeDisplay
	if secondsLeft == 0 then
		clockText.text = "START"
		timer.cancel(countDownTimer)
		transition.fadeOut(clockText,{time = 1000})
		spawnEnemy()
	end
end

function showButtons()
	tower_btn.isVisible = true
	playButton.isVisible = true
	clockText.text = 3
	clockText:setFillColor( 0.7, 0.7, 1 )
	waveText.text ="Wave: " .. currentWave
end

--TODO: Game sctrucure goes here
function startGame()
	countDownTimer = timer.performWithDelay( 1000, updateTime, 0)
	clockText:toFront()
	tower_btn.isVisible = false
	playButton.isVisible = false
	--characterGroup:removeEventListener( "touch", moveWall )
end


function towerBuilder()
	createPlaySreen()
	tower_btn = widget.newButton( {
 	id = "wall_button",
    defaultFile = "wall_button.png",
     left = 450,
     top = 250,
     onPress = spawnWall
	} )

	playButton = widget.newButton( {
 	id = "playButton",
    defaultFile = "play.png",
     left = 450,
     top = 100,
     onPress = startGame
	} )
end

function hitCastle(obj)
	display.remove(obj)
	castleLife = castleLife - 1
	castleLifeText.text = "Health: " .. castleLife
	enemiesKilled = enemiesKilled + 1

	if castleLife == 0 then
		castleLife = 0
		gameOver()
	end
	if totalEnemiesSpawmed >= totalEnemiesWave then
		if enemiesKilled >= totalEnemiesSpawmed then
			waveStatus = display.newText("Wave Done!", centerX, 80, native.systemFontBold, 60)
			waveStatus.x = centerX
			waveStatus:setFillColor( 0.7, 0.7, 1 )
			transition.fadeOut(waveStatus,{time = 1000})
			currentWave = currentWave + 1
			showButtons()
			secondsLeft = 4
			enemiesKilled = 0
			totalEnemiesSpawmed = 0
			totalEnemiesWave = totalEnemiesWave + 5
			clockText.text = ""
		end
	end
end


function scene:create( event )
	local sceneGroup = self.view

	towerBuilder()

end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
  -- Code here runs immediately after the scene goes entirely off screen
  composer.removeScene( "game" )

  end
end

-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene



		
		
