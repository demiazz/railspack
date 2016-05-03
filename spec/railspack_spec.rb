require 'spec_helper'

describe Railspack::VERSION do
  it 'equals 0.1.0' do
    Railspack::VERSION.must_equal '0.1.0'
  end
end
