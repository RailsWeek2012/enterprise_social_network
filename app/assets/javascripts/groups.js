$(function() {
    $('#invite_to_group')
        .bind('ajax:success', function(xhr, data, status) {
            $('#invite_to_group option[value="'+data.user.id+'"]').remove();
            $('#invite_to_group').prepend('<div class="alert alert-success">'+
                '<button class="close" data-dismiss="alert">×</button>'+
                '<strong>Success!</strong> '+data.user.first_name+' '+data.user.last_name+' has been invited to the group.'+
            '</div>');
        });
});