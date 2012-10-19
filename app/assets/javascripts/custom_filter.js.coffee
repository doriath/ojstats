$ ->
  $form = $(".custom_filter_form")
  customFilter = new CustomFilter($form) unless $form.length == 0





class CustomFilter
  constructor: ($el) ->
    @el = $el
    @buildForm()
    @bindEvents()

  buildForm: ->
    @startDateSelect = new DateSelect(el: @el.find(".start_date"), label: "Start date")
    @startDateSelect.render()
    @startDateSelect.setDate(initialStartDate)

    @endDateSelect = new DateSelect(el:  @el.find(".end_date"), label: "End date")
    @endDateSelect.render()
    @endDateSelect.setDate(initialEndDate)

  bindEvents: ->
    @el.find(".apply_filter").click @applyFilter

  applyFilter: =>
    url = @createUrl()
    window.location = url if @validate()

  createUrl: ->
    url = "/standings"
    url += "?span=custom"
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

  render: =>
    @fixedDate = $("<input>").attr("type", "text")
    $label = $("<label>").html(@label)

    @fixedDate.datepicker(format: "yyyy-mm-dd").on('change', @validate)

    @el.append($label).append(@fixedDate)

  setDate: (date) =>
    @fixedDate.val(date)

  getUrlFor: (paramName) ->
    date = @fixedDate.val()
    return "&#{paramName}=#{date}"

  validate: =>
    dateValue = @fixedDate.val()

    #TODO date validation
    if @fixedDate.val().length == 0
      @showErrors()
      return false
    else
      @hideErrors()
      return true

  showErrors: ->
    @hideErrors()
    @el.addClass("error")
    hint = $("<div>").addClass("help-block error_description").html("Please specify the date")
    @el.append(hint)

  hideErrors: ->
    @el.removeClass("error")
    @el.find(".error_description").remove()
