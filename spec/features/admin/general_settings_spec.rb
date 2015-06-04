require 'spec_helper'

describe 'General Settings', type: :feature do

  # login into admin page
  before do
    @admin = Spree.user_class.create(email: 'admin@admin.com', password: 'password', password_confirmation: 'password')
    @role = Spree::Role.create(name: 'admin')
    @role.users << @admin
    sign_in_admin! @admin
  end

  context 'user registration settings' do
    it 'should show the attribute sms permission', js: true do
      visit spree.edit_admin_general_settings_path

      expect(page).to have_text Spree.t(:user_registration_settings)
      expect(page).to have_selector '#sms_permission'
    end

    it 'should possible check/uncheck the sms permission', js: true do
      visit spree.edit_admin_general_settings_path

      find(:css, '#sms_permission').set false

      click_button 'Update'

      expect(Spree::Config.sms_permission).to be(false)
      expect(find_field('sms_permission')).not_to be_checked
    end
  end
end