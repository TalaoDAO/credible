# Interaction between the wallet and an Issuer / Verifier

## Definition

Wallet (user wallet) : Most often it is a smartphone application in which we can keep certificates (driving license, identity card, bank cards, loyalty cards, diplomas, etc.) in the form of electronic documents.

Verifiable Credential (VC) : A “Verifiable Credential” is a digitally signed electronic document. VCs make it possible to prove a competence, a title, a capacity, a quality… and most often give rights of access. Ultimately, it is these credentials that constitute our identity in internet transactions. The digital version of a driver's license, a bank card, a diploma, a loyalty card, an employer certificate or even a car key are credentials.

Verifiable Presentation (VP): a Verifiable Presentation is made up of one or more VCs which are countersigned by the wallet user. This makes it possible in particular to prove to the verifier that the subject of the VCs is indeed the user.

Issuer : A private company, an organization or an institution which issues VCs. It maybe a person in some very specific use cases. 

Verfier : A private company, an organization or an institution which requests a VP to provide users with an authorization to access resources or services. Most of the time a verifier is a website but a physical access control to enter offices may also be a verifier. A natural person could be a verifier in some use cases.  

DID : DID is the acronym for Decentralized Identifier. It's a new generation of identifiers that have the property of being unique, that you can create yourself on your smartphone and whose possession you can electronically prove. Technically, a DID is an association between an algorithm and a trusted register (blockchain, server network, ...). For each DID, we have a private electronic signature key in our wallet which allows us to prove this DID to a third party by signing a message. 

## Context

For the interaction of the wallet with Issuers and Verifier, which is a decisive function in the implementation of this type of solution, we have retained the specifications of the W3C Presentation Request as well as the Spruce protocol for the management of the QR Code on a HTTPS transport layer. This protocol has the advantage of being quick and easy to implement while providing most of the necessary functions. There are currently several very promising protocols that are being defined or even in production but these seemed to us too complex and ultimately unnecessary for the current use cases which remain simple.

This protocol is described by Spruce: https://github.com/spruceid/credible#supported-protocols. Talao has slightly modified this protocol to adapt it to its own use cases (business logic, governance requirements, etc.). 

This protocol occurs when a user wishes to use his wallet to collect credentials or use them to access resources. 

## Collecting a Verifiable Credential (VC)

When the user wants to collect VCs, it is very likely that he will access this service after a first authentication. The wallet protocol does not automatically integrate this first authentication. The user must either authenticate with a pre-existing means of authentication (login / password, openID Connect, ...) or possibly use a VC already collected to introduce himself. This process will be used for most of the VCs to be collected such as the identity card, a professional certificate, an electronic bank card, a membership card,…. However, there are special cases where the sender collects information in an anonymous session just before issuing a VC. This is the case of proof of email, phone, .... 
 
This VCs collection protocol called Credential Offer is as follows: the issuer displays a QR code (or sends an email with a deep link) which indicates a service URL to which its own DID is added. The wallet requests authorization to the user to access the URL possibly by retrieving information about the issuer from a trusted registry. 

If the user agrees, the issuer transfers a “preview” of the VC with presentation data (color, name, description, etc.) as well as an expiry date of the offer. If the user accepts the proposal, the wallet transfers the DID to the issuer who signs the VC and transfers it to the wallet. 

This protocol is carried by a GET request and a POST request on the URL indicated in the QRCode.

## Requesting a Verifiable Presentation (VP)

The presentation of a VC or without any VC can be used for authentication or to request very specific and different services as submit a file, open a bank account, buy online ...

Authentication without VC consists of transferring an empty but signed VP. It is only possible if the verifier already has knowledge of the user's DID, therefore after prior enrollment. 

Authentication with a VC can be used on the first interaction between the user and the verifier. The verifier will be able to specify his request by giving the type of VC expected, or the desired issuer, JSON-LD scheme,.. etc. The verifier will then proceed to check the signatures of the user and the issuers, possibly using a trusted register.  

This protocol called Presentation Request is as follows: the verifier displays a QR code which indicates a service URL to which its own DID is added. The wallet requests authorization to the user to access the URL possibly by retrieving information about the verifier from a trusted registry. Verifying the identity of the verifier is critical to prevent the user from disclosing personal data to untrusted websites.

If the user agrees, the sender transfers his request specifying the type of VC expected. In the case of authentication by DID, the user can accept and send his empty presentation, in the case of a request from particular VCs, the wallet offers the user to select the VCs he wishes to add to his presentation. The list of VCs offered to the user is produced on the basis of the criteria of the verifier's request.

## Verification of the identity of Issuer / Verifier 

### Motivation
The protocol of interaction between the wallet and an Issuer or a Verifier currently used by Credible is light, simple and quick to implement, However it does not allow the user of the wallet to ensure the identity of the other party but only the domain name specified in the URL encoded in the QR Code. On the other hand, a simple solution based on access to a public register of Issuers / Verifier makes it possible to obtain more information for the user and therefore better control without considerably increasing the complexity of the protocol. However hhis service must be considered as optional due to correlation issues.

### Issuer / Verifier implementation
The Issuer (or Verifier) DID is passed as an argument in the QRcode callback URL.

example : https://talao.co/....?issuer=did:ethr:0xee09654eedaa79429f8d216fa51a129db0f72250).

### Issuer Rergistry implementation
It may be necessary to create a registry or another means to store information about the Issuer and to define an API allowing access with a DID on behalf of the Issuer and its callback URL. There are several solutions to implement this service (see EBSI frameworkk, ToIP gov stack, well-known LinkedDomains,...), to keep it simple we will use a public gateway : https://talao.co/trusted-issuers-registry/v1/issuers/<DID> 

Example :
    
GET https://talao.co/trusted-issuers-registry/v1/issuers/did:ethr:0xee09654eedaa79429f8d216fa51a129db0f72250 

JSON response:
```javascript
{
    "issuer": {
        "preferredName": "Talao",
        "did": [did:ethr:0xee09654eedaa79429f8d216fa51a129db0f72250, "did:ebsi:00005555"],
        "organizationInfo": {
            "id": "BE55555j",
            "legalName": "Talao SAS",
            "currentAddress": "Talao, 16 rue de Wattignies, 75012 Paris, France",
            "website": "https://talao.co",
            "issuerDomain : "["talao.co", "talao.io"]
        }
    }
}
```

### Wallet implementation
This is an advanced service option with privacy issues (correlation). It is requested to be added in the wallet setting menu as an option (default is on).

If option is "on" wallet makes a call to the gateway API with the DID associated with the QRCode “issuer” argument to read the Issuer details from the registry. The wallet checks that the QRCode domain is in the "issuerDomain" list, if this is the case it adds Issuer data to the access confirmation request message. If this is not the case or if there is no register available, it indicates that the name of the Issuer cannot not be obtained and verified and the user alert message remains as it is ("Do you trust the domain...").

# credentialOffer

## Motivation

For holders wishes to engage with Issuers to acquire credentials, there must exist a mechanism for assessing what inputs are required from an issuer to process a request for credential issuance. A manifest is a common data format for describing the inputs a user must provide to an Issuer and the way the VCs shopuild be presented. This draft has been inpired by the Credential Manfifest specification with a very limited implementations of 2 items :

- user inputs : For some VCs it is necessary to transfer the personal data of the user's profile to the Issuer. This information is accessible in the menu Profile of the wallet. These are: the user's last name, first name, telephone, address and email.
- display output descriptors as labels (name, description) et templates objetcs (icon, color,...).
- share link : a way to use the wallet to link to a cloud service (vault, etc).

## Issuer implementation
Currently (Credible 0.1) when the wallet makes a GET to the Issuer endpoint, a JSON is returned to the wallet (Issuer GET response):

```javascript
{
           "type": "CredentialOffer",
           "credentialPreview": {...},
           "expires" : 12/08/2021Z "
 })
```

after agreement from the user, the wallet makes a POST request with a JSON:

```javascript
{
           “Subject_id”, ”did:tz:tz1e5YakmACgZZprF7YWHMqnSvcWVXZ2TsPW”,
}
```

The modification consists in adding a “scope” attribute and a "display" attribute to the JSON returned by the Issuer (Issuer GET response).

The “scope” attribute is a list with at least the “subject_id” item and possibly other items from the following list: “givenName”, “familyName”, “telephone”, “email”, “address”.
 
The "shareLink" attribute is an URL


example:

```javascript
{
           "type": "CredentialOffer",
           "credentialPreview": {...},
           "expires" : 12/08/2021Z ",
           "scope ": [“ subject_id ”,“ familyName ”,“ givenName ”],
           "shareLink" : "https://talao.co/shareLink"
}
```

The "display" attribute is a description of the Issuer expectations about the UI design of the VC.

example:

```javascript
{
           "type": "CredentialOffer",
           "credentialPreview": {...},
           "expires" : 12/08/2021Z ",
           "scope ": [“ subject_id ”,“ familyName ”,“ givenName ”],
           "display" : { "backgroundColor : "#efefef",
                        "icon" : "Flutter icon reference",
                        "nameFallback" : "By default this is the name of the VC",
                        "descriptionFallback" : "By default this is the description of the VC."
                        }
                       
}
```

## Wallet implementation
If there are items other than“ subject_id ”, the actions of the wallet will be:
1. ask the user for consent to transfer their personal data (a “consent screen”)
2. add the attributes and their value saved in the wallet to the JSON (wallet POST request), in our example:

```javascript
{
           “Subject_id”, ”did: tz: tz1e5YakmACgZZprF7YWHMqnSvcWVXZ2TsPW”,
            “familyName”: “Doe”,
            “givenName”: “John”
}
```

In the event that an attribute is missing in the wallet profile it would be replaced by “”.

For display descriptors : "name" and "description" fallback will ne used if any attribute "name" or "description" exists in the VC. There is no internationalization support for those attributes. See "icon" and "color" values in examples. 

See https://talao.co/wallet/test/credentialOffer for testing.

# presentationRequest Query types

## Motivation

When interacting with a Verifier it is likely that it wants to get a presentation made up of specific VCs. It is therefore necessary to be able to specify to the wallet the conditions to be applied to the choice of VCs. The following specifications are taken from a minimalist interpretation of the draft  https://w3c-ccg.github.io/vp-request-spec/#query-by-example 

## Verifier implementation

There are 2 possibilities to foresee for the value of query.type of the JSON of the GET response of the Verify (“DIDAuth” or “QueryByExample”):

```javascript
{
           "type": "VerifiablePresentationRequest",
           "query": [{
               "type": “DIDAuth”
               }],
           "challenge": "a random uri",
           "domain" : "talao.co"
}
```

or: 


```javascript
{
           "type": "VerifiablePresentationRequest",
           "query": [{
               "type": "QueryByExample",
               "credentialQuery": [
                   {
                    ……
                   }]
               }],
           "challenge": "a random uri",
           "domain" : "talao.co"
 }
```

## Wallet implementation

### DIDAuth

If Query.type = “DIDAuth” , then it is a basic authentication request that does not include a verifiable credential : there is no selection of credential to propose to the user, call the function didkit.DIDAuth(did, “{“ challenge ”:“ .... ”,“ domain ”:“ ..... ”}”, key) which will create an empty presentation used only for authentication. The presentation passed with the POST request will look like this:

```javascript
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1"
  ],
  "type": "VerifiablePresentation",
  "proof": {
    "type": "EcdsaSecp256k1Signature2019",
    "created": "2021-08-28T16: 13: 23.740Z",
    “challenge”: “d602e96d-08cb-11ec-a6fa-8d5c53eaebfb",
    “domain”: “talao.co”
    "jws ":" eyJhbGciOiJFUzI1NksiLCJjcml0IjpbImI2NCJdLCJiNjQiOmZhbHNlfQ..PgpEElB1tvcY9tdzK6EDKLvysj3vcH-zg5EIiGpk_q4m0NrAmjA81B7QdVvKllSzzfKw-1oTJuu4b4ihCvMXRwA
  "},
  "holder": "did:ethr:0xee09654eedaa79429f8d216fa51a129db0f72250"
}
```

If Query.type ="QueryByExample "then it will take the user selects credentials in a list constituted according to the criteria specified in "credentialQuery.example". Then it will be necessary to call the didkit.issuePresentation (...) function as what is currently done (there is no change in the function call). Refer to https://w3c-ccg.github.io/vp-request-spec/#query-by-example for more information.
    
# presentationRequest QueryByExample
    
## Wallet implementation

If "credentialQuery": is an empty list, one keeps the current behavior of Credible. The user is asked to select credentials to send. Never mind the VCs.

If "credentialQuery.example" contains {"reason": [......]}
then the Verifier wishes to display an information message to the user. This message will be displayed on the wallet at the time of selection.

If "credentialQuery.example" contains {"type": "some_type"}
then the Verifier wishes to receive VCs conforming to the specified type and the wallet presents a list of VCs consisting only of the specified type.

If "credentialQueryexample" contains { "trustedIssuer" : ["un_issuer", “un_autre_issuer”, ...]}
then the Verifier wishes to receive VCs sent by the specified Issuers and the wallet presents a list consisting only of the specified issuers.

Nota Bene : 
- There is one credentialQuery.example for each type of VC requested
- By default the credential is required ("required" : "True"), it does not support the other option.
- The reason attribute should be analysed as an array of different languages ("fr", "en", ...) 

### QBE Examples

#### Example 1
Verifier requests VCs issued by did:tz:tz2NQkPq3FFA3zGAyG8kLcWatGbeXpHMu7yk:

```javascript
{
    "type": "VerifiablePresentationRequest",
    "query": [
        {
            "type": "QueryByExample",
            "credentialQuery": [
                {
                    "example" : {
                        "trustedIssuer": [
                            {
                                "issuer" : "did:tz:tz2NQkPq3FFA3zGAyG8kLcWatGbeXpHMu7yk"
                            }
                        ]
                    }
                }
            ]
        }
    ],
    "challenge": "9d0927c1-08cb-11ec-a6fa-8d5c53eaebfb",
    "domain": "talao.co"
}
```


#### Example 2
Verifier requests a ResidentCard:

```javascript
{
    "type": "VerifiablePresentationRequest",
    "query": [
        {
            "type": "QueryByExample",
            "credentialQuery": [
                {
                    "example" : {
                        "type" : "ResidentCard"
                    }
                }
            ]
        }
    ],
    "challenge": "9d0927c1-08cb-11ec-a6fa-8d5c53eaebfb",
    "domain": "talao.co"
}
```

#### Example 3
Verifier requests a ResidentCard and a DriverLicense and attaches messages for user :

```javascript
{
    "type": "VerifiablePresentationRequest",
    "query": [
        {
            "type": "QueryByExample",
            "credentialQuery": [
                {
                    "reason": [
                        {
                            "@language": "en",
                            "@value": "Join a resident card"
                        },
                        {
                            "@language": "fr",
                            "@value": "Joindre une carte de résidence"
                        }
                    ],
                    "example" : {
                        "type" : "ResidentCard"
                    }
                },
                {
                    "reason": [
                        {
                            "@language": "en",
                            "@value": "Join a driver license"
                        },
                        {
                            "@language": "fr",
                            "@value": "Joindre un permis de conduire"
                        }
                    ],
                    "example" : {
                        "type" : "DriverLicense"
                    }
                }
            ]
        }
    ],
    "challenge": "9d0927c1-08cb-11ec-a6fa-8d5c53eaebfb",
    "domain": "talao.co"
}

```

#### Example 4
Verifier attaches messages for user but no credential criters :

```javascript
{
    "type": "VerifiablePresentationRequest",
    "query": [
        {
            "type": "QueryByExample",
            "credentialQuery": [
                {
                    "reason": [
                        {
                            "@language": "en",
                            "@value": "Join a resident card and your driver license"
                        },
                        {
                            "@language": "fr",
                            "@value": "Joindre une carte de résidence et votre permis de conduire"
                        }
                    ]
                }
            ]
        }
    ],
    "challenge": "9d0927c1-08cb-11ec-a6fa-8d5c53eaebfb",
    "domain": "talao.co"
}

```

See https://talao.co/wallet/test/presentationRequest for simulation and testing.