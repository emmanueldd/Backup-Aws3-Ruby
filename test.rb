require 'aws-sdk'
require 'aws/s3' 

bucket_name = ''
s3 = AWS::S3.new(
  :access_key_id => '',
  :secret_access_key => ''
)
i = 0
entries = 0

  bucket = s3.buckets[bucket_name]
  bucket.objects.each do |obj|
	entries += 1
	puts obj.methods.sort
  end
  bucket.objects.each do |obj, val|
	puts "#{obj.value}"
	puts 'Original entry (from s3) : '+"#{obj.key}"
	filename = File.basename("#{obj.key}")  
	dirname = File.dirname('/users/ubuntu/home/backup_try/'+"#{obj.key}")
      	unless File.directory?(dirname)
		i += 1
		puts '['+i.to_s+'/'+entries.to_s+'] creates folder : ' + dirname
    		system 'mkdir', '-p', dirname
	end
	unless filename.index('.') == nil
		i += 1
		puts '['+i.to_s+'/'+entries.to_s+'] creates file : '+dirname+'/'+filename
		# fix me ! Be carefull, if you got files with no extensions
		unless File.exist?(dirname+'/'+filename)
			File.open(dirname+'/'+filename, "w+") do |f|
            	if f.write(obj.read)
					puts 'Success'
				else
					puts 'Fail'
				end
        	end
		else
			puts 'Already exists'
		end
	end
  end
