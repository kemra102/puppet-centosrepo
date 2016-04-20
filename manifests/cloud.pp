# Class: centosrepo::cloud
# ===========================
#
# Authors
# -------
#
# Danny Roberts <danny@thefallenphoenix.net>
#
# Copyright
# ---------
#
# Copyright 2016 Danny Roberts, unless otherwise noted.
#
class centosrepo::cloud (
  Boolean $manage_repo_dir                   = $::centosrepo::manage_repo_dir,

  Boolean $openstackkilo_enabled             = false,
  String  $openstackkilo_descr               = 'CentOS-$releasever - OpenStack Kilo',
  String  $openstackkilo_baseurl             = 'http://mirror.centos.org/centos/$releasever/cloud/$basearch/openstack-kilo/',
  Boolean $openstackkilo_gpgcheck            = true,
  String  $openstackkilo_gpgkey              = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud',

  Boolean $openstackkilotest_enabled         = false,
  String  $openstackkilotest_descr           = 'CentOS-$releasever - OpenStack Kilo Testing',
  String  $openstackkilotest_baseurl         = 'http://buildlogs.centos.org/centos/$releasever/cloud/$basearch/openstack-kilo/',
  Boolean $openstackkilotest_gpgcheck        = true,
  String  $openstackkilotest_gpgkey          = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud',

  Boolean $openstackliberty_enabled          = false,
  String  $openstackliberty_descr            = 'CentOS-$releasever - OpenStack Liberty',
  String  $openstackliberty_baseurl          = 'http://mirror.centos.org/centos/$releasever/cloud/$basearch/openstack-liberty/',
  Boolean $openstackliberty_gpgcheck         = true,
  String  $openstackliberty_gpgkey           = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud',

  Boolean $openstacklibertytest_enabled      = false,
  String  $openstacklibertytest_descr        = 'CentOS-$releasever - OpenStack Liberty Testing',
  String  $openstacklibertytest_baseurl      = 'http://buildlogs.centos.org/centos/$releasever/cloud/$basearch/openstack-liberty/',
  Boolean $openstacklibertytest_gpgcheck     = true,
  String  $openstacklibertytest_gpgkey       = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud',

  Boolean $openstackmitaka_enabled           = false,
  String  $openstackmitaka_descr             = 'CentOS-$releasever - OpenStack Mitaka',
  String  $openstackmitaka_baseurl           = 'http://mirror.centos.org/centos/$releasever/cloud/$basearch/openstack-mitaka/',
  Boolean $openstackmitaka_gpgcheck          = true,
  String  $openstackmitaka_gpgkey            = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud',

  Boolean $openstackmitakatest_enabled       = false,
  String  $openstackmitakatest_descr         = 'CentOS-$releasever - OpenStack Mitaka Testing',
  String  $openstackmitakatest_baseurl       = 'http://buildlogs.centos.org/centos/$releasever/cloud/$basearch/openstack-mitaka/',
  Boolean $openstackmitakatest_gpgcheck      = true,
  String  $openstackmitakatest_gpgkey        = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud',

  Boolean $openstackmitakadebuginfo_enabled  = false,
  String  $openstackmitakadebuginfo_descr    = 'CentOS-$releasever - OpenStack Mitaka DebugInfo',
  String  $openstackmitakadebuginfo_baseurl  = 'http://debuginfo.centos.org/centos/7/cloud/$basearch/',
  Boolean $openstackmitakadebuginfo_gpgcheck = true,
  String  $openstackmitakadebuginfo_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud',

  Boolean $openstackmitakasource_enabled     = false,
  String  $openstackmitakasource_descr       = 'CentOS-$releasever - OpenStack Mitaka Source',
  String  $openstackmitakasource_baseurl     = 'http://vault.centos.org/centos/7/cloud/Source/openstack-mitaka/',
  Boolean $openstackmitakasource_gpgcheck    = true,
  String  $openstackmitakasource_gpgkey      = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Cloud'

) {

  if $manage_repo_dir {
    if ! defined(Resources['yumrepo']) {
      resources { 'yumrepo': purge => true }
    }
  }

  # Ensure the keys are imported first
  Centosrepo::Rpm_gpg_key <| |> -> Yumrepo <| |>

  $gpg_keys = ['RPM-GPG-KEY-CentOS-SIG-Cloud']
  $gpg_keys.each |$key| {
    file { "/etc/pki/rpm-gpg/${key}":
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/centosrepo/${key}"
    }
    centosrepo::rpm_gpg_key { $key:
      path => "/etc/pki/rpm-gpg/${key}"
    }
  }

  if $::operatingsystemmajrelease == '7' {
    yumrepo { 'centos-openstack-kilo':
      enabled  => $openstackkilo_enabled,
      descr    => $openstackkilo_descr,
      baseurl  => $openstackkilo_baseurl,
      gpgcheck => $openstackkilo_gpgcheck,
      gpgkey   => $openstackkilo_gpgkey
    }

    yumrepo { 'centos-openstack-kilo-test':
      enabled  => $openstackkilotest_enabled,
      descr    => $openstackkilotest_descr,
      baseurl  => $openstackkilotest_baseurl,
      gpgcheck => $openstackkilotest_gpgcheck,
      gpgkey   => $openstackkilotest_gpgkey
    }

    yumrepo { 'centos-openstack-liberty':
      enabled  => $openstackliberty_enabled,
      descr    => $openstackliberty_descr,
      baseurl  => $openstackliberty_baseurl,
      gpgcheck => $openstackliberty_gpgcheck,
      gpgkey   => $openstackliberty_gpgkey
    }

    yumrepo { 'centos-openstack-liberty-test':
      enabled  => $openstacklibertytest_enabled,
      descr    => $openstacklibertytest_descr,
      baseurl  => $openstacklibertytest_baseurl,
      gpgcheck => $openstacklibertytest_gpgcheck,
      gpgkey   => $openstacklibertytest_gpgkey
    }

    yumrepo { 'centos-openstack-mitaka':
      enabled  => $openstackmitaka_enabled,
      descr    => $openstackmitaka_descr,
      baseurl  => $openstackmitaka_baseurl,
      gpgcheck => $openstackmitaka_gpgcheck,
      gpgkey   => $openstackmitaka_gpgkey
    }

    yumrepo { 'centos-openstack-mitaka-test':
      enabled  => $openstackmitakatest_enabled,
      descr    => $openstackmitakatest_descr,
      baseurl  => $openstackmitakatest_baseurl,
      gpgcheck => $openstackmitakatest_gpgcheck,
      gpgkey   => $openstackmitakatest_gpgkey
    }

    yumrepo { 'centos-openstack-mitaka-debuginfo':
      enabled  => $openstackmitakadebuginfo_enabled,
      descr    => $openstackmitakadebuginfo_descr,
      baseurl  => $openstackmitakadebuginfo_baseurl,
      gpgcheck => $openstackmitakadebuginfo_gpgcheck,
      gpgkey   => $openstackmitakadebuginfo_gpgkey
    }

    yumrepo { 'centos-openstack-mitaka-source':
      enabled  => $openstackmitakasource_enabled,
      descr    => $openstackmitakasource_descr,
      baseurl  => $openstackmitakasource_baseurl,
      gpgcheck => $openstackmitakasource_gpgcheck,
      gpgkey   => $openstackmitakasource_gpgkey
    }
  }

}
