class User < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes

  attribute :email
  unique :email
  index :email

  attribute :crypted_password

  def self.authenticate(a, b)
    u = User.new
    u.name = "test"
    return u
  end
end