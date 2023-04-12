
local function response(applet)
    -- If client is POSTing request, receive body
    -- local request = applet:receive()

    local response = string.format([[
        <html>
            <body>%s %s %s
            <pre>%s</pre>
            </body>
        </html>
    ]], applet.method, applet.path, applet.qs, applet.headers)

    applet:set_status(200)
    applet:add_header("content-length", string.len(response))
    applet:add_header("content-type", "text/html")
    applet:start_response()
    applet:send(response)
end

core.register_service("echoserver", "http", response)