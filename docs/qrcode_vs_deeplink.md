# Cross device access versus smartphone viewer access

The Talao wallet makes it possible to manage the interaction with an issuer or a verifier web application through a QR Code or a deeplink.

Depending on the origin of the request, we determine which device is accessing the web application.

## Access from a desktop viewer

Display a QR Code in the form of https: // my_endpoint? Issuer = my_did

## Access from smartphone viewer

Display a button link in the form of  https://app.talao.co/app/download?uri=https://my_endpoint?issuer=my_did

If the Talao wallet is not available on the smartphone, the user is referred to the page https://app.talao.co/app/download which offers him access to the Apple Store or the Google store. 
