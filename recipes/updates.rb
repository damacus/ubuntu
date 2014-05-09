#
# Cookbook Name:: ubuntu
# Recipe:: updates 
#
# Copyright 2013-2014, Opscode, Inc.
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
## As per this guide:
# https://help.ubuntu.com/community/AutomaticSecurityUpdates
# https://help.ubuntu.com/12.04/serverguide/automatic-updates.html

## Make sure the unattended-upgrades package is installed
apt_package 'unattended-upgrades'

## setup and create the unattended-upgrades 
# e.g. APT::Periodic::Update-Package-Lists "1";
# execute 'sudo dpkg-reconfigure -plow unattended-upgrades '

## Assume the user wants unattended upgrades
template '/etc/apt/apt.conf.d/10periodic' do
  mode '00664'
  variables(
    :UpdatePackageLists => node['ubuntu']['updates']['updatepackagelists'],
    :DownloadUpgradablePackages => node['ubuntu']['updates']['downloadupgradablepackaes'],
    :AutoCleanInterval => node['ubuntu']['updates']['autocleaninterval'],
    :UnattendedUpgrade => node['ubuntu']['updates']['unattendedupgrade']
  )
end

## Put the config file in place so we can send out emails on failures
# and other niceness
template '/etc/apt/apt.conf.d/50unattended-upgrades' do
  mode 00644
  variables(
    :origins => node['ubuntu']['updates']['origins'],
    :blackList => node['ubuntu']['updates']['blacklist'],
    :mail_to => node['ubuntu']['updates']['notify_email'],
    :mail_on_error => node['ubuntu']['updates']['mail_on_error']
  )
  notifies :run, 'execute[apt-get update]', :immediately
  source '50unattended-upgrades'
end

## cron and aptitude
#
template '/etc/cron.weekly/apt-security-updates' do
  mode 00644
  variables(
  :stuff => node['ubuntu'][''],
  :somethingelse => node['ubuntu']['']
  )
  notifies :run, 'execute[apt-get update]', :immediately
  source ''
end
