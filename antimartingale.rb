
	capital = 102400

	initial_bet = 100
	bet = initial_bet
	streak = 0

	(0...1024).each { |x|
		
		win = (rand() >= 0.55)

		print win ? "W":"L"

		if win 
			capital -= bet
			bet = initial_bet
			streak = 0
		else
			capital += bet
			bet *= 2

			streak += 1
			break if streak >= 10
		end

		
	}

	puts "\n",capital
