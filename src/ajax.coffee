encodeURIObject = (obj) ->
  s = ""
  for k,v of obj
    s += "\&#{encodeURIComponent(k)}=#{encodeURIComponent(v)}"
  return s

module.exports = (url,type="GET",data=null) ->
  # Return a new promise.
  new Promise (resolve, reject) ->
    # Do the usual XHR stuff
    req = new XMLHttpRequest()
    if data? and type is "GET"
      url += "?#{encodeURIObject(data)}"
    req.open type, url

    req.onload = () ->
      # This is called even on 404 etc
      # so check the status
      if req.status == 200
        # Resolve the promise with the response text
        console.log req.response
        resolve JSON.parse(req.response)
      else
        # Otherwise reject with the status text
        # which will hopefully be a meaningful error
        reject Error req.statusText

    # Handle network errors
    req.onerror = () ->
      reject Error "Network Error"

    # Make the request
    if type is "POST" and data?
      req.send encodeURIObject data
    else
      req.send()
