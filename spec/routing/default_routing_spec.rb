require 'rails_helper'

describe 'default routes' do
  it 'GET /credit_cards routes to credit cards controller' do
    expect(get('/credit_cards')).to route_to('magnetik/credit_cards#index')
  end

  it 'POST /credit_cards routes to credit cards controller' do
    expect(post('/credit_cards')).to route_to('magnetik/credit_cards#create')
  end

  it 'PUT /credit_cards/:id routes to credit cards controller' do
    expect(put('/credit_cards/id')).to route_to('magnetik/credit_cards#update', id: 'id')
  end

  it 'DELETE /credit_cards/:id routes to credit cards controller' do
    expect(delete('/credit_cards/id')).to route_to('magnetik/credit_cards#destroy', id: 'id')
  end
end