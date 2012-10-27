require 'spec_helper'

describe CustomFilter do
  it 'sets start and end date using DateSelector' do
    start_date_params = {type: 'fixed', date: '2010-12-21'}
    start_date = Date.new(2010, 12, 21)
    end_date_params = {type: 'fixed', date: '2010-12-28'}
    end_date = Date.new(2010, 12, 28)
    DateSelector.should_receive(:new).with(start_date_params).and_return(stub(date: start_date))
    DateSelector.should_receive(:new).with(end_date_params).and_return(stub(date: end_date))

    custom_filter = CustomFilter.new(start_date_params, end_date_params)

    custom_filter.start_date.should == start_date
    custom_filter.end_date.should == end_date
  end
end
