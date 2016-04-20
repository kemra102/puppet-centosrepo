# Class: centosrepo
# ===========================
#
# Full description of class centosrepo here.
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
class centosrepo (
  Boolean $manage_repo_dir

) {

  include '::centosrepo::cloud'
  include '::centosrepo::core'
  include '::centosrepo::sclo'
  include '::centosrepo::storage'
  include '::centosrepo::virtualization'

}
