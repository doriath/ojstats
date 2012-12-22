require 'spec_helper'

describe DateSelector do
  subject(:date_selector) { DateSelector.new params }

  context 'if today is 2010-10-21,' do
    before { Timecop.freeze(Time.zone.local(2010, 10, 21, 12, 0)) }

    context 'for fixed date 2012-10-21' do
      let(:params) { {type: 'fixed', date: '2012-10-21'} }
      its(:date) { should == Date.new(2012, 10, 21) }
    end

    context '2 days before today' do
      let(:params) { {amount: '2', unit: 'days', direction: 'before'} }
      its(:date) { should == Date.new(2010, 10, 19) }
    end

    context '2 weeks before today' do
      let(:params) { {amount: '2', unit: 'weeks', direction: 'before'} }
      its(:date) { should == Date.new(2010, 10, 7) }
    end

    context '2 months before today' do
      let(:params) { {amount: '2', unit: 'months', direction: 'before'} }
      its(:date) { should == Date.new(2010, 8, 21) }
    end

    context '2 years before today' do
      let(:params) { {amount: '2', unit: 'years', direction: 'before'} }
      its(:date) { should == Date.new(2008, 10, 21) }
    end

    context '2 day after week begin (2010-10-18)' do
      let(:params) { {amount: '2', unit: 'days', direction: 'after', relation: 'week_begin'} }
      its(:date) { should == Date.new(2010, 10, 20) }
    end

    context '2 day before week end (2010-10-24)' do
      let(:params) { {amount: '2', unit: 'days', direction: 'before', relation: 'week_end'} }
      its(:date) { should == Date.new(2010, 10, 22) }
    end

    context '5 days after month begin' do
      let(:params) { {amount: '5', unit: 'days', direction: 'after', relation: 'month_begin'} }
      its(:date) { should == Date.new(2010, 10, 6) }
    end

    context '5 days before month end' do
      let(:params) { {amount: '5', unit: 'days', direction: 'before', relation: 'month_end'} }
      its(:date) { should == Date.new(2010, 10, 26) }
    end

    context '5 days after year begin' do
      let(:params) { {amount: '5', unit: 'days', direction: 'after', relation: 'year_begin'} }
      its(:date) { should == Date.new(2010, 1, 6) }
    end

    context '5 days before year end' do
      let(:params) { {amount: '5', unit: 'days', direction: 'before', relation: 'year_end'} }
      its(:date) { should == Date.new(2010, 12, 26) }
    end

    context 'when params is not a Hash' do
      let(:params) { "2012-10-27" }
      its(:date) { should == Date.new(2010, 10, 21) }
    end
  end
end
