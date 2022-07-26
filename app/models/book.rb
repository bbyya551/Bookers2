class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :view_counts, dependent: :destroy

  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_2days, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_3days, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_4days, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_5days, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_6days, -> { where(created_at: 6.day.ago.all_day) }

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def save_tags(tag_list)
    tag_list.each do |tag|
      unless find_tag = Tag.find_by(name: tag.downcase)
        begin
          self.tags.create!(name: tag)
        rescue
          nil
        end
      else
        BookTag.create!(book_id: self.id, tag_id: find_tag.id)
      end
    end
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end
