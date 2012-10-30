class RankingFilter
  include Mongoid::Document

  field :params, type: Hash
  field :name, type: String

  belongs_to :user

  def get_params
    recursive_symbolize_keys! params
  end

  private

  def recursive_symbolize_keys! hash
    hash.symbolize_keys!
    hash.values.select{|v| v.is_a? Hash}.each{|h| recursive_symbolize_keys!(h)}
    hash
  end
end
