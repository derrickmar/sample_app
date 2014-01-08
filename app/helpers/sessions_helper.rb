module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token # create new remember_token
    cookies.permanent[:remember_token] = remember_token #store
    #remember_token in cookie. We have this in order to retrieve the
    #token when the user moves to subsequent pages. Since HTTP is
    #stateless everything is loss and in order to know what the user
    #is we have to retrieve this token and again find the current user
    #with this token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user=(user)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    #find_by is only called once when @current_user is nil. Once it
    #has the value of the current_user it will just be the
    #value. Therefore, it only searches through the database once.
    # @current_user = @current_user ||  User.find_by(remember_token: remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user=(nil)
  end

  # stores location if get request in session cookie
  def store_location
    session[:return_to] = request.url if request.get?
  end

  # redirects user to session cookie and then deletes the remembered path
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end


  # Before filters
  #this redirects a user to signin_url if not signed in
  def signed_in_user
    unless signed_in?
      store_location
      flash[:notice] = "Please sign in."
      redirect_to signin_url
    end
  end

end
