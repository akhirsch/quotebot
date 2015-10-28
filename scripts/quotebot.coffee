# Description:
#   Quotebot scripts

module.exports = (robot) ->
        http = require 'http'

        botname = "quotebot"

        access = (url, res) ->
                http.get url, (result) ->
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
                access url, res
                
        robot.hear ///@#{botname}\s*:\s*quotefrom///i, (res) ->
                capture = ///@#{botname}\s*:\s*quotefrom\s+(.*)///i.exec res.match[2]
                name = capture[1]
                url = 'http://quotes.cs.cornell.edu/api/random'
                url += '/?speaker=' + name if name and name != ""
                access url, res
