Magnetik.setup do |config|
  # Magnetik will call this within CreditCardsController to ensure the user is authenticated.
  config.authentication_method = :authenticate_user!

  # Magnetik will call this within CreditCardsController to return the current logged in user.
  config.current_user_method = :current_user

  # Maximum length of card names:
  config.max_name_length = 255

  # Time between card validations via pre-auth:
  config.validation_interval = 3.months
end
