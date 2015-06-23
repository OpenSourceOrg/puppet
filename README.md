Open Source Initiative (OSI)'s Puppet Recipes
=============================================

In this Git repository you can find the [Puppet][1] recipes used to configure
Open Source Initiative (OSI)'s servers. As of now a single host
(gpl.opensource.org, or gpl.o.o for short) is configured via Puppet and used
for a number of mail-related services:

- Postfix MTA, with countermeasures for SPAM (via spamassassin) and viruses
  (via Amavisd/ClamAV), with a set of authenticated SMTP users and mail aliases
  for @opensource.org users

- Mailman mailing list server (integrated with Postfix)

- Apache server (mostly for Mailman's web-based UI)

The Puppet recipes encode the *functional* part of the setup, separated into
individual Puppet modules, but do not contain any configuration *data*. Rather,
configuration data is stored into YAML files for [Hiera][2].

[1]: https://puppetlabs.com/puppet/puppet-open-source
[2]: http://docs.puppetlabs.com/hiera/

Configuration data that is common to all machines (e.g., packaged goodies that
we want installed on every host) and is not private data is stored under
`hieradata/defaults.yaml`. That file also provide default configuration values
for host-specific data.  Configuration data that is either host-specific or
should remain private (or both) should be stored under
`hieradata/private/HOSTNAME.yaml`, where hostname is the (not fully qualified)
host name, e.g., "gpl". Values in that file will override corresponding values
in `defaults.yaml`.

Note that `hieradata/private` is not checked into this Git repository (and
shouldn't be, for privacy reasons). On the actual hosts deployment hosts---and
in particular on gpl.o.o---the directory `hieradata/private` might be
checked-in different Git repository, for auditing reasons. For obvious reasons
that Git repository must remain OSI-private.


How to deploy
-------------

OSI does not use a agent/master setup, but rather a standalone setup, deploying
with `puppet apply`. The following convenience script are available starting
from this Git repository:

- **./test.sh**: will do a dry-run deployment test based on the current status
  of the recipes. Doing so will show on screen what an actual deployment will
  do, including textual diffs to Puppet-managed files

- **./apply.sh**: same as test.sh, but will do the actual deployment

- **./hiera-lookup.sh**: will perform a Hiera lookup for a given configuration
  key, for the current host


Contribute
----------

You are welcome to use these Puppet recipes for your own needs. If you would
like to, you are also welcome to contribute back your improvements to OSI, we
will very much appreciate!

- feel free to submit a **pull request** at
  <https://github.com/OpenSourceOrg/puppet>, where this repository is hosted

- or to contact us via **email** at <osi@opensource.org>


Acknowledgements
----------------

- Roland Mas <roland.mas@gnurandal.com>, as an OSI contractor, has kick-started
  and shaped these Puppet recipes. They wouldn't exist without him.


License
-------

	Copyright 2015 Open Source Initiative
	Copyright 2015 Roland Mas
	Copyright 2015 Stefano Zacchiroli

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
