# Class: centosrepo::sclo
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
class centosrepo::sclo (
  Boolean $manage_repo_dir            = $::centosrepo::manage_repo_dir,

  Boolean $sclosclo_enabled           = false,
  String  $sclosclo_descr             = 'CentOS-$releasever - SCLo sclo',
  String  $sclosclo_baseurl           = 'http://mirror.centos.org/centos/$releasever/sclo/$basearch/sclo/',
  Boolean $sclosclo_gpgcheck          = true,
  String  $sclosclo_gpgkey            = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',

  Boolean $sclosclotest_enabled       = false,
  String  $sclosclotest_descr         = 'CentOS-$releasever - SCLo sclo Testing',
  String  $sclosclotest_baseurl       = 'http://buildlogs.centos.org/centos/$releasever/sclo/$basearch/sclo/',
  Boolean $sclosclotest_gpgcheck      = true,
  String  $sclosclotest_gpgkey        = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',

  Boolean $sclosclodebuginfo_enabled  = false,
  String  $sclosclodebuginfo_descr    = 'CentOS-$releasever - SCLo sclo DebugInfo',
  String  $sclosclodebuginfo_baseurl  = 'http://debuginfo.centos.org/centos/$releasever/sclo/$basearch/',
  Boolean $sclosclodebuginfo_gpgcheck = true,
  String  $sclosclodebuginfo_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',

  Boolean $sclosclosource_enabled     = false,
  String  $sclosclosource_descr       = 'CentOS-$releasever - SCLo sclo Sources',
  String  $sclosclosource_baseurl     = 'http://vault.centos.org/centos/$releasever/sclo/Source/sclo/',
  Boolean $sclosclosource_gpgcheck    = true,
  String  $sclosclosource_gpgkey      = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',

  Boolean $sclorh_enabled             = false,
  String  $sclorh_descr               = 'CentOS-$releasever - SCLo rh',
  String  $sclorh_baseurl             = 'http://mirror.centos.org/centos/$releasever/sclo/$basearch/rh/',
  Boolean $sclorh_gpgcheck            = true,
  String  $sclorh_gpgkey              = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',

  Boolean $sclorhtest_enabled         = false,
  String  $sclorhtest_descr           = 'CentOS-$releasever - SCLo rh Testing',
  String  $sclorhtest_baseurl         = 'http://buildlogs.centos.org/centos/$releasever/sclo/$basearch/rh/',
  Boolean $sclorhtest_gpgcheck        = true,
  String  $sclorhtest_gpgkey          = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',

  Boolean $sclorhdebuginfo_enabled   = false,
  String  $sclorhdebuginfo_descr     = 'CentOS-$releasever - SCLo rh DebugInfo',
  String  $sclorhdebuginfo_baseurl   = 'http://debuginfo.centos.org/centos/$releasever/sclo/$basearch/',
  Boolean $sclorhdebuginfo_gpgcheck  = true,
  String  $sclorhdebuginfo_gpgkey    = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo',

  Boolean $sclorhsource_enabled      = false,
  String  $sclorhsource_descr        = 'CentOS-$releasever - SCLo rh Sources',
  String  $sclorhsource_baseurl      = 'http://vault.centos.org/centos/$releasever/sclo/Source/rh/',
  Boolean $sclorhsource_gpgcheck     = true,
  String  $sclorhsource_gpgkey       = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo'

) {

  if $manage_repo_dir {
    if ! defined(Resources['yumrepo']) {
      resources { 'yumrepo': purge => true }
    }
  }

  # Ensure the keys are imported first
  Centosrepo::Rpm_gpg_key <| |> -> Yumrepo <| |>

  $gpg_keys = ['RPM-GPG-KEY-CentOS-SIG-SCLo']
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

  if $::operatingsystemmajrelease == '6' or $::operatingsystemmajrelease == '7' {
    yumrepo { 'centos-sclo-sclo':
      enabled  => $sclosclo_enabled,
      descr    => $sclosclo_descr,
      baseurl  => $sclosclo_baseurl,
      gpgcheck => $sclosclo_gpgcheck,
      gpgkey   => $sclosclo_gpgkey
    }

    yumrepo { 'centos-sclo-sclo-test':
      enabled  => $sclosclotest_enabled,
      descr    => $sclosclotest_descr,
      baseurl  => $sclosclotest_baseurl,
      gpgcheck => $sclosclotest_gpgcheck,
      gpgkey   => $sclosclotest_gpgkey
    }

    yumrepo { 'centos-sclo-sclo-debuginfo':
      enabled  => $sclosclodebuginfo_enabled,
      descr    => $sclosclodebuginfo_descr,
      baseurl  => $sclosclodebuginfo_baseurl,
      gpgcheck => $sclosclodebuginfo_gpgcheck,
      gpgkey   => $sclosclodebuginfo_gpgkey
    }

    yumrepo { 'centos-sclo-sclo-source':
      enabled  => $sclosclosource_enabled,
      descr    => $sclosclosource_descr,
      baseurl  => $sclosclosource_baseurl,
      gpgcheck => $sclosclosource_gpgcheck,
      gpgkey   => $sclosclosource_gpgkey
    }

    yumrepo { 'centos-sclo-rh':
      enabled  => $sclorh_enabled,
      descr    => $sclorh_descr,
      baseurl  => $sclorh_baseurl,
      gpgcheck => $sclorh_gpgcheck,
      gpgkey   => $sclorh_gpgkey
    }

    yumrepo { 'centos-sclo-rh-test':
      enabled  => $sclorhtest_enabled,
      descr    => $sclorhtest_descr,
      baseurl  => $sclorhtest_baseurl,
      gpgcheck => $sclorhtest_gpgcheck,
      gpgkey   => $sclorhtest_gpgkey
    }

    yumrepo { 'centos-sclo-rh-debuginfo':
      enabled  => $sclorhdebuginfo_enabled,
      descr    => $sclorhdebuginfo_descr,
      baseurl  => $sclorhdebuginfo_baseurl,
      gpgcheck => $sclorhdebuginfo_gpgcheck,
      gpgkey   => $sclorhdebuginfo_gpgkey
    }

    yumrepo { 'centos-sclo-rh-source':
      enabled  => $sclorhsource_enabled,
      descr    => $sclorhsource_descr,
      baseurl  => $sclorhsource_baseurl,
      gpgcheck => $sclorhsource_gpgcheck,
      gpgkey   => $sclorhsource_gpgkey
    }
  }

}
