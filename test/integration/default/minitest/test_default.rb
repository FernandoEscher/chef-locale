require 'minitest/autorun'

describe 'chef-locale::default' do
  expected = {
      'LANG' => 'en_US.UTF-8',
      'LC_MESSAGES' => 'ru_RU.UTF-8',
      'LC_CTYPE' => 'en_US.UTF-8'
  }
  expected.each do |k, v|
    it "check locale #{k} set to #{v}" do
      actual = `cat /etc/default/locale | grep '#{k}='`.strip
      assert actual.match(/#{Regexp.escape(k)}=(|\")#{Regexp.escape(v)}(|\")/), "String '#{actual}' not match /#{Regexp.escape(k)}=(|\\\")#{Regexp.escape(v)}(|\\\")/"
    end
  end
end
