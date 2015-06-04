require 'spec_helper'

describe Spree::AppConfiguration, type: :model do

  it 'attribute sms permission should exist' do
    expect(Spree::Config.has_preference?(:sms_permission)).to be true
  end

end