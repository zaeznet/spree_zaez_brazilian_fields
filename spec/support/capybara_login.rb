def sign_in_admin!(user)
  visit '/admin'
  fill_in 'Email', :with => user.email
  fill_in 'Password', :with => user.password
  click_button 'Login'
end

def sign_in_as!(user)
  visit '/login'
  fill_in 'Email', :with => user.email
  fill_in 'Password', :with => user.password
  click_button 'Login'
end