Magnetik.setup do |config|
  # Magnetik will call this within CreditCardsController to ensure the user is authenticated.
  config.authentication_method = :authenticate_user!

  # Magnetik will call this within CreditCardsController to return the current logged in user.
  config.current_user_method = :current_user
end
