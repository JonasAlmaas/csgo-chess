
/*
    Info Targets
*/
local target_radar_board = null;
target_radar_board = Entities.FindByName(target_radar_board, "target_radar_board");
::radar_board_pos <- target_radar_board.GetOrigin();

::new_radar <- function () {
    
    local radar = {

        text = new_board_text(radar_board_pos, RADAR_BOARD_SCALE),

        function reset() {
            text.reset();
        }

        function update() {
            
        }

    }

    return radar;
}
