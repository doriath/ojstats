$ ->
  return unless calendarData
  $cal = $(".ui-calendar")
  calendar = new Calendar(calendarData.history, $cal)
  calendar.render()

class Calendar
  constructor: (history, el) ->
    @history = history

    @header = el.find(".header")
    @cells = el.find(".days")

    @setCurrentDate()
    @bindEvents()


  # Rendering
  render: ->
    data = @getMonthData()
    @renderCells data
    @renderHeader()

  renderCells: (data) ->
    @cells.html ""
    @renderEmptyCell() for i in [0...data["wday"]]
    @renderCell(accepts, dayNumber) for accepts, dayNumber in data["accepts"]

  renderHeader: ->
    @header.find(".month").html("#{@getMonthName(@currentMonth)} #{@currentYear}")

  renderEmptyCell: ->
    cell = @createCell().addClass("empty")
    @cells.append cell

  renderCell: (accepts, dayNumber) ->
    if dayNumber == 0
      #@renderEmptyCell()
      return

    cell = @createCell()
    cell.addClass("none") if accepts == 0
    cell.find(".score").addClass("double") if accepts > 9
    cell.find(".number").html(dayNumber)
    cell.find(".score").html(accepts) if @dayInPast(@currentYear, @currentMonth, dayNumber)

    @cells.append cell

  createCell: ->
    cell = $("<div>").addClass("day")
    number = $("<div>").addClass("number")
    score = $("<div>").addClass("score")
    return cell.append(number).append(score)



  # Data processing
  getMonthData: ->
    return @emptyData() if not @history[@currentYear] or not @history[@currentYear][@currentMonth]
    return {accepts: @history[@currentYear][@currentMonth], wday: @getCurrentWeekDay()}

  emptyData: ->
    length = @getCurrentMonthLength()
    array = []
    array.push 0 for x in [0..length]
    return {accepts: array, wday: @getCurrentWeekDay()}



  # Click events
  bindEvents: ->
    @header.find(".arrow.left").click => @decreaseMonth()
    @header.find(".arrow.right").click => @increaseMonth()

  increaseMonth: ->
    @currentYear++ if @currentMonth == 12
    @currentMonth = ((@currentMonth) % 12) + 1
    @render()

  decreaseMonth: ->
    @currentYear-- if @currentMonth == 1
    @currentMonth = (@currentMonth + 11) % 12
    @currentMonth = 12 if @currentMonth == 0
    @render()



  # Date function
  setCurrentDate: ->
    today = new Date()
    @currentMonth = today.getMonth() + 1
    @currentYear = today.getYear() + 1900

  getMonthName: (month) ->
    monthNames = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    monthNames[month]


  getCurrentMonthLength: ->
    if @currentMonth == 2
      return 29 if @isYearLeap()
      return 28
    return 30 + ((((@currentMonth - 1) % 7) % 2) ^ 1)

  isYearLeap: (year) ->
    (@currentYear % 4 == 0 and @currentYear % 100 != 0) or @currentYear % 400 == 0

  getCurrentWeekDay: ->
    year = @currentYear
    month = @currentMonth
    t = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
    year -= 1 if month < 3
    res = (year + parseInt(year/4) - parseInt(year/100) + parseInt(year/400) + t[month-1]) % 7
    return res

  dayInPast: (year, month, day) ->
    today = new Date()
    currentYear = today.getYear() + 1900
    currentMonth = today.getMonth() + 1
    currentDay = today.getDate()

    return false if currentYear < year
    return true if currentYear > year

    return false if currentMonth < month
    return true if currentMonth > month

    return false if currentDay < day
    return true

