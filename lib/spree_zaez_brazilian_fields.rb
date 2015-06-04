require 'spree_core'
require 'spree_zaez_brazilian_fields/engine'
require 'cpf_cnpj'

# Permitted attributes for users
Spree::PermittedAttributes.user_attributes.push :name, :account_type, :newsletter, :receive_sms, :cpf, :rg,
                                                :birth_date, :gender, :cnpj, :state_registry, :contact
