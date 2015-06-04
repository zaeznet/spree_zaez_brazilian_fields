#= require_self
class window.UserAccountType
  afterConstructor: ->

  beforeConstructor: ->

  constructor: (defaultExecution = true) ->
    do @beforeConstructor
    do @defaultExecution if defaultExecution
    do @afterConstructor

  defaultExecution: ->
    # verifica qual esta checado
    if $('#user_account_type_business').is(':checked')
      do @setBusinessType
    else
      do @setPersonalType
    # insere as mascaras dos campos cpf e cnpj
    $('#user_cpf').inputmask("999.999.999-99")
    $('#user_cnpj').inputmask("99.999.999/9999-99")
    # listeners
    $('#user_account_type_business').click => do @setBusinessType
    $('#user_account_type_personal').click => do @setPersonalType
    # gera as validacoes do formulario
    # de acordo com o tipo de pessoa (fisica ou juridica) escolhida
    $("##{@formId()}").validate
      errorClass: 'error-form'
      rules:
        'user[name]':
          required:true
        'user[cpf]':
          required:'#user_account_type_personal:checked'
        'user[rg]':
          required:'#user_account_type_personal:checked'
        'user[birth_date]':
          required:'#user_account_type_personal:checked'
        'user[gender]':
          required:'#user_account_type_personal:checked'
        'user[cnpj]':
          required:'#user_account_type_business:checked'
        'user[state_registry]':
          required:'#user_account_type_business:checked'
        'user[contact]':
          required:'#user_account_type_business:checked'

  # retorna o id do formulario
  # se for criacao, sera 'new_spree_user'
  # se for edicao, sera 'edit_spree_user'
  formId: ->
    # se existir o formulario de edicao
    if $('#edit_user').length != 0
      'edit_user'
    else
      'new_user'

  # modificado o formulario para a insercao/edicao
  # de uma pessoa juridica
  # exibindo seus campos (cnpj, ie e contato)
  # e limpando os campos de uma pessoa fisica
  setBusinessType: ->
    $('#business_account').show()
    $('#personal_account').hide()
    # limpa os campos da pessoa fisica
    $('#user_cpf, #user_rg, #user_birth_date').val('')
    # nao checar o genero
    # modifica o label do nome
    $("[for='user_name']").text(Spree.translations.user_name_business)

  # modifica o formulario para a insercao/edicao
  # de uma pessoa fisica
  # exibindo seus campos (cpf, rg, data de nascimento e genero)
  # e limpando os campos de uma pessoa juridica
  setPersonalType: ->
    $('#business_account').hide()
    $('#personal_account').show()
    # limpa os campos da pessoa juridica
    $('#user_cnpj, #user_state_registry, #user_contact').val('')
    # modifica o label do nome
    $("[for='user_name']").text(Spree.translations.user_name_personal)
