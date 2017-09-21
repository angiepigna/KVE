function dir2index(index::Int8, direction::String)::Int8
    if direction[1] == 'r'
        index % 5 == 0 && return 0
        length(direction) == 1 && return index + 1
        if direction[2] == 'u'
            index > 5 && return index - 4
        else
            index < 21 && return index + 6
        end
    elseif direction[1] == 'l'
        index % 5 == 1 && return 0
        length(direction) == 1 && return index - 1
        if direction[2] == 'u'
            index > 5 && return index - 6
        else
            index < 21 && return index + 4
        end
    elseif direction[1] == 'u'

        return index < 6 ? 0 : index - 5
    else
        return index > 20 ? 0 : index + 5
    end
end

function free(index::Int8, board::Array{Tuple{Int8,Int8},1})::Bool
    # must change in future
    board[index] == (2,0) && return true
    return false
end

function possible(player::Int8, index::Int8, direction::String, board::Array{Tuple{Int8,Int8},1})::Int8
    newIndex = dir2index(index, direction)
    (newIndex == 0 || !free(newIndex, board)) && return 0
    while true
        nextIndex = dir2index(newIndex, direction)
        (nextIndex == 0 || !free(nextIndex, board)) && return newIndex
        newIndex = nextIndex
    end
end

function all_moves(player::Int8, index::Int8, piece::Int8, board::Array{Tuple{Int8,Int8},1})::Array{Any,1}
    moves = []
    directions = ["u", "ru", "r", "rd", "d", "ld", "l", "lu"]
    for direction in directions
        newIndex = possible(player, index, direction, board)
        newIndex > 0 && push!(moves, (piece, direction, index, newIndex))
    end
    return moves
end

function legal_moves(player::Int8, board::Array{Tuple{Int8,Int8},1})::Array{Any,1}
    moves = []
    for piece in UnitRange{Int8}(1:5)
        index::Int8 = findfirst(board, (player, piece))
        append!(moves, all_moves(player, index, piece, board))
    end
    return moves
end