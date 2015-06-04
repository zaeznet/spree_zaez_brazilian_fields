Spree::Api::ApiHelpers.class_eval do
  class_variable_set(:@@user_attributes, class_variable_get(:@@user_attributes).push(:name, :account_type, :newsletter, :receive_sms, :cpf, :rg,
                                                                                     :birth_date, :gender, :cnpj, :state_registry, :contact))
end