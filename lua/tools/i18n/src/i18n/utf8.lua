local utf8 = {}

utf8.check = function(s)
    for i = 1, #s do
        if string.byte(s, i) > 127 then
            return true
        end
    end
    return false
end

return utf8
