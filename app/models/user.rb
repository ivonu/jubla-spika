class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum role: { user: 0, moderator: 1, admin: 2 }
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

end
