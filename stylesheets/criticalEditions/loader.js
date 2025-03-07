﻿var content = $("#root").append(content);
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
  $('[data-toggle="tooltip"]').tooltip();
})


/* Move everything to the right but element displayed on each other */  /*jQuery(".move-to-right").appendTo ('.apparat-col')*/

/* Need to add the move the element to the following-sibling[1] of the ancestor <div> of apparat-col.  */


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
         /* Highlighting function for lem last note stanza */
    $('.lem-last-note-stanza').on({
  mouseenter: function () {
    $(this).parent('div').prev('.text-col').find('.lg').css({'background-color': 'yellow'});
  },
  mouseout: function () {
    $(this).parent('div').prev('.text-col').find('.lg').css({'background-color': 'transparent'});
    }
     });
              /* Highlighting function for lem last note verseline */
        $('.lem-last-note-verseline').on({
  mouseenter: function () {
    $('.l-last-note-verseline').css({'background-color': 'yellow'});
  },
  mouseout: function () {
    $('.l-last-note-verseline').css({'background-color': 'transparent'});
    }
     });
    /* Highlighting function for omission span */
/*    $('.lem-omissionStart').on({
  mouseenter: function () {
    $(this).parent('div').prev('.text-col').find('.omissionStart').css({'background-color': 'yellow'});
  },
  mouseout: function () {
    $(this).parent('div').prev('.text-col').find('.omissionStart').css({'background-color': 'transparent'});
    }
}); */ 

    $('.omissionStartAnchor').on({
  mouseenter: function () {
    $(".omissionAnchor-start").nextUntil(".omissionAnchor-end").css({'background-color': 'yellow'});
  },
  mouseout: function () {
 $(".omissionAnchor-start").nextUntil(".omissionAnchor-end").css({'background-color': 'transparent'});
  }
}); 



/* Code for rendering omissionStart and omissionEnd in lateral apparatus */
$("span[class*='rdg-omissionStart']" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdgOmission =$('<br/><span class="translit LatnLatn"><span class="font-italic" style="color:black;">om. </span>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu */
        var siglumOmission = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */ $(this).parents('.popover-content').nextUntil('.popover-content:has(span[class*="rdg-omissionEnd' + siglumWit + '"])').find('.reading-line:last').after().append(newRdgOmission, siglumOmission.wrap( '<span class="font-weight-bold "></span>').parent()).append(' (larger gap)');
    });
    
    /* Trying to add the lac. $siglum between lacunaStart and lacunaEnd 
Code only for the lateral tooltip*/
$("span[class*='rdg-lacunaStart']" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdgOmission =$('<br/><span class="translit LatnLatn"><span class="font-italic" style="color:black;">lac. </span>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu */
        var siglumOmission = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */ $(this).parents('.popover-content').nextUntil('.popover-content:has(span[class*="rdg-lacunaEnd' + siglumWit + '"])').find('.reading-line:last').after().append(newRdgOmission, siglumOmission.wrap( '<span class="font-weight-bold "></span>').parent()).append(' (larger gap)');
    });

    /* lac. for bottom apparatus */
    $("span[class*='bottom-lacunaStart']").each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdgOmission =$('<span class="translit LatnLatn">, <span class="font-italic" style="color:black;">lac. </span>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu */
        var siglumOmission = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */ 
    $(this).parents('.app').nextUntil('.app:has(span[class*="bottom-lacunaEnd' + siglumWit + '"])').find('.bottom-reading-line:last').after().append(newRdgOmission, siglumOmission.wrap( '<span class="font-weight-bold "></span>').parent()).sort().append(' (larger gap)');
    });
    
    /* omm. for bottom apparatus */
    $( "span[class*='bottom-omissionStart']"  ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdgBottomOmission =$('<span class="translit LatnLatn">, <span class="font-italic" style="color:black;">om. </span></span>')
        /* Cherche le premier element suivant avec la class siglum, récupere son contenu  */
        var siglumBottomOmission = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.app').nextUntil('.app:has(span[class*="bottom-omissionEnd' + siglumWit + '"])').find('.bottom-reading-line:last').after().append(newRdgBottomOmission, siglumBottomOmission.wrap( '<span class="font-weight-bold "></span>').parent()).append(' (larger gap)');
    });
});

$('.lg-omitted .l:first-child, .omitted').prepend('⟨');
$('.lg-omitted .l:last-child, .omitted').append('⟩');
$('.explanation, .unclear').prepend('(');
$('.explanation, .unclear').append(')');
$('.subaudible, .lineation, .foliation, .lost-illegible, .gap').prepend('[');
$('.subaudible, .lineation, .foliation, .lost-illegible, .gap').append(']');
$('.hyphenleft, .hyphenaround').prepend('-');
$('.hyphenright, .hyphenaround').append('-');
$('.circleleft, .circlearound').prepend('°');
$('.circleright, .circlearound').append('°');
$('.surplus').prepend('{');
$('.surplus').append('}');
$('.ed-insertion').prepend('⟨⟨');
$('.ed-insertion').append('⟩⟩');
$('.scribe-deletion').prepend('⟦');
$('.scribe-deletion').append('⟧');
$('.sic-crux').prepend('†');
$('.sic-crux').append('†');
