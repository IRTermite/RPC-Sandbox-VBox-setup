#!/bin/bash
## Written By: Dale "Termite" Bracey | @IRTermite | dale@rackspace.com

##### Create bridge from cli?  http://www.scottro.net/vboxbridge.html
##### Host-only create  http://knowledgefrontier.blogspot.com/2013/01/virtualbox-host-only-mode-without.html

# Show EULA and ask for accept to continue
cat "The Rackspace Private Cloud (“RPC”) Sandbox is a virtual appliance that allows 
you to run RPC on any hardware using virtualization tools.  RPC Sandbox is 
Rackspace Private Cloud Software, powered by OpenStack, packaged into a virtual
environment.  RPC Sandbox allows you to experiment with the latest RPC features
quickly without the need of additional hardware. While RPC Sandbox allows you
to demo most of the features available in RPC, all of the OpenStack services
will run on a single virtual machine therefore performance will be
sub-optimal. Additionally, RPC Sandbox will be constrained by the memory
allocated to it in the virtual environment.  You must not use this environment
for any production or performance workloads.  This environment will not be 
upgradable to future RPC releases.

RPC Sandbox is licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.  This version
of RPC Sandbox includes Rackspace trademarks and logos, and in accordance with
Section 6 of the License, the provision of commercial support services in
conjunction with a version of RPC Sandbox which includes Rackspace trademarks
and logos is prohibited.  RPC Sandbox source code and details are available at:
https://github.com/cloudnull/rcbops_virt_builder or upon written request.

You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0 and a copy, including this notice,
is available in the LICENSE file accompanying this software.

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
"

## >> Insert prompt to accept...

# Import Appliance
## >> Insert some of the options to allow overrides for the disk name and others.  Run the import without --eula arguments to see the other options.

## >> Can't import until license agreement listed
vboxmanage import --vsys 0 --eula accept RPC-SANDBOX-VBOX*.ova

# VBox Network Preferences

## Create host-only network
vboxmanage hostonlyif create
## >> Need to figure out how to just grab the last created
vboxmanage list hostonlyifs
## >> This may cause problems, since it creates v6 IPs with it, and can't combine v4 and v6 arguments
## vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0
vboxmanage dhcpserver add --ifname vboxnet0 --ip 192.168.56.100 --netmask 255.255.255.0 --lowerip 192.168.56.200 --upperip 192.168.56.254
vboxmanage dhcpserver modify --ifname vboxnet0 --ip 192.168.56.100 --netmask 255.255.255.0 --lowerip 192.168.56.200 --upperip 192.168.56.254
vboxmanage dhcpserver modify --ifname vboxnet0 --enable



## Set VBox interfaces
### Available options [none|null|nat|bridged|intnet|hostonly|generic]
### Interface 1
vboxmanage modifyvm <uuid|name> --nic<1-N> bridged
### Interface 2
vboxmanage modifyvm <uuid|name> --nic<1-N> intnet
### Interface 3
vboxmanage modifyvm <uuid|name> --nic<1-N> hostonly
### Interface 4
vboxmanage modifyvm <uuid|name> --nic<1-N> intnet


# If host-only networking has been enabled for a virtual network card (see the --nic option above; otherwise this setting has no effect), use this option to specify which host-only networking interface the given virtual network interface will use. For details, please see Section 6.7, “Host-only networking”.
vboxmanage modifyvm --hostonlyadapter<1-N> none|<devicename>