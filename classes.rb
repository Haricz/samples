class String
  
  def ip_tobinary
    a = "" 
	ip = self.split(".")
	ip.each { | x | a << "%08b" % x.to_i}
	return a
  end
  
  def binary_toip
  	a = ""
	ip = self.scan(/......../)
	ip.each {|x| a << x.to_i(2).to_s + "."}
	return a[0...-1]
  end

  def valid?
    index = 0
	flag = 0
	count = self.count "."
	ip = ""

	if count== 3
	  ip = self.split(".")
		
	  while index < 4
        if ip[index].to_i > 255
		  flag += 1
		end
		  index += 1
	  end
      
      if flag == 0 
	    return true
	  end
	end	   
     return false
   end

end

def iprange_tolist(iprange)
  iplist = []
  min = iprange[0].to_i(2)
  max = iprange[1].to_i(2)
  temp = (min..max).to_a
  temp.each { | x | iplist << "%08b" % x }
  return iplist
end

def IPtoCIDR(iplist)
  cidrlist = []
  cidr_x = 0
  cidr_y = 0

  ip1 = ""
  ip2 = ""

  index = 0
  counter = 0

  length = iplist.length


  while index < length
    if iplist[index][-4..-1].to_i == 0 
      counter = index
      ip1 = iplist[index]
        while index <= counter + 7 && index < length
          index += 1          
        end
      ip2 = iplist[index] 
      cidrlist << getprefix(ip1, ip2)

    elsif iplist[index][-4..-1].to_i == 1
    	ip1 = iplist[index]
    	puts "I'm here"
        cidrlist << getprefix(ip1,ip1)
        index += 1
      

    elsif iplist[index][-4..-1].to_i == 10
  	  if index + 1 < length &&  iplist[index + 1][-4..-1].to_i == 11
  	  	ip1 = iplist[index]
  	  	ip2 = iplist[index + 1]
  	  	cidrlist << getprefix(ip1, ip2)
  	    index += 2
  	  else
  	  	ip1 = iplist[index]
  	    cidrlist << getprefix(ip1, ip1)
  	    index += 1
  	  end

  	elsif iplist[index][-4..-1].to_i == 11
  	  ip1 = iplist[index]
  	  cidrlist << getprefix(ip1, ip1)
  	  index += 1  		
    end   
    counter = 0
  end  
  return cidrlist
end

def getprefix(ip1, ip2)
  a = ip1
  b = ip2

  if ip1 == ip2
  	prefix = 32
  else
  	xor = (a.to_i(2) ^ b.to_i(2)).to_s(2) 
  	prefix = 32 - xor.length
  end
  return prefix
end


input_count = 0
user_input = ""
iprange = []
iplist = []
cidrlist = []

while input_count < 2 

  case 
  when input_count == 0  	
    print "Input minimum IP Address: "
    user_input = gets.chomp
  when input_count == 1
  	print  "Input maximum IP Address: "  
  	user_input = gets.chomp
  end
  STDOUT.flush
  input_count += 1

  if user_input.valid? == false
    input_count -= 1
  	p "Please input a valid IP Address"
  else
    iprange << user_input.ip_tobinary
  end
end

iplist = iprange_tolist(iprange)
print iplist
cidrlist = IPtoCIDR(iplist)

puts cidrlist

