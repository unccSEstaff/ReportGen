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
  date_string = "#{month}-#{day}-#{year}_#{hour}-#{minute}-#{second}"
  caps_href = "/caps_#{date_string}.xml"
  ch4_href = "/ch4_#{date_string}.csv"
  $("#progress-link").attr("href", caps_href)
  $("#progress-form").attr("action", ch4_href)), 1000