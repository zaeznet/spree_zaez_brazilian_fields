#= require_self
class window.UserAccountType

  # prefixo dos campos
  # variavel utilizada para poder reutilizar a classe tanto na criacao qanto na edicao
  # pois no formulario de criacao
  # os campos recebem o prefixo 'spree_' (exe. 'spree_user_cpf')
  # ja no formulario de edicao nao
  @prefix = 'spree_'
  # traducoes utilizadas na classe
  @translations = {}

  afterConstructor: ->

  beforeConstructor: ->

  constructor: (translations = {}, prefix = 'spree_', defaultExecution = true) ->
    @translations = translations
    @prefix = prefix
    do @beforeConstructor
    do @defaultExecution if defaultExecution
    do @afterConstructor

  defaultExecution: ->
    if @isEdit()
      if $("##{@prefix}user_account_type_business").is(':checked')
        do @setBusinessType
      else
        do @setPersonalType
    else
      do @setPersonalType
    # insere as mascaras nos campos cpf e cnpj
    $("##{@prefix}user_cpf").inputmask("999.999.999-99")
    $("##{@prefix}user_cnpj").inputmask("99.999.999/9999-99")
    # listeners
    $("##{@prefix}user_account_type_business").click => do @setBusinessType
    $("##{@prefix}user_account_type_personal").click => do @setPersonalType
    # gera as validacoes do formulario
    # de acordo com o tipo de pessoa (fisica ou juridica) escolhida
    $("##{@formId()}").validate
      errorClass: 'error-form'
      rules:
        "#{@prefix}user[name]":
          required:true
        "#{@prefix}user[cpf]":
          required:"##{@prefix}user_account_type_personal:checked"
        "#{@prefix}user[rg]":
          required:"##{@prefix}user_account_type_personal:checked"
        "#{@prefix}user[birth_date]":
          required:"##{@prefix}user_account_type_personal:checked"
        "#{@prefix}user[gender]":
          required:"##{@prefix}user_account_type_personal:checked"
        "#{@prefix}user[cnpj]":
          required:"##{@prefix}user_account_type_business:checked"
        "#{@prefix}user[state_registry]":
          required:"##{@prefix}user_account_type_business:checked"
        "#{@prefix}user[contact]":
          required:"##{@prefix}user_account_type_business:checked"

  # retorna o id do formulario
  # se for criacao, sera 'new_spree_user'
  # se for edicao, sera 'edit_spree_user'
  formId: ->
    if @isEdit()
      'edit_spree_user'
    else
      'new_spree_user'

  # verifica se o formulario e de edicao
  # verificando a variavel prefix passada na inicializacao da classe
  isEdit: ->
    if @prefix == ''
      true
    else
      false

  # modificado o formulario para a insercao/edicao
  # de uma pessoa juridica
  # exibindo seus campos (cnpj, ie e contato)
  # e limpando os campos de uma pessoa fisica
  setBusinessType: ->
    $('#business_account').show()
    $('#personal_account').hide()
    # limpa os campos da pessoa fisica
    $("##{@prefix}user_cpf, ##{@prefix}user_rg, ##{@prefix}user_birth_date").val('')
    # limpa o genero
    $('#spree_user_gender_f').prop 'checked', false
    $('#spree_user_gender_m').prop 'checked', false
    # modifica o placeholder do campo nome
    $("##{@prefix}user_name").attr 'placeholder', @translations.user_name_business

  # modifica o formulario para a insercao/edicao
  # de uma pessoa fisica
  # exibindo seus campos (cpf, rg, data de nascimento e genero)
  # e limpando os campos de uma pessoa juridica
  setPersonalType: ->
    $('#business_account').hide()
    $('#personal_account').show()
    # limpa os campos da pessoa juridica
    $("##{@prefix}user_cnpj, ##{@prefix}user_state_registry, ##{@prefix}user_contact").val('')
    # modifica o placeholder do campo nome
    $("##{@prefix}user_name").attr 'placeholder', @translations.user_name_personal