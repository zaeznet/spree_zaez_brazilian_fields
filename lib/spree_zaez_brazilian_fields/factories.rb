FactoryGirl.define do

  factory :personal_account, class: Spree.user_class do
    email { generate(:random_email) }
    login { email }
    password 'secret'
    password_confirmation { password }
    account_type 'personal'
    cpf CPF.generate(true)
    rg '123'
    birth_date Date.today
    gender 'f'
  end

  factory :business_account, class: Spree.user_class do
    email { generate(:random_email) }
    login { email }
    password 'secret'
    password_confirmation { password }
    account_type 'business'
    cnpj CNPJ.generate(true)
    state_registry '123'
    contact 'some name'
  end
end
