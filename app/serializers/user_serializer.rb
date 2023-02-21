class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :invitation_accepted

  def invitation_accepted
    object.invitation_accepted?
  end
end
