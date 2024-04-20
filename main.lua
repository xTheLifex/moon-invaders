love.graphics.setDefaultFilter("nearest", "nearest")

assets = {
    player = love.graphics.newImage("assets/player.png"),
    enemy_small = love.graphics.newImage("assets/alien.png"),
    enemy_medium = love.graphics.newImage("assets/alien2.png"),
    enemy_big = love.graphics.newImage("assets/alien3.png"),
    heart = love.graphics.newImage("assets/heart.png"),
    shield = love.graphics.newImage("assets/shield.png")
}

player = {
    x = 0,
    y = 0,
    hp = 3,
    speed = 120
}

enemies = {}
shields = {}
bullets = {}
fps = 8

gameState = "game"

shipSize = 32

function drawShip(image, x, y)
    local size = shipSize/image:getWidth()
    love.graphics.draw(image, x - shipSize/2, y- shipSize/2, 0, shipSize/image:getWidth(), shipSize/image:getHeight())
end

require("utils")

function love.load()
    player.x = ScreenX()/2
    player.y = ScreenY() - 64

    local padding = {x = 16, y = 8}
    local enemiesX = 12
    local enemiesY = 5
    local enemyGridX = ScreenX()/2 - ((enemiesX * (shipSize + padding.x))/2)
    local enemyGridY = 64

    for x = 1, enemiesX do
        for y = 1, enemiesY do
            local enemy = {}
            enemy.x = enemyGridX + (x * (shipSize + padding.x))
            enemy.y = enemyGridY + (y * (shipSize + padding.y))
            local type = math.random(1,3)
            enemy.type = type
            enemy.hp = type
            table.insert(enemies, enemy)
        end
    end
end

function love.update(deltaTime)

    if (love.keyboard.isDown("d")) then
        player.x = player.x + player.speed * deltaTime
    elseif (love.keyboard.isDown("a")) then
        player.x = player.x - player.speed * deltaTime
    end

    love.timer.sleep(1/fps)
end

function love.draw()

    love.graphics.setColor(0.7,0.7,0.7)
    love.graphics.rectangle("fill", 0,0, 64, ScreenY())

    for _, enemy in ipairs(enemies) do
        love.graphics.setColor(1,0,0)
        
        if (enemy.type == 1) then
            drawShip(assets.enemy_small, enemy.x, enemy.y)
        elseif(enemy.type == 2) then
            drawShip(assets.enemy_medium, enemy.x, enemy.y)
        elseif(enemy.type == 3) then
            drawShip(assets.enemy_big, enemy.x, enemy.y)
        end

    love.graphics.setColor(1,1,1)
    drawShip(assets.player, player.x, player.y)
end