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

function appendComment(comment) {
    var user = getUser(comment.user_id);
    comment.message = simple_format(comment.message)
    $('#post_'+comment.parent_id+' .comments').append('<div class="comment" id="comment_'+comment.id+'">'+
        '<h4 class="name"><a href="/users/'+user.id+'">'+user.full_name+'</a></h4>'+
        '<div class="message">'+comment.message+'</div>'+
        '<span class="date">'+
        '<abbr class="timeago" title="'+comment.created_at+'">'+
            comment.created_at+
        '</abbr>'+
        '</span>'+
        ' <a class="btn btn-mini" onclick="editComment($(this).parents(\'.comment\'))"><i class="icon-pencil"></i> Edit</a>'+
        ' <a class="btn btn-mini btn-danger" onclick="deleteComment($(this).parents(\'.comment\'))"><i class="icon-remove"></i> Delete</a>'+
        '</div>');
    $('#comment_'+comment.id+' .timeago').timeago();
    if(comment.message.length > 300) {
        $('#comment_'+comment.id+' .message')
            .html(comment.message.substring(0,300)+"...")
            .after('<a class="message_toggle">[ More ]</a><div class="orig_message">'+comment.message+'</div>');
        initMessageToggle();
    }

    $('#comment_'+comment.id+' .message').linkify();
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
    $('#new_post')
        .bind('ajax:success', function(xhr, data, status) {
            prependPost(data);
            $('#new_post textarea').val('');
        });
    $('.new_comment_form')
        .bind('ajax:success', function(xhr, data, status) {
            appendComment(data);
            $('#post_'+data.parent_id+' .new_comment_form textarea').val('');
            $('#post_'+data.parent_id+' .add_comment').click();
        });
    $('.timeago').timeago();

    $('.add_comment').toggle(function() {
        $(this).nextAll('form.new_comment_form').stop().slideDown();
    }, function() {
        $(this).nextAll('form.new_comment_form').stop().slideUp();
    });

    $('.show_older_comments').click(function() {
        $(this).nextAll('.comment-hidden').show();
        $(this).remove();
    });

    initMessageToggle();
});