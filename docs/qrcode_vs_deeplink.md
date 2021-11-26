# Cross device access versus smartphone viewer access

The Talao wallet makes it possible to manage the interaction with an Issuer or a Verfier through a QR Code or a deep link.
Depending on the origin of the call, we determine which device is sending the request.

## Desktop viewer

Display a QR Code in the form https: // my_endpoint? Issuer = my_did

## Smartphone viewer

Universal link behind a button (html)

the link is of the type https://app.talao.co/app/download?uri=https://my_endpoint?issuer=my_did

If the Talao wallet is not available on the smartphone, the user is referred to the page https://app.talao.co/app/download which offers him access to the Apple Store or the Google store. 
