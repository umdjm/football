pending = false;

function loadRecommended() {
  if (pending) { return; }
  pending = true;
  $.get('/recommend', function(data) {
    player = JSON.parse(data)[0];
    $('#recommend').append('<p>' + player['name'] + ' ' + player['position'] + ' (' + player['team'] + ')</p>');
    pending = false;
  });
}

$(function() { 
  $('#recommend-button').click(loadRecommended);
})
