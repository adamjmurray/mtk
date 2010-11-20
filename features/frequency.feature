Feature: Representations of Frequency
	In order to express frequency conveniently
	As a developer using this library
	I want multiple representations of frequency that can be converted to each other
	
	Scenario: Adding a Numeric and a frequency class
		When I add "42" and "100 Hertz"
		Then I should have "142 Hz"
		
	Scenario: Adding a frequency class and a Numeric
		When I add "100 Hertz" and "42"
		Then I should have "142 Hz"
		
	Scenario: Adding two frequency classes
		When I add "10 Hertz" and "69 Semitones"
		Then I should have "450 Hz"
		