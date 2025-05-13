class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :personality, :age
end
