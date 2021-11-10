
::NewChess <- function () {

    local table = {
        board = NewBoard(),

        function reset() {
            board.reset()
        }

        function update() {

            board.update();
            board.draw();
        }
    }

    return table;
}
