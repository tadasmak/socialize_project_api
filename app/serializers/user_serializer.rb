class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :personality, :age, :bio
end
