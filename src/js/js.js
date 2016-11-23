$(function() {
    $('.top.fixed.menu a').click(function() {
	$('.top.fixed.menu .toggle').prop('checked', false);
    })
    $('.ui.accordion').accordion();
});
