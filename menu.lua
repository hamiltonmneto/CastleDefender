local composer = require("composer")

local scene = composer.newScene()

local function gotoGame()
	composer.gotoScene("game",{time=800, effect="crossFade"})
end

function scene:create( event )
	local sceneGroup = self.view
	--background = display.newImageRect( sceneGroup, "background_menu.png",600,400)
	--background.x = display.contentCenterX
	--background.y = display.contentCenterY

	local playButton = display.newImageRect( sceneGroup, "start_button.png",110,50 )
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY
	playButton:addEventListener("tap", gotoGame)
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