require 'spec_helper'

describe 'Account user', type: :feature do
  context 'show brazilian fields' do

    # login into user page
    before do
      @user = Spree.user_class.create(email: 'user@test.com',
                                      password: 'password',
                                      password_confirmation: 'password',
                                      name: 'users name',
                                      cpf: CPF.generate(true),
                                      rg: '123',
                                      birth_date: Date.today,
                                      gender: 'f')
      @role = Spree::Role.create(name: 'user')
      @role.users << @user
      sign_in_as! @user
    end

    it 'should show the brazilian fields in users#show', js: true do
      visit spree.account_path

      expect(page).to have_text @user.name
      expect(page).to have_text @user.cpf
      expect(page).to have_text @user.rg
      expect(page).to have_text @user.birth_date.strftime(I18n.t('date.formats.default'))
      expect(page).to have_text 'Female'
    end
  end
end