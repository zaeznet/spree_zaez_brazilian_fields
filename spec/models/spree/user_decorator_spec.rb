require 'spec_helper'

describe Spree::User do

  context 'validate brazilian fields' do

    let(:user) { FactoryGirl.build(:user) }

    it 'should be invalid if the account type has a invalid value' do
      # values for account type:
      # personal or business
      user.account_type = ''
      expect(user.valid?).to be(false)
    end

    it 'should be invalid if cpf is invalid' do
      user.cpf = '1234'
      expect(user.valid?).to be false
    end

    it 'should be invalid if the user has the same CPF of other user' do
      # gera um cnpj valido
      cpf = CPF.generate true

      user.cpf = cpf
      user.save

      new_user = FactoryGirl.build(:user)
      new_user.cpf = cpf

      expect(new_user.valid?).to be(false)
    end

    it 'should be invalid if cnpj is invalid' do
      user.cnpj = '1234'
      expect(user.valid?).to be false
    end

    it 'should be invalid if the user has the same CNPJ of other user' do
      # gera um cnpj valido
      cnpj = CNPJ.generate true

      user.cnpj = cnpj
      user.save

      new_user = FactoryGirl.build(:user)
      new_user.cnpj = cnpj

      expect(new_user.valid?).to be(false)
    end

    context 'personal or business account' do
      let(:user) { Spree::User.new }

      it 'the default account type should be personal' do
        expect(user.account_type).to eq('personal')
      end

      it 'verify if the user has a personal account' do
        expect(user.personal_account?).to be(true)
      end

      it 'verify if the user has a business account' do
        user.account_type = 'business'
        expect(user.business_account?).to be(true)
      end
    end

    context 'document' do
      let(:user) { Spree::User.new }

      it 'should return the CPF in method document if personal account' do
        user.cpf = CPF.generate true
        expect(user.document).to eq user.cpf
      end

      it 'should return the CNPJ in method document if business account' do
        user.account_type = 'business'
        user.cnpj = CNPJ.generate true
        expect(user.document).to eq user.cnpj
      end
    end

    context 'overriding attributes methods' do
      let(:user) { Spree::User.new }

      it 'should return document in the list of attribute names' do
        expect(user.attribute_names.include?('document')).to be true
      end

      it 'should return the document in method attributes' do
        user.cpf = CPF.generate true
        expect(user.attributes['document']).to eq user.document
      end
    end
  end
end