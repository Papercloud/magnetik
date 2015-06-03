Rails.application.routes.draw do
  mount_magnetik

  scope 'custom' do
    mount_magnetik do
      controllers credit_cards: 'custom_credit_cards'
    end
  end
end
