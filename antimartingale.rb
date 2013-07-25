
	capital = 40

	initial_bet = 0.1
	bet = initial_bet
	streak = 0
	maxstreak = 5

	(0...1024).each { |x|
		
		win = (rand() >= 0.55)

		print win ? "W":"L"

		if win 
			capital += bet
			bet *= 2
			streak += 1
			break if streak >= maxstreak
		
		else
			capital -= bet
			bet = initial_bet

			streak = 0
		end

		
	}

	puts "\n",capital


