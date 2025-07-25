class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

  has_many :created_activities, class_name: "Activity", foreign_key: "user_id"
  has_many :participant_records, class_name: "Participant", dependent: :delete_all
  has_many :joined_activities, through: :participant_records, source: :activity

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX, message: "must be a valid email address" }
  validates :username, presence: true, uniqueness: true
  # Most introverted is 1 and most extroverted is 7
  validates :personality, allow_nil: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 1,
                                          less_than_or_equal_to: 7,
                                          message: "must be an integer between 1 and 7" }
  validates :bio, format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                  length: { maximum: 300 }
  validate :birth_date_constraints, on: :update
  validate :username_not_changed, on: :update

  before_validation :generate_username, on: :create
  before_update :mark_username_as_changed, if: :will_save_change_to_username?

  def age
    return nil unless birth_date.present?

    today = Date.today
    age = today.year - birth_date.year
    age -= 1 if today < birth_date + age.years
    age
  end

  def max_upcoming_created_activities_count
    3
  end

  def max_joined_activities_count
    3
  end

  private

  def birth_date_constraints
    return errors.add(:birth_date, "Your birth date can only be set once") if will_save_change_to_birth_date? && birth_date_in_database.present?

    return unless age.present?

    return errors.add(:birth_date, "You must be at least 18 years old") unless age >= 18

    errors.add(:birth_date, "Please provide a proper birth date") unless age <= 100
  end

  def username_not_changed
    if will_save_change_to_username? && username_changed
      errors.add(:username, "can only be changed once")
    end
  end

  def mark_username_as_changed
    self.username_changed = true unless username_changed
  end

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
