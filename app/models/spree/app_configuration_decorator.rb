Spree::AppConfiguration.class_eval do

  # adiciona  opcao de exibira o pedido de permissao para o envio de sms ou nao
  preference :sms_permission, :boolean, default: true

end