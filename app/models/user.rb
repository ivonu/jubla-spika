class User < ActiveRecord::Base

  has_many :ratings
  has_many :comments, dependent: :destroy
  has_many :programs
  has_many :entries

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum role: { user: 0, writer: 1, moderator: 2, admin: 3 }
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  def is_user?
    self.user? || self.is_writer?
  end

  def is_writer?
    self.writer? || self.is_moderator?
  end

  def is_moderator?
    self.moderator? || self.is_admin?
  end

  def is_admin?
    self.admin?
  end

end
