$ ->
  $form = $(".custom_filter_form")
  customFilter = new CustomFilter($form) unless $form.length == 0

class CustomFilter
  constructor: ($el) ->
    @el = $el
    @buildForm()

  buildForm: ->
    $start_el = @el.find(".start_date")
    @startDate = new DateSelect(el: $start_el, label: "Start date")
    @startDate.render()

    $end_el = @el.find(".end_date")
    @endDate = new DateSelect(el: $end_el, label: "End date")
    @endDate.render()

    @el.find(".apply_filter").click @applyFilter

  apply_filter: ->
    alert("success!")


class DateSelect
  constructor: (options) ->
    @el = options.el
    @label = options.label

  render: ->
    @fixed = $("<input>").attr("type", "text")
    $label = $("<label>").html(@label)

    @fixed.datepicker()

    @el.append($label).append(@fixed)
