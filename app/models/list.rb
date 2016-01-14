class List < ActiveRecord::Base
	validates :item, :user_id, presence: true

	belongs_to :user
end
