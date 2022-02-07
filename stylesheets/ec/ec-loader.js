$(document).ready(function () {

    $("#sidebar").mCustomScrollbar({
         theme: "minimal"
    });
    $('#sidebarCollapse').on('click', function () {
        // open or close navbar
        $('#sidebar-wrapper').toggleClass('active');
        // close dropdowns
    });

});
