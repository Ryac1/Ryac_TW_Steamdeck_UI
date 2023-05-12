-- sign function supplement
function sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0;
  end


-- single decimal precision 
function singledecimalformat(num)
    return string.format(
        "%.1f %%",num
        );
end

--[[
input is an angle theta in radians
returns coordinates of corners {{0,0},{0,1},{1,0},{1,1}}after a CCW rotation of theta around center of image
]]--
-- supposed to rotate textures, works poorly for non-square dimensions
function GetRotationCoords(theta)
    local corners = {{-1,1},{-1,-1},{1,1},{1,-1}};
    local newCorners = {};
    local xPrime = {math.cos(theta),-math.sin(theta)};
    local yPrime = {math.sin(theta), math.cos(theta)};


    for i, coordPair in ipairs(corners) do
        len = math.sqrt(coordPair[1]*coordPair[1] + coordPair[2]*coordPair[2]);
        if(len > 0) then
            newCornerX = coordPair[1] * xPrime[1] + coordPair[2] * yPrime[1];
            newCornerY = coordPair[1] * xPrime[2] + coordPair[2] * yPrime[2];
        else
            newCornerX = 0;
            newCornerY = 0;
            len = 1; -- sidestep NaN 
        end
        

        newCornerX, newCornerY = (newCornerX + 2)*0.5, (2 - newCornerY)*0.5;
        newCorners[i] = {newCornerX,newCornerY};
        


    end

    return newCorners;


end

-- displays text in chat
function DisplayInChat(text)
    DEFAULT_CHAT_FRAME:AddMessage(tostring(text));

end