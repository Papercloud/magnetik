require 'rails_helper'

describe 'setup initializer' do
  it 'sets an authentication method' do
    expect(Magnetik.authentication_method).to eq :authenticate_user!
  end

  it 'sets a current user method' do
    expect(Magnetik.current_user_method).to eq :current_user
  end

  it 'sets a maximum name length method' do
    expect(Magnetik.max_name_length).to eq 255
  end

  it 'sets a validation interval' do
    expect(Magnetik.validation_interval).to eq 3.months
  end
end
