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
  validates :username, presence: true, uniqueness: true, length: { minimum: 4, maximum: 16 }
  # Most introverted is 1 and most extroverted is 7
  validates :personality, allow_nil: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 1,
                                          less_than_or_equal_to: 7,
                                          message: "must be an integer between 1 and 7" }
  validates :bio, format: { without: /[<>{}\[\]|\\^~]/, message: "cannot contain special characters" },
                  length: { maximum: 300 }
  validate :birth_date_cannot_be_in_future
  validate :birth_date_set_limit, on: :update
  validate :age_limit, on: :update
  validate :username_change_limit, on: :update, if: :will_save_change_to_username?

  before_validation :generate_username, on: :create
  before_update :mark_username_as_changed, if: :will_save_change_to_username?

  def age
    return nil unless birth_date.present?

    today = Date.today
    age = today.year - birth_date.year
    age -= 1 if today < birth_date + age.years
    age
  end

  def max_joined_activities_count
    3
  end

  private

  def birth_date_cannot_be_in_future
    return if birth_date.blank?

    if birth_date > Date.today
      errors.add(:birth_date, "cannot be in the future")
    end
  end

  def birth_date_set_limit
    rule = Users::BusinessRules::BirthDateSetLimit.new(self)
    errors.add(:birth_date, rule.error_message) unless rule.valid?
  end

  def age_limit
    rule = Users::BusinessRules::AgeLimit.new(self)
    errors.add(:age, rule.error_message) unless rule.valid?
  end

  def username_change_limit
    rule = Users::BusinessRules::UsernameChangeLimit.new(self)
    errors.add(:username, rule.error_message) unless rule.valid?
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

  def mark_username_as_changed
    self.username_changed = true
  end
end
