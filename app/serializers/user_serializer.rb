class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :personality, :age

  def personality
    object.personality&.tr("_", " ").capitalize
  end
end
