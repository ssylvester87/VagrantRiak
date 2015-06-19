require 'erb'
require 'optparse'
require 'fileutils'

if __FILE__ == $PROGRAM_NAME
  @current_path = File.dirname(__FILE__)
  unless File.file?("@current_path/Vagrantfile.erb")
    die("Please ensure that Vagrantfile.erb is in the same directory as this script.\nCurrent directory is @current_path.")
  end
  
  options = {:version => nil, :nodes => nil, :ipaddr => '192.168.56.40', :hostname => 'riakvm'}
  
  optparse = OptionParser.new do|opts|
    opts.banner = "Usage: VagrantRiak.rb [options]"
    opts.on('-r', '--riak', 'Riak Version') do |riakversion|
      options[:riakversion] = @riakversion;
    end
    opts.on('-n', '--nodes', 'Amount of nodes') do |nodes|
      options[:nodes] = @nodes;
    end
    opts.on('-i', '--ipaddr', 'Starting IP Address') do |ipaddr|
      options[:ipaddr] = @ipaddr;
    end
    opts.on('-s', '--hostname', 'Hostname') do |hostname|
      options[:hostname] = @hostname;
    end
    
    opts.on('-h', '--help', 'Print this message' ) do
      puts opts
      exit
    end
    
    parser.parse!
    
    if options[:riakversion] == nil
      print 'Enter Riak Version [2.1.1]: '
      options[:riakversion] = gets.chomp | '2.1.1'
    end
    if options[:nodes] == nil
      print 'Enter the amount of nodes to create [5]: '
      options[:nodes] = gets.chomp | '5'
    end
    
    if options[:riakversion] =~ /^(\d)\.(\d)\.(\d{1,2})$/
      @majorversion = $1
      @minorversion = $2
      @patchversion = $3
    else
      die("Please enter a valid Riak version. Format should be #.#.#, e.g. '2.1.1'.")
    end
    
    unless options[:nodes] =~ /[1-9]{1,2}/
      die("Please enter a valid amount of nodes. Should be a 1 or 2 digit nonzero number.")
    end
    
    unless options[:ipaddr] =~ /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
      die("Please enter a valid starting IP address.")
    end
    
    unless options[:hostname] =~ /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
        die("Please enter a valid hostname or leave it blank to use the default.")
    end
    
    @linuxdist = "ubuntu/trusty64"
    
    @rsyncdir = "current_path/rsync"
    
    for i in 0..(@nodes-1)
        thishost = "@hostname#{i}"
        thisip = (@ipaddr + i)
        vagrantfile_gen("@current_path/Vagrantfile.erb", @riakversion, @rsyncdir, thisip, thishost)
        
        
    end
    
    

    
  end
  


end

def vagrantfile_gen(filename, riakversion, rsyncdir, thisip, thishost)
  vmhostname = thishost
  vname = "Riak_#{thishost}"
  mem = "1024"
  template = ERB.new File.new(filename).read, nil, "%<>"
  vftext = template.result
  newdir = "@current_path/@hostname#{i}"
  FileUtils.mkdir(newdir)
  File.open("#{newdir}/Vagrantfile", 'w') { |file| file.write(vftext) }
end 


def vagrant_create()
  
end

 