class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

  has_many :created_activities, class_name: "Activity", foreign_key: "user_id"
  has_many :participant_records, class_name: "Participant"
  has_many :joined_activities, through: :participant_records, source: :activity

  before_validation :generate_username, on: :create

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX, message: "must be a valid email address" }
  validates :username, presence: true, uniqueness: true

  enum :personality, {
    very_introverted: 1,
    introverted: 2,
    slightly_introverted: 3,
    ambiverted: 4,
    slightly_extraverted: 5,
    extraverted: 6,
    very_extraverted: 7
  }

  def max_upcoming_created_activities_count
    3
  end

  def max_joined_activities_count
    3
  end

  private

  def generate_username
    return if username.present?

    loop do
      temp_username = "user_#{SecureRandom.alphanumeric(8)}"
      unless User.exists?(username: temp_username)
        self.username = temp_username
        break
      end
    end
  end
end
