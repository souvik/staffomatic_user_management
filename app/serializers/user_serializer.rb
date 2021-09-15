class UserSerializer
  include JSONAPI::Serializer

  attributes :email
  attributes :status
end
