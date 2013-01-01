do ($ = jQuery) ->
    $.announcement = (announcement) ->
        $.extend announcement,
            append: () ->
                return @appendedContent if @appendedContent
                @appendedContent = $(@content).wrap(@wrapper()).parent().hide()
                $(@target()).append @appendedContent
                @appendedContent

            isDisplayed: () ->
                return true unless @target == "session"
                true

            show: () ->
                @append().slideDown() if @isDisplayed()

            target: () ->
                switch @location
                    when "top"
                        ".header"
                    when "session"
                        $("body").prepend("""<div class="session-announcements-container" />""") unless $(".session-announcements-container").size() > 0
                        ".session-announcements-container"
                    else
                        ".header"

            wrapper: () ->
                """<div id="announcement-#{@id}" class="announcement #{@location}-announcement" />"""

    $ ->
        $.ajax
            url: "/announcements"
            dataType: "json"
            success: (data) ->
                return unless data.announcements?.length > 0
                $.each data.announcements, (_, announcement) ->
                    $.announcement(announcement).show()
