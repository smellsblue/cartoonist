do ($ = jQuery) ->
    $ ->
        $.ajax
            url: "/announcements"
            dataType: "json"
            success: (data) ->
                console.log data
            error: () ->
                console.log "ERROR!"