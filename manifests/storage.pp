# Class: centosrepo::storage
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
class centosrepo::storage (
  Boolean $manage_repo_dir              = $::centosrepo::manage_repo_dir,

  Boolean $cephhammer_enabled           = false,
  String  $cephhammer_descr             = 'CentOS-$releasever - Ceph Hammer',
  String  $cephhammer_baseurl           = 'http://mirror.centos.org/centos/$releasever/storage/$basearch/ceph-hammer/',
  Boolean $cephhammer_gpgcheck          = true,
  String  $cephhammer_gpgkey            = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage',

  Boolean $cephhammertest_enabled       = false,
  String  $cephhammertest_descr         = 'CentOS-$releasever - Ceph Hammer Test',
  String  $cephhammertest_baseurl       = 'http://buildlogs.centos.org/centos/$releasever/storage/$basearch/ceph-hammer/',
  Boolean $cephhammertest_gpgcheck      = true,
  String  $cephhammertest_gpgkey        = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage',

  Boolean $cephhammerdebuginfo_enabled  = false,
  String  $cephhammerdebuginfo_descr    = 'CentOS-$releasever - Ceph Hammer DebugInfo',
  String  $cephhammerdebuginfo_baseurl  = 'http://debuginfo.centos.org/centos/$releasever/storage/$basearch/',
  Boolean $cephhammerdebuginfo_gpgcheck = true,
  String  $cephhammerdebuginfo_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage',

  Boolean $cephhammersource_enabled     = false,
  String  $cephhammersource_descr       = 'CentOS-$releasever - Ceph Hammer Source',
  String  $cephhammersource_baseurl     = 'http://vault.centos.org/centos/$releasever/storage/Source/ceph-hammer/',
  Boolean $cephhammersource_gpgcheck    = true,
  String  $cephhammersource_gpgkey      = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage',

  Boolean $gluster36_enabled            = false,
  String  $gluster36_descr              = 'CentOS-$releasever - Gluster 3.6',
  String  $gluster36_baseurl            = 'http://mirror.centos.org/centos/$releasever/storage/$basearch/gluster-3.6/',
  Boolean $gluster36_gpgcheck           = true,
  String  $gluster36_gpgkey             = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage',

  Boolean $gluster36test_enabled        = false,
  String  $gluster36test_descr          = 'CentOS-$releasever - Gluster 3.6 Testing',
  String  $gluster36test_baseurl        = 'http://buildlogs.centos.org/centos/$releasever/storage/$basearch/gluster-3.6/',
  Boolean $gluster36test_gpgcheck       = true,
  String  $gluster36test_gpgkey         = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage',

  Boolean $gluster37_enabled            = false,
  String  $gluster37_descr              = 'CentOS-$releasever - Gluster 3.7',
  String  $gluster37_baseurl            = 'http://mirror.centos.org/centos/$releasever/storage/$basearch/gluster-3.7/',
  Boolean $gluster37_gpgcheck           = true,
  String  $gluster37_gpgkey             = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage',

  Boolean $gluster37test_enabled        = false,
  String  $gluster37test_descr          = 'CentOS-$releasever - Gluster 3.7',
  String  $gluster37test_baseurl        = 'http://buildlogs.centos.org/centos/$releasever/storage/$basearch/gluster-3.7/',
  Boolean $gluster37test_gpgcheck       = true,
  String  $gluster37test_gpgkey         = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage'

) {

  if $manage_repo_dir {
    if ! defined(Resources['yumrepo']) {
      resources { 'yumrepo': purge => true }
    }
  }

  # Ensure the keys are imported first
  Centosrepo::Rpm_gpg_key <| |> -> Yumrepo <| |>

  $gpg_keys = ['RPM-GPG-KEY-CentOS-SIG-Storage']
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
    yumrepo { 'centos-ceph-hammer':
      enabled  => $cephhammer_enabled,
      descr    => $cephhammer_descr,
      baseurl  => $cephhammer_baseurl,
      gpgcheck => $cephhammer_gpgcheck,
      gpgkey   => $cephhammer_gpgkey
    }

    yumrepo { 'centos-ceph-hammer-test':
      enabled  => $cephhammertest_enabled,
      descr    => $cephhammertest_descr,
      baseurl  => $cephhammertest_baseurl,
      gpgcheck => $cephhammertest_gpgcheck,
      gpgkey   => $cephhammertest_gpgkey
    }

    yumrepo { 'centos-ceph-hammer-debuginfo':
      enabled  => $cephhammerdebuginfo_enabled,
      descr    => $cephhammerdebuginfo_descr,
      baseurl  => $cephhammerdebuginfo_baseurl,
      gpgcheck => $cephhammerdebuginfo_gpgcheck,
      gpgkey   => $cephhammerdebuginfo_gpgkey
    }

    yumrepo { 'centos-ceph-hammer-source':
      enabled  => $cephhammersource_enabled,
      descr    => $cephhammersource_descr,
      baseurl  => $cephhammersource_baseurl,
      gpgcheck => $cephhammersource_gpgcheck,
      gpgkey   => $cephhammersource_gpgkey
    }
  }

  if $::operatingsystemmajrelease == '6' or $::operatingsystemmajrelease == '7' {
    yumrepo { 'centos-gluster36':
      enabled  => $gluster36_enabled,
      descr    => $gluster36_descr,
      baseurl  => $gluster36_baseurl,
      gpgcheck => $gluster36_gpgcheck,
      gpgkey   => $gluster36_gpgkey
    }

    yumrepo { 'centos-gluster36-test':
      enabled  => $gluster36test_enabled,
      descr    => $gluster36test_descr,
      baseurl  => $gluster36test_baseurl,
      gpgcheck => $gluster36test_gpgcheck,
      gpgkey   => $gluster36test_gpgkey
    }

    yumrepo { 'centos-gluster37':
      enabled  => $gluster37_enabled,
      descr    => $gluster37_descr,
      baseurl  => $gluster37_baseurl,
      gpgcheck => $gluster37_gpgcheck,
      gpgkey   => $gluster37_gpgkey
    }

    yumrepo { 'centos-gluster37-test':
      enabled  => $gluster37test_enabled,
      descr    => $gluster37test_descr,
      baseurl  => $gluster37test_baseurl,
      gpgcheck => $gluster37test_gpgcheck,
      gpgkey   => $gluster37test_gpgkey
    }
  }

}
