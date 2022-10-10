# EncodedToken: Example

## Premise

We want to add a Password Rollback feature.

When a user's password is changed, an email is sent to notify the user of the change. 
The email also has a link for the user to use if they did not request the change.
Clicking that link will allow our user to sign-in with the old password and set
a new password.

1. We already have a User model defined with `:name` and `:email` attributes.
2. The rollback link will be valid for one hour.
3. Our application framework is Ruby on Rails
4. We've set our environment variable: `ENCODED_TOKEN_SEED="12345"`
5. Our link route is: `get '/password_rollbacks/:token', to: 'password_rollbacks#show'`.
6. Our reset route is: `patch '/password_rollbacks/:token', to: 'password_rollbacks#update'`
7. To improve security we don't want to use our user's id in the token.
8. To conserve memory usage we don't want the token and expiry time within our User model. 

_Note: We won't cover every line of code, only those where EncodedToken are relevant._


---

### Create the empty request model
- create a new **PasswordRollbackRequest** model to hold the token details

```ruby
rails g model PasswordRollbackRequest user_id:integer token:string
rails db:migrate
```


---

### Edit the request model
  - automatically generate an encoded-token on creation
  - add a `:valid?` method
  - set an activation duration of 1 hour

```ruby
class PasswordRollbackRequest < ApplicationRecord
  
  #  Constants
  # ============================================================================
  #
  MINUTES_ACTIVE_FOR = 60


  #  Callbacks
  # ============================================================================
  #
  after_commit :generate_token!, on: :create


  #  Associations
  # ============================================================================
  #
  belongs_to :user


  #  Public Methods
  # ============================================================================
  #

  # Check the test_token is correct and the record is still active.
  #
  # test_token - a String of alphanumeric characters
  #
  # Returns - TRUE if all checks pass
  #
  def valid?(test_token)
    return false unless self.token == test_token
    Time.now <= (created_at + MINUTES_ACTIVE_FOR.minutes)
  end


  #  Private Methods
  # ============================================================================
  #
  private

  # Create and save a new token unless it is already present.
  #
  # Returns - String token
  #
  def generate_token!
    return token if token.present?

    update token: EncodedToken.encode(self.id)
    return token
  end
end
```


---

### Add the PasswordRollback controller
- the `:show` view is a form asking for the user's email, original password 
  & new password
- the `expired_link` view is a message saying this link has expired. We display 
  this for **every** invalid token.

```ruby
class PasswordRollbacksController < ApplicationController
  
  #  Public Methods
  # ============================================================================
  #
  
  # Render the password change form if it's a valid token
  #
  def show
    render(:expired_link) and return unless valid_token?
  end


  # Update the new password if the form & token are valid
  #
  def update
    render(:expired_link) and return unless valid_token?

    if valid_form?
      # update the new password
      @user.update!(password: @new_password, 
                    password_confirmation: @new_password_confirmation)
      
      # destroy the rollback request, so it cannot be used again
      @rollback_request.destroy!

      # redirect to the user's home page
      redirect_to user_home_path(@user)
    else
      # re-render and highlight errors.
    end
  end


  #  Private Methods
  # ============================================================================
  #
  private

  # Returns TRUE if it's a geniune token and still active
  #
  def valid_token?
    rollback_id = EncodedToken.decode(params[:token])
    return false if rollback_id.blank?

    @rollback_request = PasswordRollbackRequest.find_by(id: rollback_id)
    return false unless @rollback_request.present?
    return false unless @rollback_request.valid?

    return true
  end


  # Check if the supplied form is valid
  #
  # Returns true if valid, else false
  #
  def valid_form?
    @user                       = @rollback_request.user
    @email                      = params[:email]
    @previous_password          = params[:previous_password]
    @new_password               = params[:new_password]
    @new_password_confirmation  = params[:new_password_confirmation]

    return false unless @email == @user.email
    return false unless @user.valid_previous_password?(@previous_password)
    return false unless @new_password == @new_password_confirmation
    return false unless is_valid_password?(@new_password)

    return true
  end

end
```


---

### Closing thoughts

The above code is very simplistic and you would clearly add a lot more 
security and refinement before implementing - but it gives a reasonable 
example of how easy it is to integrate **EncodedToken**.

Adding a daily rake task to delete expired `PasswordRollbackRequest` 
records will keep the table small and efficient.

Although adding new models and controllers to manage the rollback request
may seem like a lot of extra effort, it is much more secure and memory
efficient than adding both `:token` and `:expires_at` to the `User` 
model and adding yet more methods to the `UserController`.

While this example uses the Ruby on Rails framework, **EncodedToken**
is coded in pure Ruby and is completely framework agnostic.







