require 'spec_helper'

describe 'Sign Up', type: :feature do
  context 'brazilian fields' do

    it 'should show common brazilian fields', js: true do
      # set sms permission
      Spree::Config.sms_permission = true

      visit spree.signup_path

      expect(page).to have_selector '#spree_user_account_type_personal'
      expect(page).to have_selector '#spree_user_account_type_business'
      expect(page).to have_selector '#spree_user_newsletter'
      expect(page).to have_selector '#spree_user_receive_sms'
    end

    context 'disable sms permission' do
      it 'should hide if the sms permission is false', js: true do
        Spree::Config.sms_permission = false

        visit spree.signup_path

        expect(page).not_to have_selector '#spree_user_receive_sms'

        # set default
        Spree::Config.sms_permission = true
      end
    end

    context 'choosing account type' do
      it 'should show only personal account fields', js: true do
        visit spree.signup_path

        find(:css, '#spree_user_account_type_personal').set true

        expect(page).to have_selector '#spree_user_cpf'
        expect(page).to have_selector '#spree_user_rg'
        expect(page).to have_selector '#spree_user_birth_date'
        expect(page).to have_selector '#spree_user_gender_f'
        expect(page).to have_selector '#spree_user_gender_m'

        expect(page).not_to have_selector '#spree_user_cnpj'
        expect(page).not_to have_selector '#spree_user_state_registry'
        expect(page).not_to have_selector '#spree_user_contact'
      end

      it 'should show only business account fields', js: true do
        visit spree.signup_path

        find(:css, '#spree_user_account_type_business').set true

        expect(page).to have_selector '#spree_user_cnpj'
        expect(page).to have_selector '#spree_user_state_registry'
        expect(page).to have_selector '#spree_user_contact'

        expect(page).not_to have_selector '#spree_user_cpf'
        expect(page).not_to have_selector '#spree_user_rg'
        expect(page).not_to have_selector '#spree_user_birth_date'
        expect(page).not_to have_selector '#spree_user_gender_f'
        expect(page).not_to have_selector '#spree_user_gender_m'
      end
    end

    context 'creating a new user' do
      it 'should create a new user', js: true do
        # gera um cnpj valido
        cnpj = CNPJ.generate true

        visit spree.signup_path

        find(:css, '#spree_user_account_type_business').set true

        fill_in 'Corporate Name', with: 'some name'
        fill_in 'Email', with: 'email@person.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password Confirmation', with: 'password'
        # preenche o campo cnpj por js
        # por causa da mascara
        page.execute_script '$("#spree_user_cnpj").val("' + cnpj + '");'
        fill_in 'State registry', with: '123'
        fill_in 'Contact', with: 'contact'
        click_button 'Create'

        new_user = Spree::User.last

        expect(new_user.business_account?).to be(true)
        expect(new_user.cnpj).to eq(cnpj)
        expect(new_user.state_registry).to eq('123')
        expect(new_user.contact).to eq('contact')
      end
    end
  end
end