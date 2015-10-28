# Description:
#   Quotebot scripts

module.exports = (robot) ->
        http = require 'http'

        host = 'quotes.cs.cornell.edu'
        api_random = '/api/random/'

        botname = "quotebot"

        access = (name, res) ->
                argstring = ""
                escaped = name.replace ///\s+///, "%20"
                argstring = "?speaker=#{escaped}" if name
                opts = {
                        hostname: host,
                        path: api_random + argstring,
                        }
                console.log "Accessing with path #{opts.path}"
                http.get opts, (result) ->
                        success = [200, 304]
                        sc = result.statusCode
                        if sc in success
                                result.on 'data', (data) ->
                                        json = eval '(' + data + ')'
                                        quote = "\"" + json.quotation + "\"\n\t-" + json.speaker
                                        quote += ", " + json.context if json.context && json.context != ""
                                        res.reply quote
                        else
                                res.reply "Sorry, I couldn't connect to the quote server (I got status " + sc + "). Is it down?"

        robot.hear ///@#{botname}\s*:?\s*randquote///i, (res) ->
                access {}, res
                
        robot.hear ///@#{botname}\s*:\s*quotefrom\s+.*///i, (res) ->
                regex = ///@#{botname}\s*:\s*quotefrom\s+(.*)///i
                console.log("regex: #{regex}")
                console.log("raw: #{res.match}")
                capture = regex.exec res.match
                console.log("Capture: #{capture}")
                name = capture[1]
                console.log("name: #{name}")
                access name, res
