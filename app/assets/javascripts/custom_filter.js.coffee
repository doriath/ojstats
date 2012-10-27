$ ->
  $form = $(".custom_filter_form")
  return unless $form.length != 0 and filter

  customFilter = new CustomFilter(filter)
  customFilter.render($form)




class CustomFilter
  constructor: (filter) ->
    @filter = filter

  render: ($el) ->
    @el = $el
    @renderForm()
    @bindEvents()
    @initializeData()

  renderForm: ->
    @startDateSelect = new DateSelect(label: "Start date", prefix: "start_date")
    @startDateSelect.render(@el.find(".start_date"))

    @endDateSelect = new DateSelect(label: "End date", prefix: "end_date")
    @endDateSelect.render(@el.find(".end_date"))

  bindEvents: ->
    @el.find(".apply_filter").click @applyFilter

  initializeData: ->
    @startDateSelect.initializeData(@filter["start"])
    @endDateSelect.initializeData(@filter["end"])

  applyFilter: =>
    data =
      start_date: @startDateSelect.getValuesHash()
      end_date:   @endDateSelect.getValuesHash()

    url = @createUrl(data)
    window.location = url if @validate()

  createUrl: (data) ->
    url = "/standings/custom"
    url += HashCreator.build(data)
    return url

  validate: ->
    isValid = true
    isValid = false unless @startDateSelect.validate()
    isValid = false unless @endDateSelect.validate()
    return isValid





class DateSelect
  constructor: (options) ->
    @label = options.label
    @prefix = options.prefix

  render: ($el) =>
    @el = $el

    $label = $("<label>").html(@label)
    @el.append($label)

    @fixedDate = new FixedDateSelect(prefix: @prefix)
    @fixedDate.render(@el)

    @relativeDate = new RelativeDateSelect(prefix: @prefix)
    @relativeDate.render(@el)

    @fixedDate.on("selected", => @selectFixed())
    @relativeDate.on("selected", => @selectRelative())

  initializeData: (filter) ->
    if filter["type"] == "fixed"
      @selectFixed()
      @fixedDate.setDate(filter["date"])
    else
      @selectRelative()
      @relativeDate.setDate(filter)

  selectRelative: =>
    @relativeDate.select()
    @fixedDate.deselect()
    @selectedType = "relative"

  selectFixed: =>
    @fixedDate.select()
    @relativeDate.deselect()
    @selectedType = "fixed"

  getValuesHash: =>
    return @relativeDate.getValuesHash() if @selectedType == "relative"
    return @fixedDate.getValuesHash()

  validate: =>
    return @relativeDate.validate() if @selectedType == "relative"
    return @fixedDate.validate()    if @selectedType == "fixed"
    return false





class FixedDateSelect extends Backbone.Model
  constructor: (options) ->
    @prefix = options.prefix

  render: ($el) ->
    @buildForm()
    $el.append(@row)

  setDate: (date) =>
    @input.val(date)

  select: =>
    @row.addClass("active")

  deselect: =>
    @row.removeClass("active")

  getValuesHash: =>
    type: "fixed"
    date: @input.val()

  # Form building
  buildForm: =>
    @row = @createDiv("row active control-group")

    $legend = @createDiv("legend")
    $label = @createDiv("label inline").html("Fixed date")
    $legend.append($label)

    @input = @createInput()
    @input.datepicker(format: "yyyy-mm-dd")
          .on('change', @validate)

    @row.append($legend)
        .append(@input)
    @row.click => @trigger("selected")

  createInput: ->
    return $("<input>").attr("type", "text").attr("name", @prefix + "_fixed").addClass("inline")

  createDiv: (classNames) ->
    return $("<div>").addClass(classNames)

  # Validation
  # TODO date validation in the whole modula still lacks and need a little bit of work
  validate: =>
    dateValue = @input.val()

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





class RelativeDateSelect extends Backbone.Model
  constructor: (options) ->
    @prefix = options.prefix
    @setSelectsData()
    @buildForm()

  setSelectsData: ->
    @possibleUnits = ["days", "weeks", "months", "years"]
    @possibleDirections = ["after", "before"]
    @possibleRelations = ["today", "week_begin", "week_end", "month_begin", "month_end", "year_begin", "year_end"]

  render: ($el)->
    $el.append(@row)
    @unit.dropkick()
    @direction.dropkick()
    @relation.dropkick()

  select: =>
    @row.addClass("active")

  deselect: =>
    @row.removeClass("active")

  setDate: (filter) =>
    @amount.val(filter["amount"])
    @dropkickSelect(@unit, filter["unit"])
    @dropkickSelect(@direction, filter["direction"])
    @dropkickSelect(@relation, filter["relation"])

  dropkickSelect: ($el, value) ->
    # This method supplies insufficent dropkick api
    # The timeout solution is a turnaround to not yet rendered elements
    setTimeout ->
      $option = $el.prev().find(".dk_options a[data-dk-dropdown-value=\"#{value}\"]")
      $option.click()
    , 0

  validate: -> return true

  getValuesHash: =>
    type: "relative"
    amount: @amount.val()
    unit: @unit.val()
    direction: @direction.val()
    relation: @relation.val()


  # Form building
  buildForm: =>
    @amount = @createInput("amount").val("0")
    @unit = @createSelect("unit", @possibleUnits, 20)
    @direction = @createSelect("direction", @possibleDirections, 20)
    @relation = @createSelect("relation", @possibleRelations, 70)

    $legend = @createDiv("legend")
    $label = @createDiv("label inline").html("Relative date")
    $legend.append($label)

    @row = @createDiv("row control-group").click(@activateRelative)
    @row.click => @trigger("selected")

    @row.append($legend)
    @row.append(@amount)
    @row.append(@unit)
    @row.append(@direction)
    @row.append(@relation)

  createInput: ->
    return $("<input>").attr("type", "text").addClass("inline stacked")

  createDiv: (classNames) ->
    return $("<div>").addClass(classNames)

  createSelect: (name, values, width) ->
    $select =  $("<select>").addClass(@prefix + "_" + name).addClass("inline").attr("name", @prefix + "_" + name).attr("tabindex", "2").css("width", width + "px")
    $select.append @createOption(value) for value in values
    $select

  createOption: (value) ->
    label = value.split("_").join(" ")
    return $("<option>").val(value).html(label)





class HashCreator
  # this method allows to create params hash nested 2 times, isnt very neat but does the job for now
  @build: (data) ->
    options = []
    for label, params of data
      for key, value of params
        options.push @createParam(label, key, value)

    return @joinOptions(options)

  @createParam: (label, key, value) ->
    return label + '[' + key + ']=' + value

  @joinOptions: (options) ->
    result = ""
    for option in options
      result += "&" + option
    return "?" + result[1..-1]
