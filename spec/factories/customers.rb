FactoryGirl.define do
  factory :customer, class: 'Magnetik::Customer' do
    stripe_customer_id "Test"
    owner_id 1
    owner_type 'User'
  end
end
