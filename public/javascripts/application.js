if (navigator.userAgent.match(/Mobile|WebOS/i)) var mobile = true;

$(function() {
  $('#chat_input').keypress(function(){
    $(this).removeAttr('style');
    $('.error').hide();
    $('.loading').hide();
  });
  
  $('#message_post_form').submit(function(e) {
    e.preventDefault();
    
    var msg = $('#chat_input').val();
    if (msg !== "") {
      $('.loading').show();
      $(this).request(function(response) {
        $('#chat_input').val('');
        $('.loading').fadeOut('fast');
      }); 
    } else {
      $('#chat_input').css({
        'border-color': 'red'
      }).focus();
      $('.error').show();
    }
  });
  
  $('#chat_input').focus();
  
  $("#chat_input").keyup(function(e){
    key = e.keyCode
    if (key == 38) {
      $('#reply .current').trigger('#down')
      return
    }
    if (key == 40) {
      $('#reply .current').trigger('#up')
      return
    }
    
    if($(this).val().match(/@[\S]+/i)){
      var html = '';
      var q = $(this).val().match(/(?:@)([\S]+)/i)[1]
      
      $.get('/users.json?q=' + q, function(data){
        users = [
          {
            id: 3,
            name: "Test user"
          },
          {
            id: 3,
            name: "Test user 2"
          },
          {
            id: 3,
            name: "Test user 3"
          }
        ]
        data = users
        for (var i=0; i < data.length; i++) {
          if (data[i]) {
            html += '<li>'+data[i].name+'</li>' 
          }
        }
        $('#reply').html(html).show();
        $('#reply li').first().addClass('current')
      })
    }
  
  
  
  })
  $('#reply .current').live('#down', function() {
    if ($(this) == $('#reply li').last()) {
      return
    }
    $(this).removeClass('current')
    $(this).next('li').addClass('current')
  })
  $('#reply .current').live('#up', function() {
    if ($(this) == $('#reply li').first()) {
      return
    }
    $(this).removeClass('current')
    $(this).prev('li').addClass('current')
  })
});

// TODO: hide reply on empty


(function($) {
  $.fn.request = function(success) {
    var jqopts = {
      url: this.attr('action'),
      type: this.attr('method') || 'GET',
      data: this.serialize(),
      complete: success
    };
    $.ajax(jqopts);
  };
})(jQuery);

var pusher = new Pusher('534d197146cf867179ee');

var channel = pusher.subscribe('groupon_go');

pusher.bind('new_post',
  function(data) {
    var tmpl = MustacheTemplates['chats/_post'];
    var post = {
      profile_image_url: data.profile_image_url,
			twitter_login: data.twitter_login,
      name: data.name,
      login: data.twiter_login,
      chat_input: data.body,
      time_ago: 'less than a minute'
    };
    $('#chat_data').prepend(Mustache.to_html(tmpl, post));
  }
);

