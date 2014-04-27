# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 et:

Vagrant.require_version ">= 1.5.1"

DOT = File.dirname(__FILE__)

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'aws'

VAGRANTFILE_API_VERSION = "2"

DOMAIN = 'cloud.ctf101.at'

AMI_VYOS = 'ami-609b7f08'
AMI_UBUNTU_1404 = 'ami-37d8c05e'
AMI_FEDORA_4 = 'ami-bbd2cad2'
AMI_WIN_2012 = 'ami-dd253db4'
AMI_FREEBSD_10 = 'ami-668a6e0e'

def loadVarsFromFile(filename)
  File.read(DOT + "/" + filename).split(/\n/).each do |line|
    var, value = line.scan(/(.*?)\=(.*)/).flatten()
    instance_variable_set("@#{var}", value.strip)
  end
  rescue 
    fail "#{filename} not found."
    exit 
end

# load aws credentials from aws rootkey.csv 
loadVarsFromFile('aws/rootkey.csv')

# load aws system configurations from prepare-aws state file.
loadVarsFromFile('aws/state')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  
  # FC4 - ~2005
  config.vm.define :t1 do |t1|
    host = 'cirrus'
    t1.vm.host_name = host + '.' + DOMAIN

    t1.vm.provider :aws do |aws, override|
      t1.vm.box = "dummy"
      t1.vm.box_url = "http://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      aws.access_key_id = @AWSAccessKeyId
      aws.secret_access_key = @AWSSecretKey
      aws.instance_type = 'm1.small'
      aws.ami = AMI_FEDORA_4
      aws.subnet_id = @WEBTIER_ID
      aws.private_ip_address = @T1_IP
      aws.elastic_ip = true
      aws.security_groups = @SECPUB_ID
      aws.tags = {
        'Name' => t1.vm.hostname,
      }

      override.ssh.username = "root"
      override.ssh.private_key_path = DOT + "/ctf2014.pem"
      t1.vm.synced_folder DOT + "/ctf101", "/ctf101"
    end
  end

  # Windows Server 2012
  config.vm.define :t2 do |t2|
    ENV['TERM'] = 'xterm'
    host = 'altocumulus'
    t2.vm.host_name = host + '.' + DOMAIN
    t2.vm.guest = :windows

    t2.vm.provider :aws do |aws, override|
      t2.vm.box = "dummy"
      t2.vm.box_url = "http://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      aws.access_key_id = @AWSAccessKeyId
      aws.secret_access_key = @AWSSecretKey
      aws.instance_type = 'm1.small'
      aws.ami = AMI_WIN_2012
      aws.subnet_id = @APPTIER_ID 
      aws.private_ip_address = @T2_IP
      aws.elastic_ip = true
      aws.security_groups = @SECPUB_ID
      aws.tags = {
        'Name' => t2.vm.hostname,
      }
      override.ssh.username = "Administrator"
      override.ssh.private_key_path = DOT + "/ctf2014-mgmt"
      t2.vm.synced_folder DOT + "/ctf101", "/ctf101"
    end
  end

  # Ubuntu 14.04 LTS - Latest
  config.vm.define :t3 do |t3|
    host = 'altostratus'
    t3.vm.host_name = host + '.' + DOMAIN

    t3.vm.provider :aws do |aws, override|
      t3.vm.box = "dummy"
      t3.vm.box_url = "http://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      aws.access_key_id = @AWSAccessKeyId
      aws.secret_access_key = @AWSSecretKey
      aws.instance_type = 'm1.small'
      aws.ami = AMI_UBUNTU_1404
      aws.subnet_id = @APPTIER_ID 
      aws.private_ip_address = @T3_IP
      aws.elastic_ip = true
      aws.security_groups = @SECPUB_ID
      aws.tags = {
        'Name' => t3.vm.hostname,
      }

      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = DOT + "/ctf2014.pem"
      t3.vm.synced_folder DOT + "/ctf101", "/ctf101"
    end
  end

  # FreeBSD 10 
  config.vm.define :t4 do |t4|
    host = 'nimbostratus'
    t4.vm.host_name = host + '.' + DOMAIN

    t4.vm.provider :aws do |aws, override|
      t4.vm.box = "dummy"
      t4.vm.box_url = "http://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      aws.instance_type = 'm1.small'
      aws.access_key_id = @AWSAccessKeyId
      aws.secret_access_key = @AWSSecretKey
      aws.ami = AMI_FREEBSD_10
      aws.subnet_id = @DATATIER_ID 
      aws.private_ip_address = @T4_IP
      aws.elastic_ip = true
      aws.security_groups = @SECPUB_ID
      aws.tags = {
        'Name' => t4.vm.hostname,
      }
      override.ssh.username = "ec2-user"
      override.ssh.private_key_path = DOT + "/ctf2014.pem"
      t4.vm.synced_folder DOT + "/ctf101", "/ctf101"
    end
  end

  # create a VPN access box
  config.vm.define :t5 do |t5|
    host = 'cumulus'
    t5.vm.host_name = host + '.' + DOMAIN

    t5.vm.provider :aws do |aws, override|
      t5.vm.box = "dummy"
      t5.vm.box_url = "http://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      aws.access_key_id = @AWSAccessKeyId
      aws.secret_access_key = @AWSSecretKey
      aws.instance_type = 't1.micro'
      aws.ami = AMI_VYOS
      aws.private_ip_address = @T0_IP
      aws.subnet_id = @MGMTTIER_ID
      aws.elastic_ip = true
      aws.security_groups = @SECPUB_ID
      aws.tags = {
        'Name' => t5.vm.hostname,
      }

      override.ssh.username = "vyos"
      override.ssh.private_key_path = DOT + "/ctf2014.pem"
    end
  end
end
