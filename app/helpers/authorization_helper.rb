module AuthorizationHelper

  class AuthorizationError < StandardError
    attr_accessor :query, :record, :policy
  end


  def entry_owner?(entry)
    (entry.user == current_user and entry.user)
  end

  def program_owner?(program)
    (program.user == current_user and program.user)
  end


  def authorize_user
    if not current_user.try(:is_user?)
      raise AuthorizationError
    end
  end

  def authorize_moderator
    if not current_user.try(:is_moderator?)
      raise AuthorizationError
    end
  end

  def authorize_admin
    if not current_user.try(:is_admin?)
      raise AuthorizationError
    end
  end

end