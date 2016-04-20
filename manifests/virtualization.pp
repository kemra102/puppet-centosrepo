# Class: centosrepo::virtualization
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
class centosrepo::virtualization (
  Boolean $manage_repo_dir        = $::centosrepo::manage_repo_dir,

  Boolean $ovirt35_enabled        = false,
  String  $ovirt35_descr          = 'CentOS-$releasever - oVirt 3.5',
  String  $ovirt35_baseurl        = 'http://mirror.centos.org/centos/$releasever/virt/$basearch/ovirt-3.5/',
  Boolean $ovirt35_gpgcheck       = true,
  String  $ovirt35_gpgkey         = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $ovirt35test_enabled    = false,
  String  $ovirt35test_descr      = 'CentOS-$releasever - oVirt 3.5 Testing',
  String  $ovirt35test_baseurl    = 'http://buildlogs.centos.org/centos/$releasever/virt/$basearch/ovirt-3.5/',
  Boolean $ovirt35test_gpgcheck   = true,
  String  $ovirt35test_gpgkey     = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $ovirt36_enabled        = false,
  String  $ovirt36_descr          = 'CentOS-$releasever - oVirt 3.6',
  String  $ovirt36_baseurl        = 'http://mirror.centos.org/centos/$releasever/virt/$basearch/ovirt-3.6/',
  Boolean $ovirt36_gpgcheck       = true,
  String  $ovirt36_gpgkey         = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $ovirt36test_enabled    = false,
  String  $ovirt36test_descr      = 'CentOS-$releasever - oVirt 3.6 Testing',
  String  $ovirt36test_baseurl    = 'http://buildlogs.centos.org/centos/$releasever/virt/$basearch/ovirt-3.6/',
  Boolean $ovirt36test_gpgcheck   = true,
  String  $ovirt36test_gpgkey     = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $qemuev_enabled         = false,
  String  $qemuev_descr           = 'CentOS-$releasever - QEMU EV',
  String  $qemuev_baseurl         = 'http://mirror.centos.org/centos/$releasever/virt/$basearch/kvm-common/',
  Boolean $qemuev_gpgcheck        = true,
  String  $qemuev_gpgkey          = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $qemuevtest_enabled     = false,
  String  $qemuevtest_descr       = 'CentOS-$releasever - QEMU EV Testing',
  String  $qemuevtest_baseurl     = 'http://buildlogs.centos.org/centos/$releasever/virt/$basearch/kvm-common/',
  Boolean $qemuevtest_gpgcheck    = true,
  String  $qemuevtest_gpgkey      = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $virtxen_enabled        = false,
  String  $virtxen_descr          = 'CentOS-$releasever - Xen',
  String  $virtxen_baseurl        = 'http://mirror.centos.org/centos/$releasever/virt/$basearch/xen/',
  Boolean $virtxen_gpgcheck       = true,
  String  $virtxen_gpgkey         = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $virtxentest_enabled    = false,
  String  $virtxentest_descr      = 'CentOS-$releasever - Xen Testing',
  String  $virtxentest_baseurl    = 'http://buildlogs.centos.org/centos/$releasever/virt/$basearch/xen/',
  Boolean $virtxentest_gpgcheck   = true,
  String  $virtxentest_gpgkey     = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $virtxen46_enabled      = false,
  String  $virtxen46_descr        = 'CentOS-$releasever - Xen 4.6',
  String  $virtxen46_baseurl      = 'http://mirror.centos.org/centos/$releasever/virt/$basearch/xen/',
  Boolean $virtxen46_gpgcheck     = true,
  String  $virtxen46_gpgkey       = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization',

  Boolean $virtxen46test_enabled  = false,
  String  $virtxen46test_descr    = 'CentOS-$releasever - Xen 4.6 Testing',
  String  $virtxen46test_baseurl  = 'http://buildlogs.centos.org/centos/$releasever/virt/$basearch/xen/',
  Boolean $virtxen46test_gpgcheck = true,
  String  $virtxen46test_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Virtualization'

) {

  if $manage_repo_dir {
    if ! defined(Resources['yumrepo']) {
      resources { 'yumrepo': purge => true }
    }
  }

  # Ensure the keys are imported first
  Centosrepo::Rpm_gpg_key <| |> -> Yumrepo <| |>

  $gpg_keys = ['RPM-GPG-KEY-CentOS-SIG-Virtualization']
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
    yumrepo { 'centos-ovirt35':
      enabled  => $ovirt35_enabled,
      descr    => $ovirt35_descr,
      baseurl  => $ovirt35_baseurl,
      gpgcheck => $ovirt35_gpgcheck,
      gpgkey   => $ovirt35_gpgkey
    }

    yumrepo { 'centos-ovirt35-test':
      enabled  => $ovirt35test_enabled,
      descr    => $ovirt35test_descr,
      baseurl  => $ovirt35test_baseurl,
      gpgcheck => $ovirt35test_gpgcheck,
      gpgkey   => $ovirt35test_gpgkey
    }

    yumrepo { 'centos-ovirt36':
      enabled  => $ovirt36_enabled,
      descr    => $ovirt36_descr,
      baseurl  => $ovirt36_baseurl,
      gpgcheck => $ovirt36_gpgcheck,
      gpgkey   => $ovirt36_gpgkey
    }

    yumrepo { 'centos-ovirt36-test':
      enabled  => $ovirt36test_enabled,
      descr    => $ovirt36test_descr,
      baseurl  => $ovirt36test_baseurl,
      gpgcheck => $ovirt36test_gpgcheck,
      gpgkey   => $ovirt36test_gpgkey
    }

    yumrepo { 'centos-qemu-ev':
      enabled  => $qemuev_enabled,
      descr    => $qemuev_descr,
      baseurl  => $qemuev_baseurl,
      gpgcheck => $qemuev_gpgcheck,
      gpgkey   => $qemuev_gpgkey
    }

    yumrepo { 'centos-qemu-ev-test':
      enabled  => $qemuevtest_enabled,
      descr    => $qemuevtest_descr,
      baseurl  => $qemuevtest_baseurl,
      gpgcheck => $qemuevtest_gpgcheck,
      gpgkey   => $qemuevtest_gpgkey
    }
  }

  if $::operatingsystemmajrelease == '6' or $::operatingsystemmajrelease == '7' {
    yumrepo { 'centos-virt-xen':
      enabled  => $virtxen_enabled,
      descr    => $virtxen_descr,
      baseurl  => $virtxen_baseurl,
      gpgcheck => $virtxen_gpgcheck,
      gpgkey   => $virtxen_gpgkey
    }

    yumrepo { 'centos-virt-xen-test':
      enabled  => $virtxentest_enabled,
      descr    => $virtxentest_descr,
      baseurl  => $virtxentest_baseurl,
      gpgcheck => $virtxentest_gpgcheck,
      gpgkey   => $virtxentest_gpgkey
    }

    yumrepo { 'centos-virt-xen46':
      enabled  => $virtxen46_enabled,
      descr    => $virtxen46_descr,
      baseurl  => $virtxen46_baseurl,
      gpgcheck => $virtxen46_gpgcheck,
      gpgkey   => $virtxen46_gpgkey
    }

    yumrepo { 'centos-virt-xen46-test':
      enabled  => $virtxen46test_enabled,
      descr    => $virtxen46test_descr,
      baseurl  => $virtxen46test_baseurl,
      gpgcheck => $virtxen46test_gpgcheck,
      gpgkey   => $virtxen46test_gpgkey
    }
  }

}
