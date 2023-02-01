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

$(function () {
  $('[data-toggle="tooltip"]').tooltip();
      $("#sidebar-wrapper").mCustomScrollbar({
         theme: "minimal"
    });
    $('#sidebarCollapse').on('click', function () {
        $('#sidebar-wrapper').toggleClass('active');
    });
  $('.lg-omitted .l:first-child, .omitted').prepend('⟨');
$('.lg-omitted .l:last-child, .omitted').append('⟩');
$('.explanation, .unclear').prepend('(');
$('.explanation, .unclear').append(')');
$('.subaudible, .lineation, .lost-illegible, .gap').prepend('[');
$('.subaudible, .lineation, .lost-illegible, .gap').append(']');
$('.hyphenfront, .hyphenaround').prepend('-');
$('.hyphenback, .hyphenaround').append('-');
$('.circlefront, .circlearound').prepend('°');
$('.circleback, .circlearound').append('°');
$('.surplus').prepend('{');
$('.surplus').append('}');
$('.sic-crux').prepend('†');
$('.sic-crux').append('†');
})

