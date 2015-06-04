Spree::User.class_eval do

  validates_inclusion_of  :account_type, :in => %w(personal business)
  validates_inclusion_of  :gender, :in => %w(f m), allow_blank: true, allow_nil: true
  validates_uniqueness_of :cpf, :cnpj, allow_blank: true, allow_nil: true

  validate :validate_cpf, :validate_cnpj

  # Sobrescreve o metodo para inserir
  # o campo document (que retorna o CPF ou CNPJ, dependendo do tipo de usuario)
  #
  # @author Isabella Santos
  #
  # @return [Hash]
  #
  def attributes
    fields = super
    fields['document'] = document
    fields
  end

  # Sobrescreve o metodo para inserir
  # o campo document (que retorna o CPF ou CNPJ, dependendo do tipo de usuario)
  #
  # @author Isabella Santos
  #
  # @return [Array]
  #
  def attribute_names
    fields = super
    fields << 'document'
    fields
  end

  # Retorna verdadeiro se for uma pessoa juridica (business)
  #
  # @author Isabella Santos
  #
  # @return [Boolean]
  #
  def business_account?
    true if account_type == 'business'
  end

  # Retorna o documento de identidade do usuario
  #
  # @author Isabella Santos
  #
  # @return [String]
  #
  def document
    return cpf if personal_account?
    cnpj
  end

  # Retorna verdadeiro se for uma pessoa fisica (personal)
  #
  # @author Isabella Santos
  #
  # @return [Boolean]
  #
  def personal_account?
    true if account_type == 'personal'
  end

  private

  # Verifica se o CPF, se passado, e valido
  #
  # @author Isabella Santos
  #
  def validate_cpf
    if self.cpf.present?
      errors.add(:cpf, :invalid) unless CPF.valid?(self.cpf)
    end
  end

  # Verifica se o CNPJ, se passado, e valido
  #
  # @author Isabella Santos
  #
  def validate_cnpj
    if self.cnpj.present?
      errors.add(:cnpj, :invalid) unless CNPJ.valid?(self.cnpj)
    end
  end
end