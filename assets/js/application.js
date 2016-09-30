var player;

function newGame() {
  $.post('/game', function(data) {
    $('#choose_player').removeClass('hidden');
  });
}

function fetchBoard() {
  $.getJSON('/game', function (data) {
    writeBoard(data.board);
  });
  setTimeout(fetchBoard, 5000);
}

function writeBoard(board) {
  var htmlBoard = $('#board');
  htmlBoard.empty();

  for (var i = 0; i < board.length; i++) {
    var row = board[i];
    htmlBoard.append(jsonRowToHtml(row, i));
  }
  addBoardClickHandlers();
}

function jsonRowToHtml(row, index) {
  var elements = row.map(function (obj, i) {
    var value = (obj === null) ?  '' : obj;
    return '<td index=' + i + '>' + value + '</td>'
  });

  return '<tr index=' + index + '>' + elements.join('') + '</tr>';
}


function addBoardClickHandlers() {
  $('#board tr td').click(function () {
    player_id = $('#player_id').attr('data-id');
    row = $(this).parent().attr('index');
    col = $(this).attr('index');
    $.post('/game/' + player_id + '/move?row=' + row + '&col=' + col, function(data) {
      if (data.error) {
        alert(data.error);
      } else {
        fetchBoard();
      }
    });
  });
}

function addJoinButton(num) {
  $('#choose_player button').click(function () {
    var playerName = prompt("Enger your name: ", "Player " + num);
    if (playerName === null) { return; }
    $('#choose_player').addClass('hidden');

    $.post('game/players/join/' + playerName, function(data) {
      if (data.error) {
        alert('Game Full');
      } else {
        player = data;
        $('#player_id').attr('data-id', player.id).html(player.name);
        $('#board').removeClass('hidden');
      }
    }); 
  });
  $('#choose_player').removeClass('hidden');
}

// on load
$(function() {
  $.getJSON('/game/players', function(data) {
    if (data.length < 2) {
      addJoinButton(data.length + 1);
    } else {
      alert('Game in Progress, please watch');
    }
  });

  fetchBoard();
});
