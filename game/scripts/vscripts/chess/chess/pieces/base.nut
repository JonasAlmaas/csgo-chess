
::precache_chess_pieces <- function () {
    self.PrecacheModel("models/chess/pieces/pawn.mdl");
    self.PrecacheModel("models/chess/pieces/knight.mdl");
    self.PrecacheModel("models/chess/pieces/rook.mdl");
    self.PrecacheModel("models/chess/pieces/bishop.mdl");
    self.PrecacheModel("models/chess/pieces/queen.mdl");
    self.PrecacheModel("models/chess/pieces/king.mdl");
}

::NewPiece <- function (type, team, pos) {

    local piece = null;

    switch (type) {
        case "pawn":
        {
            piece = NewPawn(team, pos);
            break;
        }
        case "knight":
        {
            piece = NewKnight(team, pos);
            break;
        }
        case "rook":
        {
            piece = NewRook(team, pos);
            break;
        }
        case "bishop":
        {
            piece = NewBishop(team, pos);
            break;
        }
        case "queen":
        {
            piece = NewQueen(team, pos);
            break;
        }
        case "king":
        {
            piece = NewKing(team, pos);
            break;
        }
        default:
            console.chat("Invalid piece: " + type);
            break;
    }

    return piece;
}

::NewPieces <- function (cell_size, board_pos) {
    local pieces = [];

    local CELL_SIZE = cell_size;
    local BOARD_SIZE = cell_size * 8;
    local HALF_BOARD_SIZE = (cell_size * 8) / 2;
    local HALF_CELL_SIZE = cell_size / 2;
    
    local pos_white_left = board_pos + Vector(HALF_BOARD_SIZE, -HALF_BOARD_SIZE);
    local pos_black_left = board_pos + Vector(-HALF_BOARD_SIZE, HALF_BOARD_SIZE);
    
    // Create pawns
    for (local i = 0; i < 8; i++) {
        local pos_white = [2, i + 1];
        local pos_black = [7, 8 - i];

        local piece_whiet = NewPiece("pawn", "white", pos_white);
        local piece_black = NewPiece("pawn", "black", pos_black);

        local pos_white = pos_white_left + Vector(0, i * CELL_SIZE) + Vector(-(CELL_SIZE + HALF_CELL_SIZE), HALF_CELL_SIZE);
        local pos_black = pos_black_left + Vector(0, -(i * CELL_SIZE)) + Vector(CELL_SIZE + HALF_CELL_SIZE, -HALF_CELL_SIZE);

        piece_whiet.teleport(pos_white, Vector(0, 270));
        piece_black.teleport(pos_black, Vector(0, 90));

        piece_whiet.setSize(CELL_SIZE);
        piece_black.setSize(CELL_SIZE);

        pieces.append(piece_whiet);
        pieces.append(piece_black);
    }

    // Create rooks
    for (local i = 0; i < 2; i++) {
        local pos_white = [1, 0];
        local pos_black = [8, 0];

        if (i == 0) {
            pos_white[1] = 1;
            pos_black[1] = 8;
        } else {
            pos_white[1] = 8;
            pos_black[1] = 1;
        }

        local piece_whiet = NewPiece("rook", "white", [0, 0]);
        local piece_black = NewPiece("rook", "black", [0, 0]);

        local pos_white = pos_white_left + Vector(0, i * (BOARD_SIZE - CELL_SIZE)) + Vector(-HALF_CELL_SIZE, HALF_CELL_SIZE);
        local pos_black = pos_black_left + Vector(0, -(i * (BOARD_SIZE - CELL_SIZE))) + Vector(HALF_CELL_SIZE, -HALF_CELL_SIZE);

        piece_whiet.teleport(pos_white, Vector(0, 270));
        piece_black.teleport(pos_black, Vector(0, 90));
        
        piece_whiet.setSize(CELL_SIZE);
        piece_black.setSize(CELL_SIZE);

        pieces.append(piece_whiet);
        pieces.append(piece_black);
    }

    // Create knights
    for (local i = 0; i < 2; i++) {
        local pos_white = [1, 0];
        local pos_black = [8, 0];

        if (i == 0) {
            pos_white[1] = 2;
            pos_black[1] = 7;
        } else {
            pos_white[1] = 7;
            pos_black[1] = 2;
        }

        local piece_whiet = NewPiece("knight", "white", pos_white);
        local piece_black = NewPiece("knight", "black", pos_black);

        local pos_white = pos_white_left + Vector(-HALF_CELL_SIZE, HALF_CELL_SIZE);
        local pos_black = pos_black_left + Vector(HALF_CELL_SIZE, -HALF_CELL_SIZE);

        if (i == 0) {
            pos_white += Vector(0, CELL_SIZE)
            pos_black += Vector(0, -CELL_SIZE)
        } else {
            pos_white += Vector(0, BOARD_SIZE - CELL_SIZE * 2)
            pos_black += Vector(0, -(BOARD_SIZE - CELL_SIZE * 2))
        }

        piece_whiet.teleport(pos_white, Vector(0, 270));
        piece_black.teleport(pos_black, Vector(0, 90));
        
        piece_whiet.setSize(CELL_SIZE);
        piece_black.setSize(CELL_SIZE);

        pieces.append(piece_whiet);
        pieces.append(piece_black);
    }

    // Create bishops
    for (local i = 0; i < 2; i++) {
        local pos_white = [1, 0];
        local pos_black = [8, 0];

        if (i == 0) {
            pos_white[1] = 3;
            pos_black[1] = 6;
        } else {
            pos_white[1] = 6;
            pos_black[1] = 3;
        }

        local piece_whiet = NewPiece("bishop", "white", pos_white);
        local piece_black = NewPiece("bishop", "black", pos_black);

        local pos_white = pos_white_left + Vector(-HALF_CELL_SIZE, HALF_CELL_SIZE);
        local pos_black = pos_black_left + Vector(HALF_CELL_SIZE, -HALF_CELL_SIZE);

        if (i == 0) {
            pos_white += Vector(0, CELL_SIZE * 2)
            pos_black += Vector(0, -(CELL_SIZE * 2))
        } else {
            pos_white += Vector(0, BOARD_SIZE - CELL_SIZE * 3)
            pos_black += Vector(0, -(BOARD_SIZE - CELL_SIZE * 3))
        }

        piece_whiet.teleport(pos_white, Vector(0, 270));
        piece_black.teleport(pos_black, Vector(0, 90));
        
        piece_whiet.setSize(CELL_SIZE);
        piece_black.setSize(CELL_SIZE);

        pieces.append(piece_whiet);
        pieces.append(piece_black);
    }
    
    // Create Queens
    {
        local piece_whiet = NewPiece("queen", "white", [1, 4]);
        local piece_black = NewPiece("queen", "black", [8, 4]);

        local pos_white = pos_white_left + Vector(0, CELL_SIZE * 3) + Vector(-HALF_CELL_SIZE, HALF_CELL_SIZE);
        local pos_black = pos_black_left + Vector(0, -(CELL_SIZE * 4)) + Vector(HALF_CELL_SIZE, -HALF_CELL_SIZE);

        piece_whiet.teleport(pos_white, Vector(0, 270));
        piece_black.teleport(pos_black, Vector(0, 90));
        
        piece_whiet.setSize(CELL_SIZE);
        piece_black.setSize(CELL_SIZE);

        pieces.append(piece_whiet);
        pieces.append(piece_black);
    }

    // Create Kings
    {
        local piece_whiet = NewPiece("king", "white", [1, 5]);
        local piece_black = NewPiece("king", "black", [8, 5]);

        local pos_white = pos_white_left + Vector(0, CELL_SIZE * 4) + Vector(-HALF_CELL_SIZE, HALF_CELL_SIZE);
        local pos_black = pos_black_left + Vector(0, -(CELL_SIZE * 3)) + Vector(HALF_CELL_SIZE, -HALF_CELL_SIZE);

        piece_whiet.teleport(pos_white, Vector(0, 270));
        piece_black.teleport(pos_black, Vector(0, 90));
        
        piece_whiet.setSize(CELL_SIZE);
        piece_black.setSize(CELL_SIZE);

        pieces.append(piece_whiet);
        pieces.append(piece_black);
    }

    return pieces;
}
