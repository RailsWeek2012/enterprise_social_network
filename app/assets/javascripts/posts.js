function simple_format(msg) {
    var lines = msg.split("\n");
    var out = "";
    for(var x in lines) {
        out += "<p>"+lines[x]+"</p>"
    }
    return out;
}

function prependPost(post) {
    var user = getUser(post.user_id);
    post.message = simple_format(post.message)
    $('#new_post').after('<div class="post" id="post_'+post.id+'">'+
        '<h4 class="name"><a href="/users/'+user.id+'">'+user.full_name+'</a></h4>'+
        '<div class="message">'+post.message+'</div>'+
        '<span class="date">'+
            '<abbr class="timeago" title="'+post.created_at+'">'+
                post.created_at+
            '</abbr>'+
        '</span>'+
        ' - '+
        '<span class="comments"><i class="icon-comments-alt"></i> 0 Comments'+
            ' <a class="btn btn-mini add_comment"><i class="icon-comment-alt"></i> Comment</a>'+
            ' <a class="btn btn-mini" onclick="editPost($(this).parents(\'.post\'))"><i class="icon-pencil"></i> Edit</a>'+
            ' <a class="btn btn-mini btn-danger" onclick="deletePost($(this).parents(\'.post\'))"><i class="icon-remove"></i> Delete</a>'+
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
                $(this).nextAll('form.new_comment_form').stop().slideDown();
            }, function() {
                $(this).nextAll('form.new_comment_form').stop().slideUp();
            });
        }
    });
    $('.post:first .new_comment_form')
        .bind('ajax:success', function(xhr, data, status) {
            appendComment(data);
        });
    $('.post:first .timeago').timeago();
    if(post.message.length > 300) {
        $('.post:first .message')
            .html(post.message.substring(0,300)+"...")
            .after('<a class="message_toggle">[ More ]</a><div class="orig_message">'+post.message+'</div>');
        initMessageToggle();
    }
    $('.post:first .message').linkify();
}

function editPost(post) {
    var p = getPost(post.attr("id").split("_")[1]);
    var x = prompt("Edit your message:", p.message);
    if(x.trim()) {
        $.ajax({
            url: '/posts/'+p.id+'.json',
            type: 'PUT',
            data: {
                post: {
                    message: x,
                    group_id: p.group_id,
                    user_id: p.user_id,
                    company_id: p.company_id
                }
            },
            success: function(new_p) {
                post.find('.message').text(new_p.message).linkify();
            },
            error: function() {
                alert("Could not edit post.");
            }
        });
    }
}

function deletePost(post) {
    if(confirm("Do you really want to delete this post and all its comments?")) {
        $.ajax({
            url: '/posts/'+post.attr("id").split("_")[1],
            dataType: 'json',
            type: 'DELETE',
            success: function() {
                post.slideUp(400, function() {
                    $(this).remove();
                });
            }
        })
    }
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

function editComment(comment) {
    var c = getPost(comment.attr("id").split("_")[1]);
    var x = prompt("Edit your message:", c.message);
    if(x.trim()) {
        $.ajax({
            url: '/posts/'+c.id+'.json',
            type: 'PUT',
            data: {
                post: {
                    message: x,
                    group_id: c.group_id,
                    user_id: c.user_id,
                    company_id: c.company_id
                }
            },
            success: function(new_c) {
                comment.find('.message').text(new_c.message).linkify();
            },
            error: function() {
                alert("Could not edit post.");
            }
        });
    }
}

function deleteComment(comment) {
    if(confirm("Do you really want to delete this comment?")) {
        $.ajax({
            url: '/posts/'+comment.attr("id").split("_")[1],
            dataType: 'json',
            type: 'DELETE',
            success: function() {
                comment.slideUp(400, function() {
                    $(this).remove();
                });
            }
        })
    }
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