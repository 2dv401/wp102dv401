class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :status_update
end
