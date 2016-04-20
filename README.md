# centosrepo

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
  * [Examples - Some trivial examples of common configs](#examples)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module allows you to easily manage all CentOS Project repos on your CentOS box, including the repos supported by each non-Core SIG.

## Usage

To include all repos from the CentOS project simply include the module in your code:

```puppet
include '::centosrepo'
```

You can include only the repos for a specific SIG as well.

[Core SIG](https://wiki.centos.org/SpecialInterestGroup/Core):
```puppet
include '::centosrepo::core'
```

[Cloud SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud):
```puppet
include '::centosrepo::cloud'
```

[SCLo SIG](https://wiki.centos.org/SpecialInterestGroup/SCLo) (Software Collections):
```puppet
include '::centosrepo::sclo'
```

[Storage SIG](https://wiki.centos.org/SpecialInterestGroup/Storage):
```puppet
include '::centosrepo::storage'
```

[Virtualization SIG](https://wiki.centos.org/SpecialInterestGroup/Virtualization):
```puppet
include '::centosrepo::virtualization'
```

By default only a handful of the repos provided by `::centosrepo::core` are enabaled by default, all others must be explicitly enabled. Also it should be noted that certain repos are only available on certain versions of CentOS, please see the details reference below for further details.

### Examples

If I plan to set-up an OpenStack Compute node I'll need access to both the OpenStack repo of my choice & the Hypervisor of my choice:

```puppet
class { '::centosrepo::cloud': openstackmitaka_enable => true}
class { '::centosrepo::virtualization': qemuev_enable => true }
```

One of the most commen use cases might be pointing the standard CentOS repos to a local mirror within your corporate network:

```puppet
class { '::centosrepo::core':
  base_mirrorlist    => undef,
  base_baseurl       => 'http://yum.mycorp.net/base/',
  updates_mirrorlist => undef,
  updates_baseurl    => 'http://yum.mycorp.net/updates/',
  extras_mirrorlist  => undef,
  extras_baseurl     => 'http://yum.mycorp.net/extras/'
}
```

## Reference

Each manifest provides access to multiple repositories for the projects supported by that particular SIG. This section will break down the options for each manifest by the repos it provides. For information on the software provided by each SIG see the details above in the [Usage](#usage) section.

### Core

| Attribute | Type | Description | Default |
|:---------:|:----:|:-----------:|:-------:|
| 

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
