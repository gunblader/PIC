# PIC - Alpha Release

GROUP 3 README
						
Contributions:
						
Paul Bass: 35%
- Initial App Flow/Layout
- Some of the Login screen
- Settings screen
- Learning the heroku API and setting up the backend database for Final Product
						
Erica Halpern: 45%
- UI Design of Entire App
- Core Data Models
- Implemented card creation and view
					
Christopher Komplin: 20%
- Some of the Login screen
- Working on the Drawing functionality which is essential to Final Product
		
				
Differences:
						
- App Setting page and elements are present but functionalities that are dependent on future features will come in later releases.
- Changed card creation flow to be more user friendly

Notes:
- Just incase you do not want to login to our app with Facebook, we made a convenient and temporary “bypass login” button so you can jump right into our app!
 

*****************************************************************************************************************************
An iOS applicaion 

General Description: 
  PIC allows you to put anything on a flash card — drawing, words, symbols, you name it! Cards can be used to study on the go. You will have access to self created flashcards, anywhere you have access to you phone or tablet. 
  Create flashcards based on anything! You can even draw on these flashcards. Use your finger to draw anything from language characters to sports formations. 

 Feature List

Login/Registration Screen
  This feature enables the user to create an account and login with it.
    - Create username and password
    - Login box

Configuration/settings Screen
  Through this screen, users can manage their account credentials, profile, and view settings for viewing flash-cards.
    - Edit Username
    - Edit Password
    - Color FlashCard
    - Color of Text
    - Set Flashcard to public/private?
  - Profile
    - Picture
    - Name

Add new Flashcard set
  Users can create a new flashcard set, giving it a name a description. Following this creation, they can add flashcards to the set and define each card’s front and back.
  - Set Title and Description
    - Front: Text
    - Back: Text or Draw 
  - List of cards
    - Card
    - Front Content
    - Back Content
  - Search for Flashcard sets by Title
    A search bar will enable a user to search for a flashcard set by its title.

Basic Mode
  Through “basic mode” users can move through the deck of flashcards. They are able to flip between viewing the front and back of the card.
    - Flip card on tap
    - Show both sides

Learn mode
  “Learn mode” shuffles the cards in a set. It presents the user with one side of the card and space for the user to input their answer, whether that be text or a drawing. If the input was text, then the answer is validated. If the input was a drawing, the user’s answer is juxtaposed with the correct answer.
      - Add Shuffle button
    - Drawing screen
      - Pen size
      - Erase
      - Undo
      - Quit button
      - Show Answer and Guess in one View
Advanced Search Content
  Through advanced search (a v2 of basic search), searches will also return results where an individual card’s content matches a search query.

Share Flashcard set with Friends
  This feature lets the user invite friends to view their sets and add them to yours if you want.

Add friend button
  - Search registered users

Ability to Tag a Flashcard
  Users can tag a specific flashcard. This could help them determine important or more challenging cards. 

Tag button
  Toggle view of only starred cards in both basic and learn modes

