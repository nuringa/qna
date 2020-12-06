class User < ApplicationRecord
  has_many :questions, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id
  has_many :rewards
  has_many :comments, foreign_key: "author_id", dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    resource.author_id == id
  end
end
