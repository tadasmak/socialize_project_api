class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :personality, :age, :birth_date
end
