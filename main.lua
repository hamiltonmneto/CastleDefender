
display.setStatusBar(display.HiddenStatusBar)
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 100 )
--physics.setDrawMode("hybrid")


local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- set up forward references

local castle
local hitCastle
local spawnEnemy
local numberEnemies = 5
local score = 0
local wall = display.newImage("wall.png")
local physicsData = (require "shapedefs").physicsData(1.0)
local branches_01
local branches_02


function spawnEnemy()
	for i=1,numberEnemies do
		enemy = display.newImage("enemy.png",50,50,10)
		physics.addBody(enemy,"dynamic",physicsData:get("enemy"))
		enemy:addEventListener("tap",enemyKill)
		enemy.gravityScale = -0
		enemy.isFixedRotation = true
		enemy.type = "enemy"
		local speed = 0.1
		enemy.collision = enemyTreeCollision
		enemy:addEventListener("collision",enemy)
		
		if math.random(2) == 1 then
			enemy.x = math.random(-100, -10)
			
			--enemy:applyLinearImpulse(-1,0,castle.x,castle.y)
		else
			enemy.x = math.random (display.contentWidth + 10, display.contentWidth + 100)
			--enemy:setLinearVelocity(-40,0)
		end
			enemy.y = math.random(display.contentHeight)
			--enemy.trans = transition.to(enemy, {x=centerX, y=centerY, time=5000,onComplete=hitCastle})
			enemy:setLinearVelocity((castle.x - enemy.x) * speed,(castle.y - enemy.y) * speed)
			
	end
	timer.performWithDelay( 10000, spawnEnemy, 0 )
	branches_02:toFront()
	branches_01:toFront()
end

function createPlaySreen()
	local background = display.newImage("level01_2.png")
	background.x =  centerX 
	background.y =  centerY
	scoreText = display.newText(score,display.contentCenterX, 20, native.systemFont, 40)

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



--	local tree_01 = display.newImage("tree_01.png" )
--	tree_01.type = "tree"
--	physics.addBody(tree_01, "static", physicsData:get("tree_01"))
--	local tree_02 = display.newImage("tree_01.png")
--	tree_02.type = "tree"
--	physics.addBody(tree_02, "static",physicsData:get("tree_01"))
--	tree_02.x = 400
--	tree_02.y = 260
	castle = display.newImage("castleMenor.png")
	physics.addBody(castle, "static")
	castle.type = "castle"
	castle.x = 230
	castle.y = 120
end

local function spawnWall(event)
	wall = display.newImage("wall.png")
	wall.x = centerX
	wall.y = centerY
	wall:addEventListener( "tap", spawnWall )
	return true
end

function enemyKill(event)
	local numSpawn = 0
	local enemy = event.target
	display.remove(enemy)
	transition.cancel ( event.target.trans )
	score = score + 1
	scoreText.text = "Score: " .. score
	
	return true
end

function enemyTreeCollision(self, event)
	if event.phase == "began" then
		local enemyX, enemyY = self:localToContent( 0, 0 )
		if event.target.type == "enemy" and event.other.type == "enemy" then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
			print("COLLIDED WITH ENEMY")
		elseif(event.target.type == "enemy" and event.other.type == "tree" or event.other.type == "tree" and event.target.type == "enemy" ) then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
			print("COLLIDED IN TREE")
		elseif(event.target.type == "enemy" and event.other.type == "castle") then
			hitCastle(self)
		end
	elseif event.phase == "ended" then
		local enemyX, enemyY = self:localToContent( 0, 0 )
		if event.target.type == "enemy" and event.other.type == "enemy" then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
			print("COLLIDED WITH ENEMY")
		elseif(event.target.type == "enemy" and event.other.type == "tree" or event.other.type == "tree" and event.target.type == "enemy" ) then
			timer.performWithDelay( 2000)
			self:setLinearVelocity((castle.x - enemyX) * 0.2,(castle.y - enemyY) * 0.2)
			print("COLLIDED IN TREE")
		end
	end
end


function hitCastle(obj)
	display.remove(obj)
end

createPlaySreen()

spawnEnemy()



