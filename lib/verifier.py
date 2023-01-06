import requests
import json
from urllib.parse import parse_qs, urlparse
from jwcrypto import jwk, jwt, jws
from datetime import datetime

# EBSI confiormance header
conformance = "36c751ad-7c32-4baa-ab5c-2a303aad548f"

# wallet keys
KEY_DICT = {"crv":"P-256",
            "d":"ZpntMmvHtDxw6przKSJY-zOHMrEZd8C47D3yuqAsqrw",
            "kty":"EC",
            "x":"NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM",
            "y":"UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE"}

PUBLIC_KEY =  {"crv":"P-256",
            "kty":"EC",
            "x":"NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM",
            "y":"UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE"}

DID =  "did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya"
KID =  "did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya#lD7U7tcVLZWmqECJYRyGeLnDcU4ETX3reBN3Zdd0iTU"

# le credential obtenu dans le test précédent
credential = {'format': 'jwt_vc', 'credential': 'eyJhbGciOiJFUzI1NksiLCJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6ZWJzaTp6Y2Zjd0dqTEJvamN6dzl5aG1VRkUzWiNrZXlzLTEifQ.eyJqdGkiOiJ1cm46ZGlkOjMwZTY5NjM1LTRmMDAtNGZjYi1hYzU2LWIzZTA0YTYxNDBjNSIsInN1YiI6ImRpZDplYnNpOnptU0tlZjZ6UVpEQzY2TXBwS0xIb3U5ekN3allFNEZ3YXI3TlNWeTJjN2F5YSIsImlzcyI6ImRpZDplYnNpOnpjZmN3R2pMQm9qY3p3OXlobVVGRTNaIiwibmJmIjoxNjcxNTQ2MzIyLCJpYXQiOjE2NzE1NDYzMjIsInZjIjp7IkBjb250ZXh0IjpbImh0dHBzOi8vd3d3LnczLm9yZy8yMDE4L2NyZWRlbnRpYWxzL3YxIl0sImlkIjoidXJuOmRpZDozMGU2OTYzNS00ZjAwLTRmY2ItYWM1Ni1iM2UwNGE2MTQwYzUiLCJ0eXBlIjpbIlZlcmlmaWFibGVDcmVkZW50aWFsIiwiVmVyaWZpYWJsZUF0dGVzdGF0aW9uIiwiVmVyaWZpYWJsZUlkIl0sImlzc3VlciI6ImRpZDplYnNpOnpjZmN3R2pMQm9qY3p3OXlobVVGRTNaIiwiaXNzdWFuY2VEYXRlIjoiMjAyMi0xMi0yMFQxNDoyNToyMloiLCJ2YWxpZEZyb20iOiIyMDIyLTEyLTIwVDE0OjI1OjIyWiIsImlzc3VlZCI6IjIwMjItMTItMjBUMTQ6MjU6MjJaIiwiY3JlZGVudGlhbFN1YmplY3QiOnsiaWQiOiJkaWQ6ZWJzaTp6bVNLZWY2elFaREM2Nk1wcEtMSG91OXpDd2pZRTRGd2FyN05TVnkyYzdheWEiLCJwZXJzb25hbElkZW50aWZpZXIiOiJJVC9ERS8xMjM0IiwiZmFtaWx5TmFtZSI6IkNhc3RhZmlvcmkiLCJmaXJzdE5hbWUiOiJCaWFuY2EiLCJkYXRlT2ZCaXJ0aCI6IjE5MzAtMTAtMDEifSwiY3JlZGVudGlhbFNjaGVtYSI6eyJpZCI6Imh0dHBzOi8vYXBpLWNvbmZvcm1hbmNlLmVic2kuZXUvdHJ1c3RlZC1zY2hlbWFzLXJlZ2lzdHJ5L3YyL3NjaGVtYXMvejIyWkFNZFF0Tkx3aTUxVDJ2ZFpYR0daYVl5anJzdVAxeXpXeVhaaXJDQUh2IiwidHlwZSI6IkZ1bGxKc29uU2NoZW1hVmFsaWRhdG9yMjAyMSJ9fX0.cJCjp6wctr7T-_IHkPtR0_PIUDKYU_jKCciQtE35hXAyDgLlsoxvteQEUYAlLHn864f5Dr6N-w0zXyCMA_81Pg', 'c_nonce': 'c9b97232364ac2a68915', 'c_nonce_expires_in': 900}
token = credential['credential']
a = jws.JWS()
a.deserialize(token)
payload = json.loads(a.__dict__['objects']['payload'].decode())
audience = payload['iss']

# qrcode lu sur le web de test de l'EBSI
qrcode ="openid://?scope=openid&response_type=id_token&client_id=https%3A%2F%2Fapi-conformance.ebsi.eu%2Fconformance%2Fv2%2Fverifier-mock%2Fauthentication-responses&redirect_uri=https%3A%2F%2Fapi-conformance.ebsi.eu%2Fconformance%2Fv2%2Fverifier-mock%2Fauthentication-responses&claims=%7B%22id_token%22%3A%7B%22email%22%3Anull%7D%2C%22vp_token%22%3A%7B%22presentation_definition%22%3A%7B%22id%22%3A%22conformance_mock_vp_request%22%2C%22input_descriptors%22%3A%5B%7B%22id%22%3A%22conformance_mock_vp%22%2C%22name%22%3A%22Conformance%20Mock%20VP%22%2C%22purpose%22%3A%22Only%20accept%20a%20VP%20containing%20a%20Conformance%20Mock%20VA%22%2C%22constraints%22%3A%7B%22fields%22%3A%5B%7B%22path%22%3A%5B%22%24.vc.credentialSchema%22%5D%2C%22filter%22%3A%7B%22allOf%22%3A%5B%7B%22type%22%3A%22array%22%2C%22contains%22%3A%7B%22type%22%3A%22object%22%2C%22properties%22%3A%7B%22id%22%3A%7B%22type%22%3A%22string%22%2C%22pattern%22%3A%22https%3A%2F%2Fapi-conformance.ebsi.eu%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2Fz3kRpVjUFj4Bq8qHRENUHiZrVF5VgMBUe7biEafp1wf2J%22%7D%7D%2C%22required%22%3A%5B%22id%22%5D%7D%7D%5D%7D%7D%5D%7D%7D%5D%2C%22format%22%3A%7B%22jwt_vp%22%3A%7B%22alg%22%3A%5B%22ES256K%22%5D%7D%7D%7D%7D%7D&nonce=051a1861-cfb6-48c8-861a-a61af5d1c139&conformance=36c751ad-7c32-4baa-ab5c-2a303aad548f"
parse_result = urlparse(qrcode)
result = parse_qs(parse_result.query)
redirect_uri = result['redirect_uri'][0]
client_id = result['client_id'][0]
nonce = result["nonce"][0]
claims=result["claims"][0]


def build_id_token(audience, nonce) :
    alg = "ES256" if KEY_DICT['crv'] == "P-256"  else "ES256K"
    verifier_key = jwk.JWK(**KEY_DICT) 
    header = {
        "typ" :"JWT",
        "alg": alg,
        "jwk" : PUBLIC_KEY,
        "kid" : KID
    }
    payload = {
        "iat": round(datetime.timestamp(datetime.now())),
        "aud" : audience,
        "exp": round(datetime.timestamp(datetime.now())) + 1000,
        "sub" : DID,
        "iss": "https://self-issued.me/v2",
        "nonce": nonce,
        "_vp_token": {
            "presentation_submission": {
            "definition_id": "conformance_mock_vp_request",    
            "id": "VA presentation Talao",
            "descriptor_map": [
                {
                    "id": "conformance_mock_vp",
                    "format": "jwt_vp",
                    "path": "$",
                }
            ]
            }
        }
    }
    token = jwt.JWT(header=header,claims=payload, algs=[alg])
    token.make_signed_token(verifier_key)
    return token.serialize()
   

"""
Build and sign verifiable presentation as vp_token
Ascii is by default in the json string 
"""
def build_vp_token(audience, nonce) :
    verifier_key = jwk.JWK(**KEY_DICT) 
    alg = "ES256" if KEY_DICT['crv'] == "P-256"  else "ES256K"
    header = {
        "typ" :"JWT",
        "alg": alg,
        "kid" : KID,
        "jwk" : PUBLIC_KEY,
    }
    iat = round(datetime.timestamp(datetime.now()))
    payload = {
        "iat": iat,
        "jti" : "http://example.org/presentations/talao/01",
        "nbf" : iat -10,
        "aud" : audience,
        "exp": iat + 1000,
        "sub" : DID,
        "iss" : DID,
        "vp" : {
            "@context": ["https://www.w3.org/2018/credentials/v1"],
            "id": "http://example.org/presentations/talao/01",
            "type": ["VerifiablePresentation"],
            "holder": DID,
            "verifiableCredential": [credential['credential']]
        },
        "nonce": nonce
    }
    token = jwt.JWT(header=header,claims=payload, algs=[alg])
    token.make_signed_token(verifier_key)
    return token.serialize()


"""
send response to verifier

"""
def send_response(id_token, vp_token, redirect_uri) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/x-www-form-urlencoded',
    }
    data = "id_token="+ id_token + "&vp_token=" + vp_token
    resp = requests.post(redirect_uri, headers=headers, data=data)
    if resp.status_code == 200 : 
        return resp.json()


# main
id_token = build_id_token(audience, nonce)
vp_token =  build_vp_token(audience, nonce)
result = send_response(id_token, vp_token, redirect_uri)
print(result)
