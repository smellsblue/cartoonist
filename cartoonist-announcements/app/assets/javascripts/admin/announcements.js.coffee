//= require jquery
//= require jquery.ui.datepicker
$ ->
    $("input[name='posted_at_date']").datepicker dateFormat: "yy-mm-dd"
    $("input[name='expired_at_date']").datepicker dateFormat: "yy-mm-dd"
