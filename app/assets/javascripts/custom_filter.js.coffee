$ ->
  $form = $(".custom_filter_form")
  customFilter = new CustomFilter($form) unless $form.length == 0




class CustomFilter
  constructor: ($el) ->
    @el = $el
    @buildForm()
    @bindEvents()

  buildForm: ->
    @startDateSelect = new DateSelect(el: @el.find(".start_date"), label: "Start date", prefix: "start_date")
    @startDateSelect.render()
    @startDateSelect.setDate(initialStartDate)

    @endDateSelect = new DateSelect(el:  @el.find(".end_date"), label: "End date", prefix: "end_date")
    @endDateSelect.render()
    @endDateSelect.setDate(initialEndDate)

  bindEvents: ->
    @el.find(".apply_filter").click @applyFilter

  applyFilter: =>
    url = @createUrl()
    window.location = url if @validate()

  createUrl: ->
    url = "/standings/custom?"
    url += @startDateSelect.getUrlFor("start_date")
    url += @endDateSelect.getUrlFor("end_date")
    return url

  validate: ->
    isValid = true
    isValid = false unless @startDateSelect.validate()
    isValid = false unless @endDateSelect.validate()
    return isValid





class DateSelect
  constructor: (options) ->
    @el = options.el
    @label = options.label
    @prefix = options.prefix

  render: =>
    @fixedDate = new FixedDateSelect(prefix: @prefix)
    @relativeDate = new RelativeDateSelect(prefix: @prefix)

    $label = $("<label>").html(@label)
    @el.append($label)

    @fixedDate.render(@el)
    @relativeDate.render(@el)

    @fixedDate.on("selected", @selectFixed)
    @relativeDate.on("selected", @selectRelative)

  setDate: (date) =>
    @fixedDate.setDate(date)

  getUrlFor: (paramName) ->
    date = @fixedDate.val()
    return "&#{paramName}=#{date}"

  selectFixed: =>
    @relativeDate.deselect()
    @selectedType = "fixed"

  selectRelative: =>
    @fixedDate.deselect()
    @selectedType = "relative"





class FixedDateSelect extends Backbone.Model
  constructor: ->
    @buildForm()

  render: ($el) ->
    $el.append(@row)

  setDate: (date) =>
    @input.val(date)

  select: =>
    @trigger("selected")
    @row.addClass("active")

  deselect: =>
    @row.removeClass("active")

  # Validation
  validate: =>
    dateValue = @input.val()

    #TODO date validation
    if @input.val().length == 0
      @showErrors()
      return false
    else
      @hideErrors()
      return true

  showErrors: ->
    @hideErrors()
    @row.addClass("error")
    hint = $("<div>").addClass("help-block error_description").html("Please specify the date")
    @row.append(hint)

  hideErrors: ->
    @row.removeClass("error")
    @row.find(".error_description").remove()


  # Form building
  buildForm: ->
    @row = @createDiv("row active control-group")

    $legend = @createDiv("legend")
    $label = @createDiv("label inline").html("Fixed date")
    $legend.append($label)

    @input = @createInput()
    @input.datepicker(format: "yyyy-mm-dd")
          .on('change', @validate)

    @row.append($legend).append(@input)
    @row.click(@select)

  createInput: ->
    return $("<input>").attr("type", "text").addClass("inline")

  createDiv: (classNames) ->
    return $("<div>").addClass(classNames)


class RelativeDateSelect extends Backbone.Model
  constructor: (options) ->
    @prefix = options.prefix
    @setSelectsData()
    @buildForm()

  setSelectsData: ->
    @possibleUnits = ["days", "weeks", "months", "years"]
    @possibleDirections = ["before", "after"]
    @possibleRelations = ["today", "week_begin", "month_begin", "year_begin", "start_date"]

  render: ($el)->
    $el.append(@row)
    @unit.dropkick()
    @direction.dropkick()
    @relation.dropkick()

  select: =>
    @trigger("selected")
    @row.addClass("active")

  deselect: =>
    @row.removeClass("active")

  # Form building
  buildForm: ->
    @amount = @createInput("amount")
    @unit = @createSelect("unit", @possibleUnits, 20)
    @direction = @createSelect("direction", @possibleDirections, 20)
    @relation = @createSelect("relation", @possibleRelations, 50)

    $legend = @createDiv("legend")
    $label = @createDiv("label inline").html("Relative date")
    $legend.append($label)

    @row = @createDiv("row control-group").click(@activateRelative)
    @row.click(@select)

    @row.append($legend)
    @row.append(@amount)
    @row.append(@unit)
    @row.append(@direction)
    @row.append(@relation)

  createInput: ->
    return $("<input>").attr("type", "text").addClass("inline stacked")

  createSelect: (name, values, width) ->
    $select =  $("<select>").addClass(@prefix + name).addClass("inline").attr("name", @prefix + name).attr("tabindex", "2").css("width", width + "px")
    for value in values
      $select.append @createOption value
    $select

  createOption: (value) ->
    return $("<option>").html(value)

  createDiv: (classNames) ->
    return $("<div>").addClass(classNames)
