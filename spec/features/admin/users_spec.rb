require 'spec_helper'

describe 'Users', type: :feature do

  # login into admin page
  before do
    @admin = Spree.user_class.create(email: 'admin@admin.com', password: 'password', password_confirmation: 'password')
    @role = Spree::Role.create(name: 'admin')
    @role.users << @admin
    sign_in_admin! @admin
  end

  context 'adding brazilian fields to users form' do

    it 'should show common brazilian fields in users form', js: true do
      Spree::Config.sms_permission = true

      visit spree.new_admin_user_path

      expect(page).to have_selector '#user_account_type_personal'
      expect(page).to have_selector '#user_account_type_business'
      expect(page).to have_selector '#user_newsletter'
      expect(page).to have_selector '#user_receive_sms'
    end

    context 'disable sms permission' do
      it 'should hide if the sms permission is false' do
        Spree::Config.sms_permission = false

        visit spree.new_admin_user_path

        expect(page).not_to have_selector '#user_receive_sms'

        # set default
        Spree::Config.sms_permission = true
      end
    end

    context 'choosing account type' do
      it 'should show only personal account fields', js: true do
        visit spree.new_admin_user_path

        find(:css, '#user_account_type_personal').set true

        expect(page).to have_text Spree.t(:name).upcase
        expect(page).to have_selector '#user_cpf'
        expect(page).to have_selector '#user_rg'
        expect(page).to have_selector '#user_birth_date'
        expect(page).to have_selector '#user_gender_f'
        expect(page).to have_selector '#user_gender_m'

        expect(page).not_to have_selector '#user_cnpj'
        expect(page).not_to have_selector '#user_state_registry'
        expect(page).not_to have_selector '#user_contact'
      end

      it 'should show only business account fields', js: true do
        visit spree.new_admin_user_path

        find(:css, '#user_account_type_business').set true

        expect(page).to have_text Spree.t(:corporate_name).upcase
        expect(page).to have_selector '#user_cnpj'
        expect(page).to have_selector '#user_state_registry'
        expect(page).to have_selector '#user_contact'

        expect(page).not_to have_selector '#user_cpf'
        expect(page).not_to have_selector '#user_rg'
        expect(page).not_to have_selector '#user_birth_date'
        expect(page).not_to have_selector '#user_gender_f'
        expect(page).not_to have_selector '#user_gender_m'
      end
    end

    context 'saving brazilian fields' do
      context 'personal account' do
        it 'can edit the personal account', js: true do
          # gera um cnpj valido
          cpf = CPF.generate true

          Spree::Config.sms_permission = true

          visit spree.edit_admin_user_path @admin.id

          find(:css, '#user_account_type_personal').set true

          fill_in 'user_name', with: 'users name'
          find(:css, '#user_newsletter').set true
          find(:css, '#user_receive_sms').set true
          # preenche o campo cpf por js
          # por causa da mascara
          page.execute_script "$('#user_cpf').val('#{cpf}');"
          fill_in 'user_rg', with: '123'
          fill_in 'user_birth_date', with: '1990/01/01'
          find(:css, '#user_gender_m').set true
          click_button 'Update'

          # verificando o objeto
          @admin.reload
          expect(@admin.name).to eq('users name')
          expect(@admin.cpf).to eq cpf
          expect(@admin.rg).to eq '123'
          expect(@admin.birth_date).to eq Date.parse('1990/01/01')
          expect(@admin.gender).to eq 'm'
          expect(@admin.receive_sms).to eq 1
          expect(@admin.newsletter).to eq 1
          # verificando o formulario
          expect(find_field('user_name').value).to eq 'users name'
          expect(find_field('user_cpf').value).to eq cpf
          expect(find_field('user_rg').value).to eq '123'
          expect(find_field('user_birth_date').value).to eq '1990/01/01'
          expect(find_field('user_gender_m')).to be_checked
          expect(find_field('user_newsletter')).to be_checked
          expect(find_field('user_receive_sms')).to be_checked
        end
      end

      context 'business account' do
        it 'can edit the business account', js: true do
          # gera um cnpj valido
          cnpj = CNPJ.generate true

          visit spree.edit_admin_user_path @admin.id

          find(:css, '#user_account_type_business').set true

          fill_in 'user_name', with: 'users name'
          # preenche o campo cnpj por js
          # por causa da mascara
          page.execute_script "$('#user_cnpj').val('#{cnpj}');"
          fill_in 'user_state_registry', with: '123'
          fill_in 'user_contact', with: 'company contact'
          click_button 'Update'

          # verificando o objeto
          @admin.reload
          expect(@admin.name).to eq 'users name'
          expect(@admin.cnpj).to eq cnpj
          expect(@admin.state_registry).to eq '123'
          expect(@admin.contact).to eq 'company contact'
          # verificando o formulario
          expect(find_field('user_name').value).to eq 'users name'
          expect(find_field('user_cnpj').value).to eq cnpj
          expect(find_field('user_state_registry').value).to eq '123'
          expect(find_field('user_contact').value).to eq 'company contact'
        end
      end
    end
  end
end