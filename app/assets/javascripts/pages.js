$(function() {
    if(typeof(gon) != "undefined" && gon.hide_sidebars) {
        $('.menu, .sidebar').hide();
        $('.content').css({
            'border': '0px'
        }).parent().addClass('span12');
    }
});