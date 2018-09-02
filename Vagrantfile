# -*- mode: ruby -*-
# vi: set ft=ruby :

_VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(_VAGRANTFILE_API_VERSION) do |config|

  # Relative path of main project folder from vagrant file
  vb_descr_vagrantfile_folder=File.dirname(__FILE__)
  mainfolder_relative_path = ""
  # The environment name (servers will be #{environmentname}-01 .. 04)
  environmentname="kub"
  ippattern="10.10.27.8"
  # The VirtualBox VM name prefix, actual names will be #{vboxvmname}-mgr, #{vboxvmname}-01, e.t.c.
  # set it to nil to not name the VirtualBox VMs, i.e. let vagrant give default name
  vboxvmname="#{environmentname}"
  # Change memory for each VM, make nil to not use the vm
  memArray = Array.new(4)
  memArray[0] = 512  # 512   the mgr running the ansible scripts
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
  vb_descr_notes_box="Note bento/centos-7.4 version: 201803.24.0 contains centos-7.4-x86_64, build_timestamp: 2018-03-26-16:29:04, see https://app.vagrantup.com/bento/boxes/centos-7.4/versions/201803.24.0"
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
  # Manager
  # The role of the manager is to manage other machines using ansible
  #
  if memArray[0] != nil then
    config.vm.define "mgr", primary: true do |d|
      d.vm.box = "ubuntu/trusty64"
      d.vm.box_version = ""
      d.vm.hostname = "mgr"
      d.vm.network :private_network, ip: "#{ippattern}0"
      if vboxvmname != nil then
        d.vm.provider "virtualbox" do |v|
          v.name = "#{vboxvmname}-mgr"
        end
      end
      # ############## Customize the VirtualBox description
      # Note it is always customized, i.e. after halt / up it replaces whatever is written
      d.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--description", "
## Vagrant VM definition hostname: #{d.vm.hostname}
Vagrantfile folder:
#{vb_descr_vagrantfile_folder}

## Vagrant VM using box: #{d.vm.box} version: #{d.vm.box_version}

= hostname: #{vboxvmname}-mgr, mem: #{memArray[0]} MB, CPUs: #{cpuArray[0]}
= Users: root/vagrant, vagrant/vagrant
          "]
      end
      # ############## Install ansible
      d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_ansible_ubuntu.sh"
      if install_avahi then
		  d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_avahi_ubuntu.sh"
      end
      # ############## For hostname resolution of the VMs via /etc/hosts
      d.vm.provision :shell, run: "always", inline: <<-SHELL
        for i in `seq 1 4`;
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
      # ############## Memory and CPUs of VM
      d.vm.provider "virtualbox" do |v|
        v.memory = memArray[0]
        v.cpus = cpuArray[0]
      end
      # ############## Shared folders of mgr
      # ####### iac-dms-8.5.7
      #d.vm.synced_folder "#{mainfolder_relative_path}../var-cdp-shared_857/install", "/data/repo"
      #d.vm.synced_folder "#{mainfolder_relative_path}../var-cdp-shared_857/scripts", "/data/scripts"
      #  Do NOT Synch default folder since we will sync using relative path
      d.vm.synced_folder ".", "/vagrant", disabled: true
      d.vm.synced_folder "#{mainfolder_relative_path}", "/vagrant"
      # ####### iac-system-setup-857 using DMS ansible iac-system-setup
      # #  Do NOT Synch default folder since we will sync using relative path
      # d.vm.synced_folder ".", "/vagrant", disabled: true
      # d.vm.synced_folder "#{mainfolder_relative_path}../iac-system-setup", "/vagrant/iac-system-setup"
      # d.vm.synced_folder "#{mainfolder_relative_path}../iac-system-setup-857", "/vagrant/iac-system-setup-857"
      # if shared_folders_via_vboxfs then
      #   # If using shared_folders_via_vboxfs then map as shared folder
      #   d.vm.synced_folder "#{shared_folders_via_vboxfs_localfolder}", "#{shared_folder_mount_point}"
      # end
    end
  end

  #
  # Environment VMs
  # Role depends on the number:
  # 01 is the master
  # 02 is the node 2
  # 03 is the node 3
  #
  (1..3).each do |i|
    if memArray[i] != nil then
      #
      # #i VM see memArray for which VM this is
      #
      config.vm.define "0#{i}" do |d|
        d.vm.hostname = "#{environmentname}-0#{i}"
        d.vm.network :private_network, ip: "#{ippattern}#{i}"
        if vboxvmname != nil then
          d.vm.provider "virtualbox" do |v|
            v.name = "#{vboxvmname}-0#{i}"
          end
        end
        # ############## Customize the VirtualBox description
        # Note it is always customized, i.e. after halt / up it replaces whatever is written
        d.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--description", "
## Vagrant VM definition hostname: #{d.vm.hostname}
Vagrantfile folder:
#{vb_descr_vagrantfile_folder}

## Vagrant VM using box: #{config.vm.box} version: #{config.vm.box_version}
## #{vb_descr_notes_box}

= hostname: #{vboxvmname}-0#{i}, mem: #{memArray[i]} MB, CPUs: #{cpuArray[i]}
= Users: root/1, vagrant/1, dms/dms (samba)
= Samba installed: #{install_samba}
            "]
        end
        # ############## CENTOS 7 to initiallize correctly and install guest additions
        # d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_disable_selinux.sh"
        # ############## bento centos-7.4 already has Gueest Additions installed
        # if shared_folders_via_vboxfs then
        #   d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_guestadditions_centos_redhat.sh"
        # end
        # ############## Enable remote ssh login
        # # bento centos-7.4 already has remote ssh login
        # d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_enable_ssh_login_centos.sh"
        # ############## Increase SWAP size to 2048MB or XE11G and oracle VM
        # # bento centos-7.4 already has 2 GB swap size
        # d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_increase_swap_size.sh"
        ############## Install docker
        d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_docker_centos.sh"
        ############## Disable swap
        d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_swap_disable.sh"
        ############## Install kubeadm
        d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_kubernetes_kubeadmn_centos.sh"
        # ############## For hostname resolution of the VMs
        if install_avahi then
			d.vm.provision :shell, path: "#{mainfolder_relative_path}scripts/bootstrap_avahi_centos.sh"
        end
        ############## For hostname resolution of the VMs via /etc/hosts
        d.vm.provision :shell, run: "always", inline: <<-SHELL
          for i in `seq 1 4`;
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
          yum install -y sshpass
        SHELL
        # ############## For Oracle
        # # bento centos-7.4 already has net-tools installed
        d.vm.provision :shell, inline: <<-SHELL
          yum install -y net-tools
        SHELL
        # ############## Memory and CPUs of VM
        d.vm.provider "virtualbox" do |v|
          v.memory = memArray[i]
          v.cpus = cpuArray[i]
        end
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
        # ############## Do NOT Synch default folder (fix problem with rsync on windows)
        d.vm.synced_folder ".", "/vagrant", disabled: true
      end
    end
  end

end
