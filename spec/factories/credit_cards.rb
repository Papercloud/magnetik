FactoryGirl.define do
  factory :credit_card, class: 'Magnetik::CreditCard' do
    stripe_card_id "Test"
    last_4_digits "4242"
    exp_month 10
    exp_year 2018
    brand "visa"

    customer
  end
end
