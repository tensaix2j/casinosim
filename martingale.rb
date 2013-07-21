
def oneday
	
	money = 1000
	betamount = 2
	lastres = ""
	wincount = 0
	losecount = 0 
	
	(0..2000).each do
		
		|turn|
		
		if money > 0 
		
			spin = rand(3)
			betcolor = rand(3)
			
			
			if lastres == "L"
				
				betamount *= 2
				
				#if betamount > 8
				#	betamount = 2
				#end
			else
				betamount = 2
			end
			
		
			if spin != betcolor
		
				money += betamount/2
				puts "#{spin} #{betcolor} W  Bet: #{betamount} Money: #{money}  Wincount #{wincount} losecount #{losecount}"
				lastres = "W"
				wincount += 1
			else
		
				money -= betamount
				puts "#{spin} #{betcolor} L Bet: #{betamount} Money: #{money} Wincount #{wincount} losecount #{losecount}"
				lastres = "L"
				losecount += 1
				
			end
		
		end
	end
	
	return money
end


daywincount = 0
(0..1).each do
	res = oneday
	puts "This day #{res}"
	if res > 100
		daywincount += 1
	end
end

puts daywincount

