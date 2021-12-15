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
    $('.lem-last-note').each(function() {
        $(this).parents('div').children('.apparat-col').append(this);
    }); 
    $("#sidebar-wrapper").mCustomScrollbar({
         theme: "minimal"
    });
});
/* move sub into the previous <a> element of siglum */
$(document).ready(function() {
    $('sub').each(function() {
        $(this).prev('a').append(this);
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
    /* Highlighting function for lem last note */
    $('.lem-last-note').on({
  mouseenter: function () {
    $(this).parent('div').prev('.text-col').children('p').css({'background-color': 'yellow'});
  },
  mouseout: function () {
    $(this).parent('div').prev('.text-col').children('p').css({'background-color': 'transparent'});
    }
     });
    /* Highlighting function for omission span */
    $('.lem-omissionStart').on({
  mouseenter: function () {
    $(this).parent('div').prev('.text-col').find('.omissionStart').css({'background-color': 'yellow'});
  },
  mouseout: function () {
    $(this).parent('div').prev('.text-col').find('.omissionStart').css({'background-color': 'transparent'});
    }
});  

/* Code for rendering omissionStart and omissionEnd in lateral apparatus */
$( ".omissionStart" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdg =$('<br/><span class="translit LatnLatn"><span class="font-italic" style="color:black;">om. </span></span>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu textuel - nodetype 3 s"assure qu'il s'agit bien d'une chaîne de caractère  */
        var siglum= $(this).find(".siglum:first").contents().clone().filter(function(){
                return this.nodeType === 3;})
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.popover-content').nextUntil('.popover-content:has(.omissionEnd)').find('.reading-line:last').after().append(newRdg, siglum.wrap( '<a class="siglum" href="#"></a>').parent().wrap( '<span class="font-weight-bold "></span>').parent());
    });
    
    /* Trying to add the lac. $siglum between lacunaStart and lacunaEnd 
Code only for the lateral tooltip*/
    $( ".lacunaStart" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdg =$('<br/><span class="translit LatnLatn"><span class="font-italic" style="color:black;">lac. </span></span>')
        /* Cherche le premier element suivant avec la class siglum, récupere son contenu textuel - nodetype 3 s"assure qu'il s'agit bien d'une chaîne de caractère  */
        var siglum= $(this).find(".siglum:first").contents().clone().filter(function(){
                return this.nodeType === 3;})
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.popover-content').nextUntil('.popover-content:has(.lacunaEnd)').find('.reading-line:last').after().append(newRdg, siglum.wrap( '<a class="siglum" href="#"></a>').parent().wrap( '<span class="font-weight-bold "></span>').parent());
    }); 
    
    /* lac. for bottom apparatus */
    $( ".bottom-lacunaStart" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdg =$('<span class="translit LatnLatn">, <span class="font-italic" style="color:black;">lac.</span></span>')
        /* Cherche le premier element suivant avec la class siglum, récupere son contenu textuel - nodetype 3 s"assure qu'il s'agit bien d'une chaîne de caractère  */
        var siglum= $(this).find(".siglum:first").contents().clone().filter(function(){
                return this.nodeType === 3;})
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.app').nextUntil('.app:has(.bottom-lacunaEnd)').find('.bottom-reading-line:last').after().append(newRdg, siglum.wrap( '<a class="siglum" href="#"></a>').parent().wrap( '<span class="font-weight-bold "></span>').parent());
    });
    
    /* omm. for bottom apparatus */
    $( ".bottom-omissionStart" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdg =$('<span class="translit LatnLatn">, <span class="font-italic" style="color:black;">om.</span></span>')
        /* Cherche le premier element suivant avec la class siglum, récupere son contenu textuel - nodetype 3 s"assure qu'il s'agit bien d'une chaîne de caractère  */
        var siglum= $(this).find(".siglum:first").contents().clone().filter(function(){
                return this.nodeType === 3;})
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.app').nextUntil('.app:has(.bottom-omissionEnd)').find('.bottom-reading-line:last').after().append(newRdg, siglum.wrap( '<a class="siglum" href="#"></a>').parent().wrap( '<span class="font-weight-bold "></span>').parent());
    });
});

$('.lg-omitted .l:first-child, .omitted').prepend('⟨');
$('.lg-omitted .l:last-child, .omitted').append('⟩');
$('.explanation, .unclear').prepend('(');
$('.explanation, .unclear').append(')');
$('.subaudible, .lineation, .foliation, .lost-illegible, .gap').prepend('[');
$('.subaudible, .lineation, .foliation, .lost-illegible, .gap').append(']');
$('.hyphenfront, .hyphenaround').prepend('-');
$('.hyphenback, .hyphenaround').append('-');
$('.circlefront, .circlearound').prepend('°');
$('.circleback, .circlearound').append('°');
$('.surplus').prepend('{');
$('.surplus').append('}');
$('.ed-insertion').prepend('⟨⟨');
$('.ed-insertion').append('⟩⟩');
$('.scribe-deletion').prepend('⟦');
$('.scribe-deletion').append('⟧');
$('.sic-crux').prepend('†');
$('.sic-crux').append('†');
