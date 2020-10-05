# README kub-iac-cluster

Version: *1.0-0*

An IAC project using Vagrant to create and initialize a kubernetes cluster of 1 master and 2 nodes.

Now works with flannel (using eth1 interface)

## Dependencies
- Vagrant installed on the host
- VirtualBox installed on the host

## How to setup
Make sure you have `VirtualBox` and `vagrant` installed.
just execute `vagrant up` on the main folder.
There will be:
- created 3 VMs (Vagrant image: bento/ubuntu-16.04 version: 201808.24.0),
- a kubernetes cluster will be created 
- the 2 nodes will join on the cluster

