	
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
		"-stdev" => 0.05,
		"-skip" => 10
	}

	$config = $config.merge( Hash[*ARGV] )


	luck_arr = []
	streaklen_cnt = {}

	while luck_arr.length < 100000
		
		if $config["-dist"] == "normal"
			streaklen = ( gaussian( 1, $config["-stdev"].to_f , lambda { Kernel.rand } )[0] * 100 - 99 ).abs.round 
		else
			streaklen = rand(100)
		end	

		streaklen = 1 if streaklen == 0
		streaklen_cnt[ streaklen ] = 0 if streaklen_cnt[ streaklen ] == nil
		streaklen_cnt[ streaklen ] += 1


		luck = rand(2)
		(0...streaklen).each { |i|
			luck_arr << luck
		}	
	end

	

	# 0: Luckstreak strat
	# 1: Martingale
	# 2: Flat Bet 
	# 3: Staged Luckstreak

	label 				= ["Flat LS", "Martingale", "Flat Bet", "Staged LS"]
	capital 			= [ 100 , 100 , 100 , 100 ]
	bet 				= [ 1, 1, 1 , 1]
	alive 				= [ 1, 1, 1 , 1]
	skip 				= [ 0, 0, 0 , 0]
	skip_trigger		= [ $config["-skip"].to_i ] * skip.length

	
	(0...luck_arr.length).each { |i|

		(0..3).each { | profile|

			if alive[profile] == 1

				# Luck streak strat
				if profile == 0
						
					if skip[profile] <= 0 
						if luck_arr[i] == 1
							capital[profile] += bet[profile]
						else
							capital[profile] -= bet[profile]
							skip[profile] = skip_trigger[profile]
						end
					else
						skip[profile] -= 1
					end
				
				# Martingale strat
				elsif profile == 1

					if luck_arr[i] == 1
						capital[profile] += bet[profile]
						bet[profile]    =  1	
					else
						capital[profile] -= bet[profile]
						bet[profile]     *= 2
					end	
				
				# Flat bet strat
				elsif profile == 2

					if luck_arr[i] == 1
						capital[profile] += bet[profile]
					else
						capital[profile] -= bet[profile]
					end	


				# Staged	
				elsif  profile == 3
					

					if skip[profile] <= 0 

						bet[profile] = capital[profile] / 50
						if luck_arr[i] == 1
							capital[profile] += bet[profile]
						else
							capital[profile] -= bet[profile]
							skip[profile] = skip_trigger[profile]
						end
					else
						skip[profile] -= 1
					end			

				end
				
				alive[profile] = 0 if capital[profile] <= 0 
				
			end
		}

	}

	capital.each_index { |cap_i |

		cap = capital[ cap_i ]
		lbl = label[ cap_i ]
		
		puts "Capital #{lbl} #{cap}"

	}

	puts "\nStreak Length Distribution"
	p streaklen_cnt