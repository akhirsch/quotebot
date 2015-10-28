# Description:
#   Quotebot scripts

module.exports = (robot) ->
        http = require 'http'

        botname = "quotebot"

        console.log("Botname: " + botname)
        
        robot.hear ///@#{botname}\s*:?\s+randquote///i, (res) ->
                console.log(res.match)
                http.get 'http://quotes.cs.cornell.edu/api/random/', (result) ->
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
                
