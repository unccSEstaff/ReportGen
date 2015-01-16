padNumber = (number) ->
  if number < 10
    return "0#{number}"
  else
    return "#{number}"

setInterval (->
  date = new Date()
  month = padNumber date.getMonth() + 1
  day = padNumber date.getDate()
  year = date.getFullYear()
  hour = padNumber date.getHours()
  minute = padNumber date.getMinutes()
  second = padNumber date.getSeconds()
  href = "/caps_#{month}-#{day}-#{year}_#{hour}-#{minute}-#{second}.xml"
  $("#progress-link").attr("href", href)), 1000