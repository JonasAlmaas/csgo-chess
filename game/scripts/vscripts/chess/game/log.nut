
::new_log <- function () {
    
    local log = {
        moves = [],

        function reset() {
            moves = [];
        }
        function get_move(index, team) {
            return moves[index][team];
        }
        function get_last_move(team) {
            if (team == TEAM.BLACK) {
                if (moves[moves.len()-1].len() == 1) {
                    return get_move(moves.len()-2, team);
                }
            }
            return get_move(moves.len()-1, team);
        }
        function add(piece, is_castling) {
            if (is_castling) {
                moves[moves.len()-1][piece.team].is_castling = true;
            }
            else {
                if (piece.team == TEAM.WHITE) {
                    moves.append([new_log_move(piece)]);
                }
                else {
                    moves[moves.len()-1].append(new_log_move(piece));
                }
            }
        }
    }

    return log;
}

::new_log_move <- function (piece) {

    local  move = {
        team = piece.team,
        from = piece.reference_cell,
        to = piece.cell,
        is_castling = false,
    }

    return move;
}
