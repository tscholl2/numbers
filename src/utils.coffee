module.exports =

  base64ToByteArray: (s) ->
    b = []
    i = 0
    d = atob(s)
    while not isNaN d.charCodeAt i
      b.push(d.charCodeAt(i))
      i++
    return b
