local composer = require("composer")
local physics = require( "physics" )
physics.start()

local scene = composer.newScene()

local background
local gameTitle
local nameBg
local playerName
local quitRect
local scoreRect
local playButton
local playButton02
local scoreButton
local quitButton


local function gotoGame()
	playerName = numericField.text
	nameBg:removeSelf()
	playButton02:removeSelf()
	numericField:removeSelf()
	composer.setVariable("playerName", playerName)
	composer.removeScene("menu")
	composer.removeScene("game")
	composer.gotoScene("game",{time=800, effect="crossFade"})
end

local function highScore()
	composer.removeScene("highscores")
	composer.removeScene("menu")
	composer.gotoScene("highscores",{time=800, effect="crossFade"})
end


local function exitGame()
	timer.performWithDelay( 1000,
    function()
      if( system.getInfo("platformName")=="Android" ) then
        native.requestExit()
      else
        os.exit()
      end
end )
end

local function playerName()
	nameBg = display.newImage("user_name.png")
	quitRect:removeEventListener("tap",exitGame)
	scoreRect:removeEventListener("tap",highScore)
	
	nameBg.x = display.contentCenterX
	nameBg.y = display.contentCenterY

	numericField = native.newTextField( 150, 150, 180, 30 )
	gameTitle.alpha = 0.3
	playButton.alpha = 0.3
	scoreButton.alpha = 0.3
	quitButton.alpha = 0.3
	transition.to(background,{alpha = 0.3, time = 500})
	numericField.inputType = "default"

	playButton02 = display.newImage("play.png")
	playButton02.x = 240
	playButton02.y = 210
	playButton02:addEventListener("tap", gotoGame)
end


function scene:create( event )
	local sceneGroup = self.view
  	backGroup = display.newGroup() --Display group for background image
  	sceneGroup:insert(backGroup)   --Insert into the scene's view group
  
	mainGroup = display.newGroup() --Display group for ship, laser, asteroids, etc.
	sceneGroup:insert(mainGroup)   --Insert into the scene's view group

	uiGroup = display.newGroup()   --Display group for UI objects like lives and score
	sceneGroup:insert(uiGroup)

	background = display.newImageRect( sceneGroup, "back02.png",580,350)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	gameTitle = display.newImageRect(sceneGroup,"gameTitle.png",400,90)
	gameTitle.x = display.contentCenterX
	gameTitle.y = 90
	local playRect = display.newRect(sceneGroup,195,150,90,30)
	playButton = display.newImageRect(sceneGroup,"startButton01.png",150,100)
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY
	playRect:toBack()
	playRect.alpha = 0.1
	playRect:addEventListener("tap", playerName)

	scoreRect = display.newRect(sceneGroup,195,200,90,30)
	scoreButton = display.newImageRect(sceneGroup, "high_scores_buttom.png",150,100)
	scoreButton.x = display.contentCenterX
	scoreButton.y = 210
	scoreRect:toBack()
	scoreRect.alpha = 0.1
	scoreRect:addEventListener("tap",highScore)

	quitRect = display.newRect(sceneGroup,195,250,90,30)
	quitButton = display.newImageRect(sceneGroup, "quitButton.png", 150,100)
	quitButton.x = display.contentCenterX
	quitButton.y = 260
	quitRect:toBack()
	quitRect.alpha = 0.1
	quitRect:addEventListener("tap", exitGame)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    --Start the music
    audio.play(musicTrack, {channel=1, loops=-1})
	end
end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
  -- Code here runs immediately after the scene goes entirely off screen

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
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene