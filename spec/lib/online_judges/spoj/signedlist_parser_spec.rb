require 'spec_helper'

include OnlineJudges::Spoj

describe OnlineJudges::Spoj::SignedlistParser do
  describe '#accepts' do
    let(:url) { 'http://pl.spoj.pl/status/doriath/signedlist/' }
    subject { SignedlistParser.new(url) }

    context 'for list with accepted problem' do
      before { mock_request url, 'spoj/signedlist_with_accept' }
      its(:accepts) { should == [
        Accept.new(Time.zone.local(2012, 05, 16, 20, 57, 03), 'TRCTARCH')] }
    end

    context 'for list with not accepted problem' do
      before { mock_request url, 'spoj/signedlist_without_accept' }
      its(:accepts) { should == [] }
    end

    context 'for list with multiple accepts on the same problem' do
      before { mock_request url, 'spoj/signedlist_with_accepts' }
      its(:accepts) { should == [
        Accept.new(Time.zone.local(2012, 05, 14, 20, 57, 03), 'TRCTARCH')] }
    end

    context 'for list with problem that received points' do
      before { mock_request url, 'spoj/signedlist_with_points' }
      its(:accepts) { should == [
        Accept.new(Time.zone.local(2012, 05, 16, 20, 57, 03), 'TRCTARCH', 5)] }
    end
  end
end
