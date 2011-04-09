$(function() {
  $('#chat_input').keypress(function(){
    $(this).removeAttr('style');
    $('.error').hide();
  })
  
  $('#message_post_form').submit(function(e) {
    e.preventDefault();
    var msg = $('#chat_input').val()
    if (msg != "") {
      $(this).request(function(response) {
        console.log(response);
      }); 
    } else {
      $('#chat_input').css({
        'border-color': 'red'
      }).focus();
      $('.error').show();
    }
  });
  $('#chat_input').focus();
});


(function($) {
  $.fn.request = function(opts) {
    var jqopts = {
      url: this.attr('action'),
      type: this.attr('method') || 'GET',
      data: this.serialize()
    };
    return $.ajax(jqopts);
  };
})(jQuery);

var pusher = new Pusher('534d197146cf867179ee');

var channel = pusher.subscribe('groupon_go');

pusher.bind('new_post',
  function(data) {
    $('#chat_input').val('');
    $('#chat_data').prepend($('<li/>', {
      html: data.name + data.body
    }));
  }
);



