require 'ffaker'
require 'digest/sha1'

users = []
User.destroy_all
10.times do 
  begin
    users << User.create!({ 
      username: Faker::Name.first_name, 
      oauth_user_id: Digest::SHA1.hexdigest((Time.now.to_f * 1000).to_i.to_s)
    })
  rescue; end
end

device_types = %W( WinRT, iOS Android Cloud Win32 )

devices = []
Device.destroy_all
30.times do |i|
  begin
    user = users[rand(users.size)]
    
    device = Device.create!({
      name: Faker::Product.product_name,
      platform: device_types[rand(device_types.size)],
      user_id: user.id,
      nonce: Faker::Lorem.word,
      uuid: "device_#{i}",
      password: "device_#{i}"
    })

    device.uuid = "device_#{i}"
    device.password = "device_#{i}"
    
    device.save
    
    devices << device
  rescue; end
end

def random_range(list)
  _begin = rand(list.size)
  _end = rand(_begin..list.size)

  # Returns a range
  _begin.._end
end

curl -v 
  -H "Accept: application/json" 
  -H "Host: ${HOST}" 
  -H "Authorization: Base OTUxYjQzMjEtOTU3MC01MDYyLTlmMGEtNDk3N2Y5NDg1ODY4Ojk0OTM3OWQxLTNhYTQtNWVmNS04OWQ2LWY1MTczYTE2Mzg4NQ==" 
  -F "filename=@/home/ubuntu/pony.jpg" 
  -X POST 
  -F "source_device=951b4321-9570-5062-9f0a-4977f9485868" 
  -F "destination_devices=8ffde5c6-0651-5ad9-a047-c86e75cd26b5,a21a4c6a-4323-5684-851c-f264e45901f6,304152ba-19d6-5324-9ee1-889177af57f7" 
  -F "purpose=share" 
  -F "message=I wanna share this picture of a poney with you" http://${SERVER}/files

Action.destroy_all
20.times do 
  next if devices.empty?
  source_device = devices[ rand(devices.size) ]
  range = random_range( devices.reject{ |d| d.uuid === source_device.uuid } )
  selected_devices = devices[ range ]
  
  payload = "/Pictures/SomeFolder"
  destination_devices = selected_devices.map(&:uuid).join(",")
  purpose = "BrowseDir"
  
  Action.create!({
    source_device: source_device.uuid, 
    destination_device: destination_devices, 
    payload: payload,
    purpose: purpose,
    message: Faker::Lorem.words
  })
end
