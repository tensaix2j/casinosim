	
	def gaussian(mean, stddev, rand)
	
		theta = 2 * Math::PI * rand.call
		rho = Math.sqrt(-2 * Math.log(1 - rand.call))
		scale = stddev * rho
		x = mean + scale * Math.cos(theta)
		y = mean + scale * Math.sin(theta)
		return x, y
	
	end



	$config = {
		"-dist" => "normal",
		"-stdev" => 0.12
	}

	$config = $config.merge( Hash[*ARGV] )


	luck_arr = []

	while luck_arr.length < 100000
		
		# If length of all luck streaks are equally distributed.
		if $config["-dist"] == "normal"
			streaklen = ( gaussian( 1, $config["-stdev"].to_f , lambda { Kernel.rand } )[0] * 100 - 99 ).abs.round 
		else
			streaklen = rand(100)
		end	


		luck = rand(2)
		(0...streaklen).each { |i|
			luck_arr << luck
		}	
	end

	capital = 100
	skip = 0

	(0...luck_arr.length).each { |i|

		if skip <= 0 
			bet = 1
			if luck_arr[i] == 1
				capital += bet
			else
				capital -= bet
				skip = 10
			end
		else
			skip -= 1
		end

		if capital <= 0 
			break
		end		

	}

	puts capital
