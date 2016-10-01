var currentPlayer = {};
var players;

function newGame() {
  currentPlayer = {};
  players = undefined;

  $.post('/game', function(data) {
    updateState(data);
    setupJoinButton(1);
  });
}

function updateState(data) {
  if (data) {
    if (data.players) {
      writePlayers(data.players);
    }
    if (data.board) {
      writeBoard(data.board);
    }
  }
}

// -- START Board-related functions --

function fetchBoard() {
  $.getJSON('/game', function (data) {
    updateState(data);
  });
  setTimeout(fetchBoard, 5000);
}


function writeBoard(board) {
  var htmlBoard = $('#board');
  htmlBoard.empty();

  for (var i = 0; i < board.length; i++) {
    var row = board[i];
    htmlBoard.append(jsonBoardRowToHtml(row, i));
  }
}

function jsonBoardRowToHtml(row, index) {
  var elements = row.map(function (obj, i) {
    var value = (obj === null) ?  '' : obj;
    return '<td index=' + i + '>' + value + '</td>'
  });

  return '<tr index=' + index + '>' + elements.join('') + '</tr>';
}

function addBoardClickHandlers() {
  $('#board tr td').click(function () {
    row = $(this).parent().attr('index');
    col = $(this).attr('index');
    $.post('/game/' + currentPlayer.id + '/move?row=' + row + '&col=' + col, function(data) {
      if (data.move === false && data.error) {
        alert(data.error);
      } else if (data.move === true) {
        writeBoard(data.board);

        if (data.winner) {
          alert('You win! Congratulations!');
        }
      }
    });
  });
}

// -- END Board-related functions --

// -- START Player-related functions --

function buildPlayerHtml(obj) {
  var classString = currentPlayer.id === obj.id ? 'left' : 'left bold';

  return(
    '<div data-id="' + obj.id + '" class="' + classString + '">' +
      obj.name +
    '</div>'
  );
}

function writePlayers(players) {
  var htmlPlayers = $('#players');
  htmlPlayers.empty();

  htmlPlayers.append(
    players.map(function (p) {
      return buildPlayerHtml(p);
    }).join('<div class="seperator left">vs</div>')
  );
}

function setupJoinButton(num) {
  $('#choose_player button').click(function () {
    var playerName = prompt("Enger your name: ", "Player " + num);
    if (playerName === null) { return; }
    $('#choose_player').addClass('hidden');

    $.post('game/players/join/' + playerName, function(data) {
      if (data.error) {
        alert('Game Full');
      } else {
        currentPlayer = data.player;
        addBoardClickHandlers();
        $('#board').removeClass('hidden');
      }
    }); 
  });
  $('#choose_player').removeClass('hidden');
}

// -- END Player-related functions --

// on load
$(function() {
  fetchBoard();

  $.getJSON('/game/players', function(data) {
    if (data.length < 2) {
      setupJoinButton(data.length + 1);
    } else {
      alert('Game in Progress, please watch');
    }
  });
});
