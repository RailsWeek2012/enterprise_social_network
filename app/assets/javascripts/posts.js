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
    div.find('.add_comment').slideUp(400, function() {
        $(this).empty();
    });
}

function initMessageToggle() {
    $('.message_toggle').toggle(function() {
        var m = $(this).siblings('.message').html();
        var s = $(this).siblings('.orig_message').html();
        $(this).siblings('.message').html(s);
        $(this).siblings('.orig_message').html(m);
        $(this).text('[ Less ]');
    }, function() {
        var m = $(this).siblings('.message').html();
        var s = $(this).siblings('.orig_message').html();
        $(this).siblings('.message').html(s);
        $(this).siblings('.orig_message').html(m);
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

    initMessageToggle();
});