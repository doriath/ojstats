pad = (num) ->
  return "0" if num < 10
  ""

showTime = (el, t) ->
  sec = t%60
  t= parseInt(t/60)
  min = t%60
  t= parseInt(t/60)
  hours = t%24
  t= parseInt(t/24)
  days = t
  el.html("#{days}:#{pad(hours)}#{hours}:#{pad(min)}#{min}:#{pad(sec)}#{sec}")


$ ->
  $(".stage-timer .time").each ->
    $el = $(this)
    time = parseInt( $el.data("time"))

    showTime($el, time)
    setInterval( ->
      showTime($el, time)
      time--
    , 1000)
