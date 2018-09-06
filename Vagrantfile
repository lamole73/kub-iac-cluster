# -*- mode: ruby -*-
# vi: set ft=ruby :

_VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(_VAGRANTFILE_API_VERSION) do |config|

  # Relative path of main project folder from vagrant file
  vb_descr_vagrantfile_folder=File.dirname(__FILE__)
  mainfolder_relative_path = ""
  # The environment name (servers will be #{environmentname}-01 .. 04)
  environmentname="kub"
  ippattern_gw="10.10.27.8"
  ippattern="10.10.27.8"
  # The VirtualBox VM name prefix, actual names will be #{vboxvmname}-mgr, #{vboxvmname}-01, e.t.c.
  # set it to nil to not name the VirtualBox VMs, i.e. let vagrant give default name
  vboxvmname="#{environmentname}"
  # Change memory for each VM, make nil to not use the vm
  memArray = Array.new(4)
  memArray[0] = nil  # 512   the mgr running the ansible scripts
  memArray[1] = 2048 # 2048  01 is the master node
  memArray[2] = 2048 # 2048  02 is the node 2
  memArray[3] = 2048 # 2048  03 is the node 3
  cpuArray = Array.new(4)
  cpuArray[0] = 1    # the mgr running the ansible scripts
  cpuArray[1] = 2    # 01 is the master node
  cpuArray[2] = 2    # 02 is the node 2
  cpuArray[3] = 2    # 03 is the node 3

  # Set it to true to install the samba server on the VMs
  install_samba=false
  # Set it to true to install the avahi daemon DNS server on the VMs
  install_avahi=false

  # Note bento/centos-7.4 version: 201803.24.0 contains centos-7.4-x86_64, build_timestamp: 2018-03-26-16:29:04, see https://app.vagrantup.com/bento/boxes/centos-7.4/versions/201803.24.0
  # vb_descr_notes_box is only used on VirtualBox description
  #vb_descr_notes_box="Note bento/centos-7.4 version: 201803.24.0 contains centos-7.4-x86_64, build_timestamp: 2018-03-26-16:29:04, see https://app.vagrantup.com/bento/boxes/centos-7.4/versions/201803.24.0"
  vb_descr_notes_box="Note bento/ubuntu-16.04 version: 201808.24.0 build_timestamp:20180902154418 contains ubuntu-16.04-amd64, see https://app.vagrantup.com/bento/boxes/centos-7.4/versions/201803.24.0"
  vb_box_name="bento/centos-7.4"
  vb_box_version="201803.24.0" # 201803.24.0 is centos-7.4-x86_64, build_timestamp: 2018-03-26-16:29:04
  config.vm.box = "#{vb_box_name}"
  config.vm.box_version = "#{vb_box_version}"
  config.vm.box_check_update = false
  config.ssh.insert_key = false

  config.vm.provider 'virtualbox' do |v|
    v.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0')
  end

  config.vm.provider :virtualbox do |vb|
    #vb.customize ["modifyvm", :id, "--memory", "256"]
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Customize the amount of memory on the VM:
    # vb.memory = "1024"
  end

  #
  # Environment VMs
  # Role depends on the number:
  # 00 is the manager (ansible)
  # 01 is the master
  # 02 is the node 2
  # 03 is the node 3
  #
  (0..3).each do |i|
    if memArray[i] != nil then
      #
      # #i VM see memArray for which VM this is
      #
      config.vm.define "0#{i}" do |d|
        # ############## VirtualBox image/hostname/network
        if i == 0 then
          d.vm.box = "bento/ubuntu-16.04" # ubuntu/bionic64 = 18.04 version 20180831.0.0, ubuntu/xenial64 = 16.04 version 20180831.0.0, bento/ubuntu-16.04 version 201808.24.0
          d.vm.box_version = "201808.24.0"
          #d.vm.box = "bento/centos-7.4"
          #d.vm.box_version = "201803.24.0" # 201803.24.0 is centos-7.4-x86_64, build_timestamp: 2018-03-26-16:29:04
        else
          d.vm.box = "bento/ubuntu-16.04" # ubuntu/bionic64 = 18.04 version 20180831.0.0, ubuntu/xenial64 = 16.04 version 20180831.0.0, bento/ubuntu-16.04 version 201808.24.0
          d.vm.box_version = "201808.24.0"
          # Note bento/centos-7.4 version: 201803.24.0 contains centos-7.4-x86_64, build_timestamp: 2018-03-26-16:29:04, see https://app.vagrantup.com/bento/boxes/centos-7.4/versions/201803.24.0
          #d.vm.box = "bento/centos-7.4"
          #d.vm.box_version = "201803.24.0" # 201803.24.0 is centos-7.4-x86_64, build_timestamp: 2018-03-26-16:29:04
        end
        d.vm.hostname = "#{environmentname}-0#{i}"
        d.vm.network :private_network, ip: "#{ippattern}#{i}"
        if vboxvmname != nil then
          d.vm.provider "virtualbox" do |v|
            v.name = "#{vboxvmname}-0#{i}"
          end
        end
        # ############## Customize the VirtualBox NAT network to be unique per VM
        #d.vm.provider "virtualbox" do |v|
        #  v.customize ['modifyvm', :id, '--natnet1', "192.168.10#{i}.0/24"]
        #end
        # ############## Customize the VirtualBox description
        # Note it is always customized, i.e. after halt / up it replaces whatever is written
        d.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--description", "
## Vagrant VM definition hostname: #{d.vm.hostname}
Vagrantfile folder:
#{vb_descr_vagrantfile_folder}

## Vagrant VM using box: #{d.vm.box} version: #{d.vm.box_version}
## #{vb_descr_notes_box}

= hostname: #{vboxvmname}-0#{i}, mem: #{memArray[i]} MB, CPUs: #{cpuArray[i]}
= Users: root/1, vagrant/1, dms/dms (samba)
= Samba installed: #{install_samba}
            "]
        end
        # ############## Install ansible (on 00 the manager only)
        if i == 0 then
          d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_ansible_ubuntu.sh"
          # d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_ansible_centos.sh"
        end
        # ############## CENTOS 7 to initiallize correctly and install guest additions
        # if i > 0 then
        #   d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_disable_selinux.sh"
        # end
        # ############## bento centos-7.4 already has Guest Additions installed
        # if shared_folders_via_vboxfs then
        #   d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_guestadditions_centos_redhat.sh"
        # end
        ############## Enable remote ssh login
        # bento centos-7.4 already has remote ssh login, but ubuntu/xenial64 does not
        d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_enable_ssh_login.sh"
        # ############## Increase SWAP size to 2048MB or XE11G and oracle VM
        # # bento centos-7.4 already has 2 GB swap size
        # d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_increase_swap_size.sh"
        # ############## For hostname resolution of the VMs
        if install_avahi then
          d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_avahi_centos.sh"
        end
        ############## For hostname resolution of the VMs via /etc/hosts
        d.vm.provision :shell, run: "always", inline: <<-SHELL
          for i in `seq 0 3`;
          do
            grep -q "^[0-9].*#{environmentname}-0${i}" /etc/hosts
            RV=$?
            if [ $RV == 0 ]; then
              # update via sed
              sed -i "s|^[0-9].*#{environmentname}-0${i}.*$|#{ippattern}${i} #{environmentname}-0${i} #{environmentname}-0${i}.labros.private|g" /etc/hosts
            else
              # Add the line
              echo "" >> /etc/hosts
              echo "#{ippattern}${i} #{environmentname}-0${i} #{environmentname}-0${i}.labros.private" >> /etc/hosts
            fi
          done
        SHELL
        # ############## sshpass - for ssh automatically to other hosts
        d.vm.provision :shell, inline: <<-SHELL
          #yum install -y sshpass
          apt-get update && apt-get install -y sshpass
        SHELL
        # ############## For Oracle
        # # bento centos-7.4 already has net-tools installed
        #d.vm.provision :shell, inline: <<-SHELL
        #  yum install -y net-tools
        #SHELL
        # ############## Make password 1 for both root and vagrant
        d.vm.provision :shell, inline: <<-SHELL
          echo "Setting password of root to '1'..."
          echo root:1 | sudo chpasswd
          echo "Setting password of vagrant to '1'..."
          echo vagrant:1 | sudo chpasswd
        SHELL
        # ############## Install samba (user dms/dms)
        if install_samba then
          d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_samba_dms_centos.sh", args: "#{d.vm.hostname}"
        end
        ### [Kubernetes] Below are installed only on non mgr machine
        if i > 0 then
          ############## Manually override the default router configuration so that Kubernetes network work despite the 1st NAT network interface
          ############## see https://superuser.com/questions/752954/need-to-do-bridged-adapter-only-in-vagrant-no-nat
          # DOES NOT WORK since then we cannot connect to internet
          #d.vm.provision :shell, run: "always", inline: <<-SHELL
          #  route add default gw 192.168.0.1
          #  eval `route -n | awk '{ if ($8 =="eth0" && $2 != "0.0.0.0") print "route del default gw " $2; }'`
          #SHELL
          ############## Install docker
          d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_docker.sh"
          ############## Disable swap
          d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_swap_disable.sh"
          ############## Install kubeadm
          d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_kubernetes_kubeadmn.sh"
          if i == 1 then
            ############## Kubernetes: Initialize cluster (runs on master machine)
            d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_kubernetes_cluster_init.sh"
            # Then to test networking use kub-sample-guestbook
            # git clone https://github.com/lamole73/kub-sample-guestbook.git
            # cd kub-sample-guestbook
            # kubectl create -f .
            # kubectl get all
          else
            ############## Kubernetes: Join cluster (runs on node machines)
            d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_kubernetes_cluster_join.sh"
          end
        end

        # ############## Memory and CPUs of VM
        d.vm.provider "virtualbox" do |v|
          v.memory = memArray[i]
          v.cpus = cpuArray[i]
        end

        # ############## Do NOT Synch default folder (fix problem with rsync on windows)
        d.vm.synced_folder ".", "/vagrant", disabled: true
        
        # ############## Map Synched folders (Only on manager 00)
        if i == 0 then
          # Map the folders containing ansible
          d.vm.synced_folder "#{mainfolder_relative_path}.", "/vagrant"
          #d.vm.synced_folder "#{mainfolder_relative_path}../iac-system-setup", "/vagrant/iac-system-setup"
          #d.vm.synced_folder "#{mainfolder_relative_path}../iac-system-setup-857", "/vagrant/iac-system-setup-857"
        else
          # Map the folders containing source files
          d.vm.synced_folder "#{mainfolder_relative_path}.", "/vagrant"
        end
      end
    end
  end

end
