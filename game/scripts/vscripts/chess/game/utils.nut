
::BOARD_SCALE <- 128;
::GROUND_OFFSET <- 0.1;

enum TEAM {
    WHITE,
    BLACK,
}

enum PIECE_TYPE {
    NONE,
    PAWN,
    ROOK,
    KNIGHT,
    BISHOP,
    QUEEN,
    KING,
}

::COLOR <- {
    VALID_MOVE = [0,255,0],
    HOVERED_CELL = [113,169,222],
}
