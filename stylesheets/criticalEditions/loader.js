var content = $("#root").append(content);
            initializePopovers();
            
function initializePopovers() {  
            $('[data-toggle="popover"]').popover({
            html : true,
            container: 'body',
            trigger : 'focus',
            content: function() {
            var idtarget = $(this).attr("data-target");
            console.log($('#'+idtarget));
            return $('#'+idtarget).html();
            }
            });
};