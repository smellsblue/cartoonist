do ($ = jQuery) ->
    CLOSED_ANNOUNCEMENTS_COOKIE = "closedAnnouncements"
    COOKIE_EXPIRATION = 5 * 365 * 24 * 60 * 60 * 1000

    $.announcement = (announcement) ->
        $.extend announcement,
            append: () ->
                return @appendedContent if @appendedContent
                @appendedContent = $ @content

                if @isSession()
                    button = $ """<button class="close-announcent">&times;</button>"""
                    button.click =>
                        @markCookie()
                        @appendedContent?.slideUp => @appendedContent.remove()
                        false
                    @appendedContent.append button

                @appendedContent.addClass("announcement #{@location}-announcement").attr("id", "announcement-#{@id}").hide()
                $(@target()).append @appendedContent
                @appendedContent

            getCookieValue: () ->
                return [] unless document.cookie
                cookies = document.cookie.split ";"
                announcementCookie = null

                $.each cookies, (_, cookie) ->
                    value = cookie.split "="
                    if $.trim(value[0]) == CLOSED_ANNOUNCEMENTS_COOKIE
                        announcementCookie = value
                        return false

                return [] unless announcementCookie

                $.map $.trim(announcementCookie[1]).split(","), (id, _) ->
                    parseInt id, 10

            isSession: () ->
                @location == "session"

            isDisplayed: () ->
                return true unless @isSession()
                $.inArray(@id, @getCookieValue()) < 0

            markCookie: () ->
                expiration = new Date()
                expiration.setTime(expiration.getTime() + COOKIE_EXPIRATION)
                value = @getCookieValue()
                value.push @id unless $.inArray(@id, value) >= 0
                value = value.join ","
                document.cookie = "#{CLOSED_ANNOUNCEMENTS_COOKIE}=#{value}; expires=#{expiration.toGMTString()}"

            show: () ->
                @append().slideDown() if @isDisplayed()

            target: () ->
                if @isSession()
                    $("body").prepend("""<div class="session-announcements-container" />""") unless $(".session-announcements-container").size() > 0
                    ".session-announcements-container"
                else
                    ".header"

    $ ->
        $.ajax
            url: "/announcements"
            dataType: "json"
            success: (data) ->
                return unless data.announcements?.length > 0
                $.each data.announcements, (_, announcement) ->
                    $.announcement(announcement).show()
