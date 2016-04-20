# Class: centosrepo::core
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
class centosrepo::core (
  Boolean $manage_repo_dir                    = $::centosrepo::manage_repo_dir,

  Boolean          $base_enabled              = true,
  String           $base_descr                = 'CentOS-$releasever - Base',
  Optional[String] $base_mirrorlist           = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra',
  Optional[String] $base_baseurl              = undef,
  Boolean          $base_gpgcheck             = true,
  String           $base_gpgkey               = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $updates_enabled           = true,
  String           $updates_descr             = 'CentOS-$releasever - Updates',
  Optional[String] $updates_mirrorlist        = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra',
  Optional[String] $updates_baseurl           = undef,
  Boolean          $updates_gpgcheck          = true,
  String           $updates_gpgkey            = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $extras_enabled            = true,
  String           $extras_descr              = 'CentOS-$releasever - Extras',
  Optional[String] $extras_mirrorlist         = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra',
  Optional[String] $extras_baseurl            = undef,
  Boolean          $extras_gpgcheck           = true,
  String           $extras_gpgkey             = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $centosplus_enabled        = false,
  String           $centosplus_descr          = 'CentOS-$releasever - CentOS Plus',
  Optional[String] $centosplus_mirrorlist     = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra',
  Optional[String] $centosplus_baseurl        = undef,
  Boolean          $centosplus_gpgcheck       = true,
  String           $centosplus_gpgkey         = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $cr_enabled                = false,
  String           $cr_descr                  = 'CentOS-$releasever - Continuous Release ( CR )',
  String           $cr_baseurl                = 'http://mirror.centos.org/centos/$releasever/cr/$basearch/',
  Boolean          $cr_gpgcheck               = true,
  String           $cr_gpgkey                 = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $debuginfo_enabled         = false,
  String           $debuginfo_descr           = 'CentOS-$releasever - DebugInfo',
  String           $debuginfo_baseurl         = 'http://debuginfo.centos.org/7/$basearch/',
  Boolean          $debuginfo_gpgcheck        = true,
  String           $debuginfo_gpgkey          = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $fasttrack_enabled         = false,
  String           $fasttrack_descr           = 'CentOS-$releasever - fasttrack',
  Optional[String] $fasttrack_mirrorlist      = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=fasttrack&infra=$infra',
  Optional[String] $fasttrack_baseurl         = undef,
  Boolean          $fasttrack_gpgcheck        = true,
  String           $fasttrack_gpgkey          = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $basesource_enabled        = false,
  String           $basesource_descr          = 'CentOS-$releasever - Base Sources',
  String           $basesource_baseurl        = 'http://vault.centos.org/centos/$releasever/os/Source/',
  Boolean          $basesource_gpgcheck       = true,
  String           $basesource_gpgkey         = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $updatessource_enabled     = false,
  String           $updatessource_descr       = 'CentOS-$releasever - Updates Sources',
  String           $updatessource_baseurl     = 'http://vault.centos.org/centos/$releasever/updates/Source/',
  Boolean          $updatessource_gpgcheck    = true,
  String           $updatessource_gpgkey      = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $extrassource_enabled      = false,
  String           $extrassource_descr        = 'CentOS-$releasever - Extras Sources',
  String           $extrassource_baseurl      = 'http://vault.centos.org/centos/$releasever/extras/Source/',
  Boolean          $extrassource_gpgcheck     = true,
  String           $extrassource_gpgkey       = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS',

  Boolean          $centosplussource_enabled  = false,
  String           $centosplussource_descr    = 'CentOS-$releasever - CentOS Plus Sources',
  String           $centosplussource_baseurl  = 'http://vault.centos.org/centos/$releasever/centosplus/Source/',
  Boolean          $centosplussource_gpgcheck = true,
  String           $centosplussource_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS'

) {

  if $manage_repo_dir {
    if ! defined(Resources['yumrepo']) {
      resources { 'yumrepo': purge => true }
    }
  }

  # Ensure the keys are imported first
  Centosrepo::Rpm_gpg_key <| |> -> Yumrepo <| |>

  $gpg_keys = ['RPM-GPG-KEY-CentOS', 'RPM-GPG-KEY-CentOS-Debug']
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

  yumrepo { 'base':
    enabled    => $base_enabled,
    descr      => $base_descr,
    mirrorlist => $base_mirrorlist,
    baseurl    => $base_baseurl,
    gpgcheck   => $base_gpgcheck,
    gpgkey     => $base_gpgkey
  }

  yumrepo { 'updates':
    enabled    => $updates_enabled,
    descr      => $updates_descr,
    mirrorlist => $updates_mirrorlist,
    baseurl    => $updates_baseurl,
    gpgcheck   => $updates_gpgcheck,
    gpgkey     => $updates_gpgkey
  }

  yumrepo { 'extras':
    enabled    => $extras_enabled,
    descr      => $extras_descr,
    mirrorlist => $extras_mirrorlist,
    baseurl    => $extras_baseurl,
    gpgcheck   => $extras_gpgcheck,
    gpgkey     => $extras_gpgkey
  }

  yumrepo { 'centosplus':
    enabled    => $centosplus_enabled,
    descr      => $centosplus_descr,
    mirrorlist => $centosplus_mirrorlist,
    baseurl    => $centosplus_baseurl,
    gpgcheck   => $centosplus_gpgcheck,
    gpgkey     => $centosplus_gpgkey
  }

  yumrepo { 'cr':
    enabled  => $cr_enabled,
    descr    => $cr_descr,
    baseurl  => $cr_baseurl,
    gpgcheck => $cr_gpgcheck,
    gpgkey   => $cr_gpgkey
  }

  yumrepo { 'debuginfo':
    enabled  => $debuginfo_enabled,
    descr    => $debuginfo_descr,
    baseurl  => $debuginfo_baseurl,
    gpgcheck => $debuginfo_gpgcheck,
    gpgkey   => $debuginfo_gpgkey
  }

  yumrepo { 'fasttrack':
    enabled    => $fasttrack_enabled,
    descr      => $fasttrack_descr,
    mirrorlist => $fasttrack_mirrorlist,
    baseurl    => $fasttrack_baseurl,
    gpgcheck   => $fasttrack_gpgcheck,
    gpgkey     => $fasttrack_gpgkey
  }

  yumrepo { 'base-source':
    enabled  => $basesource_enabled,
    descr    => $basesource_descr,
    baseurl  => $basesource_baseurl,
    gpgcheck => $basesource_gpgcheck,
    gpgkey   => $basesource_gpgkey
  }

  yumrepo { 'updates-source':
    enabled  => $updatessource_enabled,
    descr    => $updatessource_descr,
    baseurl  => $updatessource_baseurl,
    gpgcheck => $updatessource_gpgcheck,
    gpgkey   => $updatessource_gpgkey
  }

  yumrepo { 'extras-source':
    enabled  => $extrassource_enabled,
    descr    => $extrassource_descr,
    baseurl  => $extrassource_baseurl,
    gpgcheck => $extrassource_gpgcheck,
    gpgkey   => $extrassource_gpgkey
  }

  yumrepo { 'centos-plus-source':
    enabled  => $centosplussource_enabled,
    descr    => $centosplussource_descr,
    baseurl  => $centosplussource_baseurl,
    gpgcheck => $centosplussource_gpgcheck,
    gpgkey   => $centosplussource_gpgkey
  }

}
