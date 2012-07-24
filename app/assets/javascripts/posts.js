function simple_format(msg) {
    var lines = msg.split("\n");
    var out = "";
    for(var x in lines) {
        out += "<p>"+lines[x]+"</p>"
    }
    return out;
}

function getPost(id) {
    var p;
    $.ajax({
        async: false,
        url: '/posts/'+id+'.json',
        dataType: 'json',
        success: function(r) {
            p = r;
        }
    });
    return p;
}

function getUser(id) {
    var user;
    $.ajax({
        async: false,
        url: '/users/'+id+'.json',
        dataType: 'json',
        success: function(u) {
            user = u;
        }
    });
    user.full_name = user.first_name+' '+user.last_name;
    return user;
}

function close_comment_form(div) {
    if(div.find('.add_comment').is(':visible')) {
        div.find('.add_comment').slideUp(400, function() {
            $(this).empty();
        });
    } else {
        div.find('.message').css('maxHeight', '100').html(div.data('message'));
        div.find('.message_toggle').show();
    }
}

function initMessageToggle() {
    $('.message_toggle').toggle(function() {
        var m = $(this).siblings('.message');
        var curH = m.height();
        m.css({
            'height': 'auto',
            'maxHeight': 'none'
        });
        console.log(m.css('maxHeight'));
        var autoH = m.height();
        m.height(curH).animate({'height': autoH}, 400);
        $(this).text('[ Less ]');
    }, function() {
        $(this).siblings('.message').animate({
            'height': '100px',
            'maxHeight': '100px'
        }, 400);
        $(this).text('[ More ]');
    });
}

$(function() {
    $('.post .message, .comment .message').linkify();
    $('.timeago').timeago();

    $('.show_older_comments').click(function() {
        $(this).nextAll('.comment-hidden').slideDown().removeClass('comment-hidden');
        $(this).remove();
    });

    $('.post, .comment').each(function() {
        $(this).data('message', $(this).find('.message').html());
    });

    initMessageToggle();
});