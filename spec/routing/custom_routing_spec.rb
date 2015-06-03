require 'rails_helper'

describe 'default routes' do
  it 'GET /credit_cards routes to custom credit cards controller' do
    expect(get('/custom/credit_cards')).to route_to('custom_credit_cards#index')
  end

  it 'POST /credit_cards routes to custom credit cards controller' do
    expect(post('/custom/credit_cards')).to route_to('custom_credit_cards#create')
  end

  it 'PUT /credit_cards/:id routes to custom credit cards controller' do
    expect(put('/custom/credit_cards/id')).to route_to('custom_credit_cards#update', id: 'id')
  end

  it 'DELETE /credit_cards/:id routes to custom credit cards controller' do
    expect(delete('/custom/credit_cards/id')).to route_to('custom_credit_cards#destroy', id: 'id')
  end
end