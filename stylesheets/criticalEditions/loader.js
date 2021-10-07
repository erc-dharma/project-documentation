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

/* move the main apparatus notes */
$(document).ready(function() {
    $('.move-to-right').each(function() {
        $(this).parents('div').next('.apparat-col').append(this);
    }); 
});

/* move the note for whole paragraph */
$(document).ready(function() {
    $('.move-to-right').each(function() {
        $(this).prev('div').children('.apparat-col').append(this);
    }); 
});
/* move sub into the previous <a> element of siglum */
$(document).ready(function() {
    $('sub').each(function() {
        $(this).prev('a').append(this);
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

/* Trying to add the lac. $siglum between lacunaStart and lacunaEnd 
$( ".lacunaStart" )
  .contents()
  .filter(function(){
    return this.nodeType !== 1;
  })
  .wrap( "<b></b>" );

$(document).ready(function(){
    var newHeading = "<h2>Important Note:</h2>";
    var newParagraph = document.createElement("p");
    newParagraph.innerHTML = "<em>Lorem Ipsum is dummy text...</em>";
    var newImage = $('<img src="images/smiley.png" alt="Symbol">');
    $("p").before(newHeading, newParagraph, newImage);
});*/

/*
    /\* wrapping the newRdg and the siglum part if the reading line into the main span container *\/
    $(newRdg, siglum).wrap('<span class="reading-line"></span>'); 
});*/


$(document).ready(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
    
    $( ".lacunaStart" ).after(function() {
        var newRdg =$('<br/><span class="app-rdg"><span class="translit LatnLatn"><span class="font-italic" style="color:black;">lac. </span></span></span>')
        
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu textuel - nodetype 3 s"assure qu'il s'agit bien d'une chaîne de caractère  */
        var siglum= $(this).find(".siglum:first").contents().clone().filter(function(){
                return this.nodeType === 3;})
                
    /* wrap the siglum textual content into its html structure !!! CAREFUL about the integration of the the siglum into the @href with $(this) and concat:
     * .wrap( '<span class="font-weight-bold "><a class="siglum" href="#"></a></span>' ) */
        
        $(this).parents('.popover-content').next('.popover-content').find('.reading-line').after().append(newRdg, siglum);
    }); 
});