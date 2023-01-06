from flask import Flask, request, jsonify
import socket
import requests
import json
from urllib.parse import parse_qs, urlparse
from jwcrypto import jwk, jwt
from datetime import datetime

app = Flask(__name__)

# IP tunnel for external server   ngrok http 192.168.0.220:4000
ngrok =  "https://af75-217-128-135-206.ngrok.io"

# EBSI conformance header
conformance = "36c751ad-7c32-4baa-ab5c-2a303aad548f"

# wallet key
KEY_DICT = {"crv":"P-256",
            "d":"ZpntMmvHtDxw6przKSJY-zOHMrEZd8C47D3yuqAsqrw",
            "kty":"EC",
            "x":"NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM",
            "y":"UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE"}

KEY_JWK =  {"crv":"P-256",
            "kty":"EC",
            "x":"NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM",
            "y":"UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE"}

DID =  "did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya"
KID =  "did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya#lD7U7tcVLZWmqECJYRyGeLnDcU4ETX3reBN3Zdd0iTU"


# qrcode lu sur site EBSI
qrcode ="openid://initiate_issuance?issuer=https%3A%2F%2Fapi-conformance.ebsi.eu%2Fconformance%2Fv2&credential_type=https%3A%2F%2Fapi-conformance.ebsi.eu%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2Fz22ZAMdQtNLwi51T2vdZXGGZaYyjrsuP1yzWyXZirCAHv&conformance=0a7aeb7b-e6d7-4349-a48f-c094ecb09c71"
parse_result = urlparse(qrcode)
result = parse_qs(parse_result.query)
issuer = result['issuer'][0]
credential_type = result["credential_type"][0]
#credential_type =  "https://api-conformance.ebsi.eu/trusted-schemas-registry/v2/schemas/z22ZAMdQtNLwi51T2vdZXGGZaYyjrsuP1yzWyXZirCAHv"


def authorization_request(ngrok, conformance, credential_type ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/json'
        }
    url = url = "https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/authorize"
    my_request = {
        "scope" : "openid",
        "client_id" : ngrok + "/callback",
        "response_type" : "code",
        "authorization_details" : json.dumps([{"type":"openid_credential",
                        "credential_type": credential_type,
                        "format":"jwt_vc"}]),
        "redirect_uri" :  ngrok + "/callback",
        "state" : "1234"
        }
    resp = requests.get(url, headers=headers, params = my_request)
    return resp.json()


def token_request(code, ngrok ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/x-www-form-urlencoded'
        }
    url = "https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/token"

    data = { "code" : code,
            "grant_type" : "authorization_code",
            "redirect_uri" :  ngrok + "/callback"
        }
    resp = requests.post(url, headers=headers, data = data)
    return resp.json()


def build_proof(nonce) :
    verifier_key = jwk.JWK(**KEY_DICT) 
    alg = "ES256" if KEY_DICT['crv'] == "P-256"  else "ES256K"
    header = {
        "typ" :"JWT",
        "alg": alg,
        "jwk" : KEY_JWK,
        "kid" : KID
    }
    payload = {
        "iss" : DID,
        "nonce" : nonce,
        "iat": datetime.timestamp(datetime.now()),
        "aud" : issuer
    }  
    token = jwt.JWT(header=header,claims=payload, algs=[alg])
    token.make_signed_token(verifier_key)
    return token.serialize()


def credential_request(access_token, proof ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token 
        }
    url = url = "https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/credential"
    data = { 
        "type" : credential_type,
        "format" : "jwt_vc",
        "proof" : {
            "proof_type": "jwt",
            "jwt": proof
        }
    }
    resp = requests.post(url, headers=headers, data = json.dumps(data))
    return resp.json()


# authorization request 
@app.route('/start' , methods=['GET', 'POST'])
def start() :
    authorization_request(ngrok, conformance, credential_type)
    return jsonify("Authorization request sent")


# callback endpoint
@app.route('/callback' , methods=['GET', 'POST']) 
def callback() :
    # code received
    code = request.args["code"]
    
    # access token request
    result = token_request(code, ngrok )
    access_token = result["access_token"]
    c_nonce = result["c_nonce"]
    
    #build proof of kety ownership
    proof = build_proof(c_nonce)

    # credential request
    result = credential_request(access_token, proof )
    print("credential = ", result)   
    credential = result['credential']
    return jsonify('ok')
    

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


# MAIN entry point. Flask http server
if __name__ == '__main__':
    # to get the local server IP 
    IP = extract_ip()
    # server start
    app.run(host = IP, port= 4000, debug=True)