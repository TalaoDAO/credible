


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
