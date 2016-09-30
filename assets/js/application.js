function newGame() {
  $.post('/game', function(data) {
    fetchBoard();
  });
  $.post('game/players/enter', function(data) {
    $('#player_id').attr('data-id', data.id).html(data.name);
  })
}

function fetchBoard() {
  return $.getJSON('/game', function (data) {
    writeBoard(data.board);
  })
}

function writeBoard(board) {
  var htmlBoard = $('#board');
  htmlBoard.empty();

  for (var i = 0; i < board.length; i++) {
    var row = board[i];
    htmlBoard.append(jsonRowToHtml(row, i));
  }
  addClickHandlers();
}

function jsonRowToHtml(row, index) {
  var elements = row.map(function (obj, i) {
    var value = (obj === null) ?  '' : obj;
    return '<td index=' + i + '>' + value + '</td>'
  });

  return '<tr index=' + index + '>' + elements.join('') + '</tr>';
}

// handlers
function addClickHandlers() {
  $('#board tr td').click(function () {
    player_id = $('#player_id').attr('data-id');
    row = $(this).parent().attr('index');
    col = $(this).attr('index');
    $.post('/game/' + player_id + '/move?row=' + row + '&col=' + col)
    fetchBoard();
  });
}
