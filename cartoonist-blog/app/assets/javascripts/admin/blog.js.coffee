//= require jquery
//= require jquery.ui.datepicker
$ ->
  $("input[name='posted_at_date']").datepicker dateFormat: "yy-mm-dd"
  $(".preview-content").click ->
    $this = $(@).attr "disabled", "disabled"
    $.ajax
      url: "/admin/blog/preview_content"
      type: "post"
      data:
        authenticity_token: $("form input[name='authenticity_token']").val()
        content: $("textarea[name='content']").val()
      dataType: "text"
      success: (text) ->
        $(".preview-content").html text
        $this.removeAttr "disabled"
      error: ->
        $(".preview-content").html '<div style="color: red;">There was an error.</div>'
        $this.removeAttr "disabled"
    false
