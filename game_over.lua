local composer = require( "composer" )

local scene = composer.newScene()


local function gotoGame()
	composer.gotoScene("game")
end

function scene:create( event )
	local sceneGroup = self.view
	local gameOverText = display.newText("Game Over", 70, 80, native.systemFontBold, 60)
	gameOverText:setFillColor( 0, 0, 0 )
	gameOverText.x = display.contentCenterX
	gameOverText.y = 100
	local tryAgainButton = display.newImageRect( sceneGroup, "try_again.png",110,50 )
	tryAgainButton.x = display.contentCenterX
	tryAgainButton.y = display.contentCenterY
	tryAgainButton:addEventListener("tap", gotoGame)
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
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene