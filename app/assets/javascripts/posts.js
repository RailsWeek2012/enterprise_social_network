function prependPost(post) {
    var user = getUser(post.user_id);
    $('#new_post').after('<div class="post" id="post_'+post.id+'">'+
        '<h4 class="name">'+user.full_name+'</h4>'+
        '<div class="message">'+post.message+'</div>'+
        '<span class="date">'+
            '<abbr class="timeago" title="'+post.created_at+'">'+
                post.created_at+
            '</abbr>'+
        '</span>'+
        ' - '+
        '<span class="comments">0 Comments '+
            '<a class="btn btn-mini add_comment">Comment</a>'+
            '<form></form>'+
        '</span>'+
    '</div>');
    $.ajax({
        url: '/posts/render_comment_form',
        data: {
            'id': post.id,
            'group': $('#post_group_id').val()
        },
        dataType: "html",
        success: function(html) {
            $('.post:first .comments form').replaceWith(html);
            $('.post:first .add_comment').toggle(function() {
                $(this).next('form.new_comment_form').stop().slideDown();
            }, function() {
                $(this).next('form.new_comment_form').stop().slideUp();
            });
        }
    });
    $('.post:first .new_comment_form')
        .bind('ajax:success', function(xhr, data, status) {
            appendComment(data);
        });
    $('.post:first .timeago').timeago();
}

function appendComment(comment) {
    var user = getUser(comment.user_id);
    $('#post_'+comment.parent_id+' .comments').append('<div class="comment" id="comment_'+comment.id+'">'+
        '<h4 class="name">'+user.full_name+'</h4>'+
        '<div class="message">'+comment.message+'</div>'+
        '<span class="date">'+
        '<abbr class="timeago" title="'+comment.created_at+'">'+
            comment.created_at+
        '</abbr>'+
        '</span>'+
        '</div>');
    $('#comment_'+comment.id+' .timeago').timeago();
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
        $(this).next('form.new_comment_form').stop().slideDown();
    }, function() {
        $(this).next('form.new_comment_form').stop().slideUp();
    });

    $('.show_older_comments').click(function() {
        $(this).nextAll('.comment-hidden').show();
        $(this).remove();
    });
});