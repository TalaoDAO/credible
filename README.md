![Talao header](https://github.com/TalaoDAO/talao-wallet/blob/dev-talao/Screen%20app%20store%20-%20MASTER.png)


[![](https://img.shields.io/badge/Flutter-1.22.6-blue)](https://flutter.dev/docs/get-started/install) [![](https://img.shields.io/badge/ssi-v0.3-green)](https://www.github.com/spruceid/ssi) [![](https://img.shields.io/badge/DIDKit-v0.3-green)](https://www.github.com/spruceid/didkit) [![](https://img.shields.io/badge/License-Apache--2.0-green)](https://github.com/TalaoDAO/talao-wallet/blob/dev-talao/LICENSE) 

# Talao Self Sovereign Identity mobile wallet

## Motivation 


Our ambition for this wallet is that a project team can integrate it into its application in the shortest possible time with the minimum of dependencies and whatever its environment, whether for projects carried by companies than by institutions. This ease of implementation seems to us today essential for the adoption of SSI concepts and technologies by as many people as possible.  

Our ambition is also to offer an SSI wallet adapted to the European market, taking into account the specifications that have been put forward by the EU working groups both in terms of technology and regulation. 

Finally, our project is to offer for the first time a smartphone wallet available on the Apple and Google stores which carries the identity in the format of the Tezos channel ([did: tz]( https://did-tezos-draft.spruceid.com/ )). The Tezos blockchain has many advantages for SSI, in particu projectslar that of open governance, high security and by a proof of stake consensus which makes it one of the most popular blockchains. less energy consuming in the world. This wallet allows all Tezos applications to offer their users an SSI identity to access their services.
 
## Architecture

To achieve these objectives we have opted for a design adapted to the use cases of today's SSI and based on W3C standards. The wallet exclusively supports Verifiable Credentials in JSON-LD format, the Decentralized Identifier (DIDs) standard and the Credential Status List 2020 specifications for the revocation of VCs.  

For the interaction of the wallet with Issuers and Verifiers, which is a decisive function in the implementation of this type of solution, we have retained the specifications of the [W3C Presentation Request]( https://w3c-ccg.github.io/vp-request-spec/ ) as well as the [Spruce protocol]( https://github.com/spruceid/credible#supported-protocols )  for the management of the QR Code on a HTTPS transport layer. This protocol has the advantage of being quick and easy to implement while providing most of the necessary functions. There are currently several very promising protocols that are being defined or even in production but they seem to us too complex and ultimately useless for current use cases which remain simple.


The chain of trust which is essential in all SSI models must allow the Holder with the wallet to ensure that he/she interacts with a legitimate third party by having reliable and quality sources of data. This is particularly sensitive when it comes to transferring some of the VCs from his wallet to a Verifier. Many models exist (public or private trust registers, well-known resources, etc.), it seemed important to us to be able to integrate these approaches as well as the various institutions and partners who support them in the wallet services. However, this service remains optional at the user's discretion.


The protection of the user's personal data has also been a primary concern. It resulted in the strict application of the rules of the GDPR and in particular by the use of DID formats that do not require writing on a blockchain as well as by the request for the user's agreement on certain features.


For the developments we used the [didkit sdk](https://spruceid.dev/docs/didkit/ ) from the company Spruce. The tools offered by Spruce are probably the only ones allowing in a cross-platform environment to support so many identity models and signature suites adapted to the JSON-LD format. Our work focused on a specific support for the VCs of our use cases, and the enrichment of the interaction protocol between the wallet and the Issuers and Verifiers to accommodate new ones. All of these features allow an Issuer to customize the support for their own VCs in a matter of minutes.


The wallet code is open source under the Apache license available on github. The wallet is free to download on the google and IOS stores in 5 languages. Talao provides support to all teams who wish to integrate a wallet in the ISS format in their project. A digital safe allowing the user to archive his VCs or possibly to publish them is also available on the talao.co website


## Technical characteristics 


* Developed with Flutter/Dart for Android and iOS devices,  
* Supported DIDs: did:tz, did:web, did:key; did:ethr, did: pkh, did:ion,  
* Revocation of VCs: RevocationList2020  
* SDK development environment: C, Rust, Python, NodeJS, java, Flutter, ...
* Wallet VC custom templates : voucher, loyalty cards, community card, decentralized kyc, over 18 proof, employer certificate, skills certificate, company pass, proof of email, proof of telephone, diplomas, student card, ...  
* Wallet languages: English, French, German, Spanish, Italian  

## Commercial Support

Commercial support for this wallet is available upon request from Talao: contact@talao.io
