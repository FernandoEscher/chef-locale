#
# Cookbook Name:: locale
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if platform?('ubuntu', 'debian')

  package 'locales' do
    action :install
  end

  node[:locale].values.uniq.each do |locale|
    execute "Install missing locale #{locale}" do
      not_if "locale -a | grep #{locale}"
      command "locale-gen \"#{locale}\""
      command "dpkg-reconfigure locales"
    end if locale.match(/[a-zA-Z]+_[a-zA-Z]+\.[a-zA-Z0-9-]+/)
  end

  execute 'Update locale' do
    lang_settings = node[:locale].to_a.map{|locale| "#{locale[0].upcase}=#{locale[1]}" unless locale[1].nil?}
    Chef::Log.debug("locale settings is #{lang_settings}")

    command_string = "update-locale --reset #{lang_settings.join(' ')}"
    Chef::Log.debug("locale command is #{command_string.inspect}")

    not_if_grep = lang_settings.map { |s| "-e '^#{s}$'" }.join(' ')
    not_if_command_string = "test $(grep #{not_if_grep} /etc/default/locale | uniq | wc -l) -eq #{lang_settings.count}"
    Chef::Log.debug("locale test command is #{not_if_command_string.inspect}")

    command command_string
    not_if  not_if_command_string
  end

end

if platform?('redhat', 'centos', 'fedora')

  execute 'Update locale' do
    command "locale -a | grep -qx #{node[:locale][:lang]} && sed -i 's|LANG=.*|LANG=#{node[:locale][:lang]}|' /etc/sysconfig/i18n"
    not_if "grep -qx LANG=#{node[:locale][:lang]} /etc/sysconfig/i18n"
  end

end

