/* Popover avec la function de Bootstrap + les spécificités pour aller chercher le contenu stocké au pied de page*/
$(function () {
  $('[data-toggle="popover"]').popover({
    container: 'body',
    html : true,
    trigger : 'hover',
    placement: 'bottom',
    content: function() {
            var idtarget = $(this).attr("data-target");
            console.log($('#'+idtarget));
            return $('#'+idtarget).html();
            }
  })
})

$('.lg-omitted .l:first-child').prepend('⟨');
$('.lg-omitted .l:last-child').append('⟩');
/*ajout par JS pour les lems et readings afint d'éviter des conditions dans les traitements déjà lourds*/
$('.hyphenleft, .hyphenaround').prepend('-');
$('.hyphenright, .hyphenaround').append('-');
$('.circleleft, .circlearound').prepend('°');
$('.circleright, .circlearound').append('°');


/* Need to add the move the element to the following-sibling[1] of the ancestor <div> of apparat-col.  */

/* move sub into the previous <a> element of siglum */
$(document).ready(function() {
    $('sub').each(function() {
        $(this).prev('a').append(this);
    });

/* Highlighting function in JQuery */
    $('.side-app').on({
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
        var newRdgOmission =$('<br/><span><i>om. </i>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu */
        var siglumOmission = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */ $(this).parents('.popover-content').nextUntil('.popover-content:has(span[class*="rdg-omissionEnd' + siglumWit + '"])').find('.reading-line:last').after().append(newRdgOmission, siglumOmission.wrap( '<b></b>').parent()).append(' (larger gap)');
    });
    
    /* Trying to add the lac. $siglum between lacunaStart and lacunaEnd 
Code only for the lateral tooltip*/
$("span[class*='rdg-lacunaStart']" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdgLacunaS =$('<br/><i>lac. </i>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu */
        var siglumLacunaS = $(this).find(".siglum:first").clone()
        var siglumWitLacunaS = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */ $(this).parents('.popover-content').nextUntil('.popover-content:has(span[class*="rdg-lacunaEnd' + siglumWitLacunaS + '"])').find('.reading-line:last').after().append(newRdgLacunaS, siglumLacunaS.wrap( '<b></b>').parent()).append(' (larger gap)');
    });

 /* Trying to add the lac. with WitEnd adn witStart for the lateral tooltip*/
$("span[class*='rdg-witEnd']" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var newRdgWitE =$('<br/><i>lac. </i>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu */
        var siglumWitE = $(this).find(".siglum:first").clone()
        var siglumWitEndHref = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */ $(this).parents('.popover-content').nextUntil('.popover-content:has(span[class*="rdg-witStart' + siglumWitEndHref + '"])').find('.reading-line:last').after().append(newRdgWitE, siglumWitE.wrap( '<b></b>').parent()).append(' (larger gap  – fragmentary witness)');
});

    /* lac. for bottom apparatus */
$("span[class*='bottom-lacunaStart']" ).each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var comma =", "
        var newBLacunaS =$(' <i>lac. </i>')
        /* Selectionne lacunaStartSiglum et cherche le premier element suivant avec la class siglum, récupere son contenu */
        var siglumWitLacunaS = $(this).find(".siglum:first").clone()
        var siglumBLacunaS = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */ $(this).parents('.bottomapp').nextUntil('.bottomapp:has(span[class*="bottom-lacunaEnd' + siglumBLacunaS + '"])').find('.bottom-reading-line:last').after().append(comma, newBLacunaS, siglumWitLacunaS.wrap( '<b></b>').parent()).append(' (larger gap)');
    });

    /* om. for bottom apparatus */
    $( "span[class*='bottom-omissionStart']").each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var comma =", "
        var newRdgBottomOmission =$(' <i>om. </i>')
        /* Cherche le premier element suivant avec la class siglum, récupere son contenu  */
        var siglumBottomOmission = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.bottomapp').nextUntil('.bottomapp:has(span[class*="bottom-omissionEnd' + siglumWit + '"])').find('.bottom-reading-line:last').after().append(comma,newRdgBottomOmission, siglumBottomOmission.wrap( '<b></b>').parent()).append(' (larger gap)');
    });
});

  /* lac. with witStart/witEnd for bottom apparatus */
$( "span[class*='bottom-witEnd']").each(function() {
/* newRDG create the lac. textual content always the same so added as such directly */
        var comma =", "
        var newRdgBottomWitEnd =$(' <i>lac. </i>')
        /* Cherche le premier element suivant avec la class siglum, récupere son contenu  */
        var siglumBottomWitEnd = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")    
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.bottomapp').nextUntil('.bottomapp:has(span[class*="bottom-witStart' + siglumWit + '"])').find('.bottom-reading-line:last').after().append(comma,newRdgBottomWitEnd, siglumBottomWitEnd.wrap( '<b></b>').parent()).append(' (larger gap – fragmentary witness)');
    });
  /* lac. with witStart/witEnd for bottom apparatus */
    $( "span[class*='bottom-witEnd']").each(function() {
    /* newRDG create the lac. textual content always the same so added as such directly */
        var comma =", "
        var newRdgBottomWitEnd =$(' <i>lac. </i>')
        /* Cherche le premier element suivant avec la class siglum, récupere son contenu  */
        var siglumBottomWitEnd = $(this).find(".siglum:first").clone()
        var siglumWit = $(this).find(".siglum:first").attr("href")
        
    /* move to the parent span element, then take all the following span elements until one has a descendant with the class lacunaEnd - find class .reading-line and after it add the newRDG and the siglum wrapped in html elements */
            $(this).parents('.bottomapp').nextUntil('.bottomapp:has(span[class*="bottom-witStart' + siglumWit + '"])').find('.bottom-reading-line:last').after().append(comma,newRdgBottomWitEnd, siglumBottomWitEnd.wrap( '<b></b>').parent()).append(' (larger gap – fragmentary witness)');
});