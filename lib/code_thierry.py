from flask import Flask, request, jsonify
import socket
import requests
import json
from urllib.parse import parse_qs, urlparse
from jwcrypto import jwk, jwt
from datetime import datetime
import hashlib
import base58
​
# jwcrypto EC: crv(str) (one of P-256, P-384, P-521, secp256k1)
​
app = Flask(__name__)
​
# IP tunnel for external server
ngrok = "https://1253-77-140-52-235.ngrok.io"
​
# EBSI
conformance = "36c751ad-7c32-4baa-ab5c-2a303aad548f"
​
# wallet key
KEY_DICT = {"crv":"secp256k1",
"d":"lbuGEjEsYQ205boyekj8qdCwB2Uv7L2FwHUNleJj_Z0",
"kty":"EC",
"x":"AARiMrLNsRka9wMEoSgMnM7BwPug4x9IqLDwHVU-1A4",
"y":"vKMstC3TEN3rVW32COQX002btnU70v6P73PMGcUoZQs",
 "alg" : 'ES256'}
​
# pour calculer did:ebsi
def thumbprint_ebsi(jwk) :
    """
    https://www.rfc-editor.org/rfc/rfc7638.html
    """
    if isinstance(jwk, str) :
        jwk = json.loads(jwk)
    JWK = json.dumps({
                    "crv":"P-256",
                    "kty":"EC",
                    "x":jwk["x"],
                    "y":jwk["y"]
                    }).replace(" ","")
    m = hashlib.sha256()
    m.update(JWK.encode())
    return m.hexdigest()
​
​
# pour calculer did:ebsi (Natural Person)
def did_ebsi(jwk) :
    """
    https://ec.europa.eu/digital-building-blocks/wikis/display/EBSIDOC/EBSI+DID+Method
    """
    if isinstance(jwk, str) :
        jwk = json.loads(jwk)
    return  'did:ebsi:z' + base58.b58encode(b'\x02' + bytes.fromhex(thumbprint_ebsi(jwk))).decode()
​
​
# calcul did:ebsi
did = did_ebsi(KEY_DICT)
#did = "did:ebsi:zeGEwSVjZDxc5aDmBsRSvYtwvdSSmQw2k9A39vm4PwyAt"
​
​
# qrcode du test copliance 
qrcode = "openid://initiate_issuance?issuer=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Fconformance%2Fv2&credential_type=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2Fz6EoWU6KYRjy7mR9VuKecgsNAuBkYGF3H94PdqgcEdQtp&conformance=36c751ad-7c32-4baa-ab5c-2a303aad548f"
parse_result = urlparse(qrcode)
result = parse_qs(parse_result.query)
issuer = result['issuer'][0]
credential_type = result["credential_type"][0]
​
    
def authorization_request(ngrok, conformance, credentialType ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/json'
        }
    url = "https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/authorize"
    my_request = {
        "scope" : "openid",
        "client_id" : ngrok + "/callback",
        "response_type" : "code",
        "authorization_details" : [{"type":"openid_credential",
                        "credential_type": credentialType,
                        "format":"jwt_vc"}],
        "redirect_uri" :  ngrok + "/callback",
        "state" : "1234"
        }
        
    resp = requests.get(url, headers=headers, params = my_request)
    print("status code = ", resp.status_code)
    if resp.status_code == 200 :
        return resp.json()
    else :
        return None
​
​
def token_request(code, ngrok ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/x-www-form-urlencoded'
        }
    url = "https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/token"
    data = { "code" : code,
            "grant_type" : "authorization_code",
            "redirect_uri" :  ngrok + "/callback"
        }
    resp = requests.post(url, headers=headers, data = data)
    if resp.status_code == 200 :
        return resp.json()
    else :
        return None
​
​
def build_proof(nonce) :
    verifier_key = jwk.JWK(**KEY_DICT) 
    header = {
        "typ" :"JWT",
        "alg": "ES256K",
        "jwk" : {"crv":"secp256k1",
                "kty":"EC",
                "x":"AARiMrLNsRka9wMEoSgMnM7BwPug4x9IqLDwHVU-1A4",
                "y":"vKMstC3TEN3rVW32COQX002btnU70v6P73PMGcUoZQs"
                }
    }
    payload = {
        "iss" : did,
        "nonce" : nonce,
        "iat": datetime.timestamp(datetime.now()),
        "aud" : issuer
    }  
    token = jwt.JWT(header=header,claims=payload, algs=["ES256K"])
    token.make_signed_token(verifier_key)
    return token.serialize()
​
​
def credential_request(access_token, proof ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token 
        }
    url = "https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/credential"
​
    data = { "type" : credential_type,
            "format" : "jwt_vc",
            "proof" : {
                "proof_type": "jwt",
                "jwt": proof
            }
    }
    resp = requests.post(url, headers=headers, data = json.dumps(data))
    if resp.status_code == 200 :
        return resp.json()
    else :
        return None
​
​
# authorization request
@app.route('/start' , methods=['GET', 'POST'])
def start() :
    authorization_request(ngrok, conformance, credential_type)
    return jsonify("Authorization request sent")
​
​
@app.route('/callback' , methods=['GET', 'POST']) 
def callback() :
    print("callback received")  
    # code received
    code = request.args["code"]
​
    # access token request
    result = token_request(code, ngrok )
    access_token = result["access_token"]
    c_nonce = result["c_nonce"]
​
    # build proof of kety ownership
    proof = build_proof(c_nonce)
​
    # credetial request
    result = credential_request(access_token, proof )
    print("credential = ", result)
    return jsonify('ok')
​
​
# local http server init
def extract_ip():
    st = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:       
        st.connect(('10.255.255.255', 1))
        IP = st.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        st.close()
    return IP
​
​
# MAIN entry point. Flask http server
if __name__ == '__main__':
    # to get the local server IP 
    IP = extract_ip()
    # server start
    app.run(host = IP, port= 4000, debug=True)