
local composer = require( "composer" )

local scene = composer.newScene()

local font = "wg-normal-webfont.ttf"

local sqlite3 = require( "sqlite3" )
local db = sqlite3.open_memory()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Open "data.db". If the file doesn't exist, it will be created
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )   
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoMenu()
  composer.removeScene("highscores")
  composer.gotoScene("menu", {time=800, effect="crossFade"})
end


-- create()
function scene:create( event )

	local sceneGroup = self.view

	local tablesetup = [[CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, score, name);]]
	db:exec( tablesetup )
	for row in db:nrows("SELECT count (*) FROM test;") do
		local count = row.id
		if(count == 0 or count == nil) then
			for i=1,10 do
				local tablefill = [[INSERT INTO test VALUES (NULL, ']].."0"..[[',']].."-"..[['); ]]
				db:exec( tablefill )
			end
		end
	end

	if composer.getVariable("finalScore") ~= nil then
		local tablefill = [[INSERT INTO test VALUES (NULL, ']]..composer.getVariable("finalScore")..[[',']]..composer.getVariable("playerName")..[['); ]]

		db:exec( tablefill )
		composer.setVariable("finalScore", 0)
		composer.setVariable("playerName","-")
	end

	background = display.newImageRect( sceneGroup, "back02.png",580,350)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local highScoresHeader = display.newText( sceneGroup, "High Scores", 90, 15, font, 40 )
	highScoresHeader:setFillColor(0, 0, 0)
	highScoresHeader.x = 240
	highScoresHeader.y = 25
	local rowCount = 1
	for row in db:nrows("SELECT score, name FROM test ORDER BY CAST(SCORE AS int) DESC LIMIT 10;") do
		local yPos = 40 + ( rowCount * 20 )
      	local rankNum = display.newText(sceneGroup, rowCount .. ")", display.contentCenterX-50, yPos, font, 15)
		rankNum:setFillColor(0.8)
		rankNum.anchorX = 1
	    local text = row.score .. "    " .. row.name
	    local t = display.newText(sceneGroup,text, display.contentCenterX-30, yPos, font, 16 )
	    t:setFillColor( 1, 0, 1 )
	    rowCount = rowCount + 1
	end
	db:close()

	local backToMenu = display.newImage( sceneGroup, "back_to_menu.png")
	backToMenu.x = 430
	backToMenu.y = 290
	backToMenu:addEventListener("tap", gotoMenu)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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
