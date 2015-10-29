# Description:
#   Quotebot scripts

module.exports = (robot) ->
        http = require 'http'

        host = 'quotes.cs.cornell.edu'
        api_random = '/api/random/'

        botname = "quotebot"


        access = (argstring, res) ->
                console.log("argstring: #{argstring}")
                opts = {
                        hostname: host,
                        path: api_random + argstring,
                        }
                console.log "opts.path: #{opts.path}"
                http.get opts, (result) ->
                        success = [200, 304]
                        sc = result.statusCode
                        if sc in success
                                result.on 'data', (data) ->
                                        json = eval '(' + data + ')'
                                        quotation = json.quotation.replace ///&#39;///g, "'"
                                        quote = "\"" + quotation + "\"\n\t-" + json.speaker
                                        quote += ", " + json.context if json.context && json.context != ""
                                        res.reply quote
                        else
                                res.reply "Sorry, I couldn't connect to the quote server (I got status " + sc + "). Is it down?"

        robot.hear ///@#{botname}\s*:?\s*randquote///i, (res) ->
                access '', res
                
        robot.hear ///@#{botname}\s*:\s*quotefrom\s+.*///i, (res) ->
                regex = ///@#{botname}\s*:\s*quotefrom\s+(.*)///i
                capture = regex.exec res.match
                name = "?speaker=#{capture[1]}"
                access name, res

        robot.hear ///@#{botname}\s*:\s*quotesearch///i, (res) ->
                regex = /\w+\s*=\s*"[^"]+"/ig
                regex2 = ///\w+///ig
                equalities = res.match.input
                console.log "Equalities: #{equalities}"
                equalities = equalities.match regex
                console.log "Equalities: #{equalities}"
                classes = (str.match regex2 for str in equalities) if equalities
                console.log "Classes: #{classes}" if classes
                tosstr = (cls) ->(str for str in cls[1..])
                tos = (cls) -> String(tosstr cls).replace /,/g, "%20"
                args = "?" + ("#{ary[0]}=#{tos(ary)}" for ary in classes) if classes
                args = args.replace ///,///g, "&"
                console.log("Args: #{args}")
                access args, res
                
        
