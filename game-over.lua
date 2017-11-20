local composer = require( "composer" )

local scene = composer.newScene()

local font = "wg-normal-webfont.ttf"


local function gotoMenu()
	composer.setVariable("finalScore", nil)
	composer.removeScene("game-over")
	composer.gotoScene("menu")
end

local function gotoGame()
	composer.setVariable("finalScore", nil)
	composer.removeScene("game-over")
	composer.gotoScene("game")
end

local function gotoScores()
	composer.setVariable("finalScore", nil)
	composer.removeScene("game-over")
	composer.gotoScene("highscores")
end

function scene:create( event )
	local sceneGroup = self.view
	background = display.newImageRect(sceneGroup,"games.png",567, 320)
	background.x = 240 
	background.y = 160
	local gameOverText = display.newImage(sceneGroup,"game-over.png")
	gameOverText.x = display.contentCenterX
	gameOverText.y = 100

	if composer.getVariable("playerName") ~= "" then
		local playerName = display.newText( sceneGroup, "Player's name: ", 90, 15, font, 25 )
		playerName:setFillColor(0, 0, 0)
		playerName.text = "Player's name: " .. composer.getVariable("playerName")
		playerName.x = 230
		playerName.y = 130
	end

	local playerScore = display.newText( sceneGroup, "Score: ", 90, 15, font, 25 )
	playerScore:setFillColor(0, 0, 0)
	playerScore.text = "Score: " .. composer.getVariable("finalScore")
	playerScore.x = 230
	playerScore.y = 160

	local playerTotalMoney = display.newText( sceneGroup, "Total Money: ", 90, 15, font, 25 )
	playerTotalMoney:setFillColor(0,0,0)
	playerTotalMoney.text = "Total Money: " .. composer.getVariable("totalMoney")
	playerTotalMoney.x = 230
	playerTotalMoney.y = 190

	local tryAgainButton = display.newImage( sceneGroup, "tryAgain.png")
	tryAgainButton.x = 50
	tryAgainButton.y = 260
	tryAgainButton:addEventListener("tap", gotoGame)

	local backToMenu = display.newImage( sceneGroup, "back_to_menu.png")
	backToMenu.x = display.contentCenterX
	backToMenu.y = 260
	backToMenu:addEventListener("tap",gotoMenu)

	local highScores = display.newImage(sceneGroup, "high_scores.png")
	highScores:addEventListener("tap",gotoScores)
	highScores.x = 430
	highScores.y = 260
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