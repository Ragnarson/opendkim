#
# Cookbook Name:: opendkim
# Recipe:: default
#
# Copyright 2013, Shelly Cloud Sp. z o. o.
#
# All rights reserved - Do Not Redistribute
#

%w(opendkim opendkim-tools).each do |pkg|
  package pkg do
    action :install
  end
end

service "opendkim" do
  supports :restart => true, :reload => true
  action :enable
end

directory "#{node[:opendkim][:config_dir]}/keys" do
  recursive true
  owner node[:opendkim][:user]
  group node[:opendkim][:group]
  mode "0700"
end

node[:opendkim][:domains].each_pair do |domain, keys|
  directory "#{node[:opendkim][:config_dir]}/keys/#{domain}" do
    owner node[:opendkim][:user]
    group node[:opendkim][:group]
    mode "0700"
  end

  %w(txt private).each do |key_type|
    file "#{node[:opendkim][:config_dir]}/keys/#{domain}/default.#{key_type}" do
      content decode(keys[key_type])
      owner node[:opendkim][:user]
      group node[:opendkim][:group]
      mode "0700"
      notifies :restart, "service[opendkim]"
    end
  end
end

%w(KeyTable SigningTable TrustedHosts).each do |conf_file|
  template "#{node[:opendkim][:config_dir]}/#{conf_file}" do
    owner node[:opendkim][:user]
    group node[:opendkim][:group]
    mode "0700"
    notifies :restart, "service[opendkim]"
  end
end

template node[:opendkim][:config_file] do
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[opendkim]"
end

template node[:opendkim][:service_config_file] do
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[opendkim]"
end
