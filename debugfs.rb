
require 'net/ssh'
require 'digest/md5'

host = "192.168.1.228"
username = "root"
password = "123456"
vm_dir = "/opt/stack/data/nova/instances/"
vm_id = "a4e8fd14-8ae9-4060-9034-6fb82dc5b819"
main_disk = "/dev/sda1"

# 通过start方法链接到远程主机
session = Net::SSH.start(host,username,:password => password) do |ssh|

# debugfs得到disk前三个块的值
  result1 = ssh.exec!('echo "blocks '+ vm_dir + vm_id +'/disk"|debugfs /dev/sda1')
  puts "************"
  tmp = result1.split(" ")
  # tmp[8]是第一个块号
  puts tmp[8], tmp[9], tmp[10]
  puts "************"
  # 写数据库存tmp[8],tmp[9],tmp[10]
  result2 = ssh.exec!('a='+ tmp[8] +'; echo "block_dump ${a}"|debugfs /dev/sda1')
  puts Digest::MD5.hexdigest(result2)
  #MD5.hexdigest(result2)

  result2 = ssh.exec!('a='+ tmp[9] +'; echo "block_dump ${a}"|debugfs /dev/sda1')
  puts Digest::MD5.hexdigest(result2)

  result2 = ssh.exec!('a='+ tmp[10] +'; echo "block_dump ${a}"|debugfs /dev/sda1')
  puts Digest::MD5.hexdigest(result2)

  #result2 = ssh.exec!("debugfs " + main_disk + ";")
  #puts result2
  #result3 = ssh.exec!(" blocks " + vm_dir + vm_id + "/disk.info|") 
  #puts result3

end
