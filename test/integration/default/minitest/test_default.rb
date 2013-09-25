require 'minitest/autorun'

describe 'chef-locale::default' do
  it 'check locale LANG set to en_US.UTF-8' do
    actual = `locale | grep 'LANG='`.strip
    assert_equal 'LANG=en_US.UTF-8', actual
  end
end
