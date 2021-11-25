Talao wallet : Behavior-driven development


Title: Create a cloud credential portfolio and request a Professional Experience Assessment to a company.




User wants to register a portfolio with his Talao wallet. So he can use it to display publicly credentials and to request new ones.  


Scenario 1 : user requests an email proof
Given  the user has a desktop
And the Talao wallet has been downloaded to his smartphone
And an identity has been generated in the wallet app
When the user connects to https://talao.co/emailpass with the desktop browser
And the user enters his email and the secret code he received by email
Then the user should be proposed to scan a QR code with his wallet app
And the user should be proposed to collect an email proof as a credential


Scenario 2 : user creates a new portfolio
Given  the user has an email proof in the wallet app 
When the user connects to https://talao.co/register  with the desktop browser
And the user scans the QR code with the wallet app
And the user selects the email proof in the credential list of the wallet app
Then the user should be requested to enter his first name and last name to complete the portfolio registration process.


Scenario 3 : user authenticates to his portfolio for the first time with his wallet app
Given the user has an email proof in his wallet app
And the user has registered an account with the same wallet app configuration 
When the user connects to https://talao.co/  with the desktop browser
And the user scans the QR code with the wallet app
And the user selects the email proof in the credential list
Then the user should log-in to his portfolio on the desktop 
And the user should see a credential named “Identity Pass” issued by Talao in his portfolio 
And the user should be able to download it to the wallet app


As an employee of “NewIndus”, the user wants to get a Professional Experience Assessment credential. So that he can store it in his wallet or display it publicly through a link on a personal website.


Scenario 1 : User requests a Professional Experience Assessment credential to his company
Given the company has opened an account with Talao to issue credentials. 
And the user has the link to request a credential to his company :  https://talao.co/login?issuer_username=newindus&vc=professionalexperienceassessment 
When the user connects to his portfolio with the desktop browser and authenticates with the wallet app
Then the user should be requested to fill a credential draft for review by his company
And the company reviews the request and approves or rejects it. 


Scenario 2 : User collects and stores a  Professional Experience Assessment credential in his wallet
Given the request has been approved by the company
And the user has received an email from his company confirming the credential issuance
When the user connects to his portfolio with the desktop and authenticates with the wallet app
Then the user should see his new credentials with a link to download it through a QR code to his wallet app.


Scenario 3 : User wants to display his credential publicly on a personal website
Given the user has his credential in his portfolio
When the user connects to his portfolio with the desktop and authenticates with the wallet app
Then the user can copy the credential link (URL) which is accessible through an icon below the credential details.