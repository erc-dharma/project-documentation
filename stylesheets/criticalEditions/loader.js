var content = $("#root").append(content);
            initializePopovers();
                     
function initializePopovers() {  
            $('[data-toggle="popover"]').popover({
            html : true,
            container: 'body',
            trigger : 'hover',
            content: function() {
            var idtarget = $(this).attr("data-target");
            console.log($('#'+idtarget));
            return $('#'+idtarget).html();
            }
            });
};

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

/* Move everything to the right but element displayed on each other */  /*jQuery(".move-to-right").appendTo ('.apparat-col')*/

/* Need to add the move the element to the following-sibling[1] of the ancestor <div> of apparat-col.  */

/* ancestor => .parents(); */
/* next sibling => .next(); */
/* JS working */

$(document).ready(function() {
    $('.move-to-right').each(function() {
        $(this).parents('div').next('.apparat-col').append(this);
    }); 
});
$(document).ready(function() {
    $('.move-to-right').each(function() {
        $(this).prev('div').children('.apparat-col').append(this);
    }); 
});

/* Highlighting function in JQuery */
$('.move-to-right').on({
  mouseenter: function () {
    id = $(this).attr('data-app');
    $('.lem[data-app="'+id+'"]').css({'background-color': 'yellow'});
  },
  mouseout: function () {
    $('.lem[data-app="'+id+'"]').css({'background-color': 'transparent'});
  }
});
