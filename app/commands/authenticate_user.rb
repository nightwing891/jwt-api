class AuthenticateUser
  prepend SimpleCommand

  # Parameters are taken when the command is called
  def initialize(email, password)
    @email = email
    @password = password
  end

  # The result gets returned
  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private
  
    attr_accessor :email, :password

    # Uses the credentials to check if the user exists in the database
    def user
      user = User.find_by_email(email)

      # check if the user's password is correct
      # if everything is true, the user will be returned. 
      return user if user && user.authenticate(password)

      # If not, the method will return nil.
      errors.add :user_authentication, 'invalid credentials'
      nil
    end
end