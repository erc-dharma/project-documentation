var content = $("#root").append(content);
            initializePopovers();
                     
function initializePopovers() {  
            $('[data-toggle="popover"]').popover({
            html : true,
/*            container: 'body',*/
            trigger : 'hover',
            content: function() {
            var idtarget = $(this).attr("data-target");
            console.log($('#'+idtarget));
            return $('#'+idtarget).html();
            }
            });
};

$(function () {
  $('[data-toggle="tooltip"]').tooltip();
})
 
/* move the note for whole paragraph */
$(document).ready(function() {
    $("#sidebar-wrapper").mCustomScrollbar({
         theme: "minimal"
    });
    $('#sidebarCollapse').on('click', function () {
                $('#sidebar-wrapper, #content').toggleClass('active');
                $('.collapse.in').toggleClass('in');
                $('a[aria-expanded=true]').attr('aria-expanded', 'false');
            });
});