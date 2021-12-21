
/*
    Info Targets
*/
local target_radar_board = null;
target_radar_board = Entities.FindByName(target_radar_board, "target_radar_board");
::radar_board_pos <- target_radar_board.GetOrigin();

::new_radar <- function () {
    
    local radar = {

        piece_models = [],

        function reset() {
            disable_pieces();
        }
        function disable_pieces() {
            foreach (piece in piece_models) {
                piece.disable();
            }
            piece_models = [];
        }
        function update(in_pieces) {
            disable_pieces();

            foreach (piece in in_pieces) {
                if (!piece.captured) {
                    local prop = new_prop_dynamic();
                    prop.disable_shadows();
                    prop.set_scale(RADAR_BOARD_SCALE * 0.85);

                    switch (piece.type) {
                        case PIECE_TYPE.PAWN:
                        {
                            if (piece.team == TEAM.WHITE) { prop.set_model(PIECE_ICON_MODELS.WHITE.PAWN); }
                            else { prop.set_model(PIECE_ICON_MODELS.BLACK.PAWN); }
                            break;
                        }
                        case PIECE_TYPE.ROOK:
                        {
                            if (piece.team == TEAM.WHITE) { prop.set_model(PIECE_ICON_MODELS.WHITE.ROOK); }
                            else { prop.set_model(PIECE_ICON_MODELS.BLACK.ROOK); }
                            break;
                        }
                        case PIECE_TYPE.KNIGHT:
                        {
                            if (piece.team == TEAM.WHITE) { prop.set_model(PIECE_ICON_MODELS.WHITE.KNIGHT); }
                            else { prop.set_model(PIECE_ICON_MODELS.BLACK.KNIGHT); }
                            break;
                        }
                        case PIECE_TYPE.BISHOP:
                        {
                            if (piece.team == TEAM.WHITE) { prop.set_model(PIECE_ICON_MODELS.WHITE.BISHOP); }
                            else { prop.set_model(PIECE_ICON_MODELS.BLACK.BISHOP); }
                            break;
                        }
                        case PIECE_TYPE.QUEEN:
                        {
                            if (piece.team == TEAM.WHITE) { prop.set_model(PIECE_ICON_MODELS.WHITE.QUEEN); }
                            else { prop.set_model(PIECE_ICON_MODELS.BLACK.QUEEN); }
                            break;
                        }
                        case PIECE_TYPE.KING:
                        {
                            if (piece.team == TEAM.WHITE) { prop.set_model(PIECE_ICON_MODELS.WHITE.KING); }
                            else { prop.set_model(PIECE_ICON_MODELS.BLACK.KING); }
                            break;
                        }
                    }

                    local half_cell = RADAR_BOARD_SCALE * 0.5;
                    local offset = math.vec_mul(piece.cell, RADAR_BOARD_SCALE);
                    local pos = radar_board_pos + Vector(offset.x, -offset.y) + Vector(half_cell, -half_cell);
                    
                    prop.teleport(pos);
                    
                    piece_models.append(prop);
                }
            }
        }
    }

    return radar;
}
