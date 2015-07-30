class Collection < ActiveRecord::Base
  belongs_to :workspace
  has_many :entries
end
