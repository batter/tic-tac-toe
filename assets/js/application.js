function fetchBoard() {
  return [
    [null, null, null],
    [null, null, null],
    [null, null, null]
  ]
}

function getBoard() {
  var board = fetchBoard();
  var htmlBoard = $('#board');
  htmlBoard.empty();

  for (var row of board) {
    htmlBoard.append(jsonRowToHtml(row));
  }
}

function jsonRowToHtml(row) {
  var elements = row.map(function (obj) {
    if (obj === null) {
      return '<td>&nbsp;</td>';
    } else {
      return '<td>' + obj + '</td>';
    }
  });

  return '<tr>' + elements.join('') + '</tr>';
}
