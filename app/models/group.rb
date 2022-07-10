class Group < ApplicationRecord
  has_many :group_users
  hes_many :users, through: :group_users

  validates :name, presence: true
  validates :introduction, presence: true
  attachment :image, destroy: false
end
