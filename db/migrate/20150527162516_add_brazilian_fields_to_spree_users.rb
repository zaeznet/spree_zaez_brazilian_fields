class AddBrazilianFieldsToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :name, :string
    add_column :spree_users, :cpf, :string
    add_column :spree_users, :cnpj, :string
    add_column :spree_users, :account_type, :string, default: 'personal'
    add_column :spree_users, :birth_date, :date
    add_column :spree_users, :rg, :string
    add_column :spree_users, :state_registry, :string
    add_column :spree_users, :newsletter, :integer
    add_column :spree_users, :receive_sms, :integer
    add_column :spree_users, :contact, :string
    add_column :spree_users, :gender, :string
  end
end
