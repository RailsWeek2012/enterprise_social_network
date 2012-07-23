function prependPost(post) {
    var user;
    $.ajax({
        async: false,
        url: '/users/'+post.user_id+'.json',
        dataType: 'json',
        success: function(u) {
          user = u;
        }
    });
    $('#new_post').after('<div class="post"><h4 class="name">'+user.first_name+' '+user.last_name+'</h4><div class="message">'+post.message+'</div><div class="date"><abbr class="timeago" title="'+post.created_at+'">'+post.created_at+'</abbr></div></div>')
    $('.post:first .date abbr').timeago();
}

$(function() {
    $('#new_post')
        .bind('ajax:success', function(xhr, data, status) {
            prependPost(data);
        });
    $('.post .date abbr').timeago();
});