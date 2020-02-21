return {
    {
        'Congratulations! You beat the game!',
        function()
            -- force a reset of various aspect
            WorldScene:init()

            Gamestate.pop()
            Gamestate.switch(CreditsScene)
        end
    },
}
