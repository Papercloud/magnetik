# Magnetik

Rails engine for credit card management via Stripe.

## Installation

Add the gem into your project:

```
gem 'magnetik'
bundle install
```

Then run the installation:
```
rails g magnetik:install
```

## Usage

We first need a model that's going to act as our customer, let's say we have a User model:

```
rails g magnetik User
```

This will generate a migration to add the `stripe_customer_id` to your user model, and also generate a migration to create a table for credit cards. From here, add the `acts_as_magnetik_customer` method into your user model, which will add the required relationships:

```
class User < ActiveRecord::Base
  acts_as_magnetik_customer
end
```

Mount the engine in your `routes.rb` file:
```
Rails.application.routes.draw do
  mount Magnetik::Engine => '/'
end
```

This will add the following routes into your application:

| Route                       | Description                                               |
|-----------------------------|-----------------------------------------------------------|
| `GET /credit_cards`         | Get all of the credit cards for the current user          |
| `POST /credit_cards`        | Create a new credit card given a token                    |
| `PUT /credit_cards/:id`     | Update an existing credit card given a subset of fields   |
| `DELETE /credit_cards/:id`  | Delete an existing credit card, remotely and locally      |

#### Creating a card
```
POST { credit_card: { token: 'stripe_token' }}
```

#### Updating a card
```
PUT { credit_card: { exp_month: 11, exp_year: 2020, is_default: true }}
```

## Configuration

```
Magnetik.setup do |config|
  # Magnetik will call this within CreditCardsController to ensure the user is authenticated.
  config.authentication_method = :authenticate_user!

  # Magnetik will call this within CreditCardsController to return the current logged in user.
  config.current_user_method = :current_user
end

```

The default configuration integrates with [Devise](https://github.com/plataformatec/devise), but if you have other methods of authentication and retrieving the currently authenticated user, you can specify them here and the `CreditCardsController` will use those in the before filter.