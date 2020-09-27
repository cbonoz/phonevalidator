from chalice import Chalice, CORSConfig, BadRequestError
import urllib.parse
import requests

API_URL = "https://phonenumbervalidation.apifex.com/api/v1/validate?phonenumber=%2B1%20"

app = Chalice(app_name='phone-validator')

cors_config = CORSConfig(allow_origin='*')


@app.route('/', cors=cors_config)
def index():
    return {'hello': 'world'}


@app.route('/validate/{phone}', cors=cors_config)
def validate(phone, methods=['GET']):
    url = "{}{}".format(API_URL, phone)
    try:
        r = requests.get(url)
        data = r.json()
        print('data', data)
        location = data.get('description_for_number',
                            data.get('time_zones_for_number', ""))
        data['location'] = location
    except Exception as e:
        print('error or invalid phone number', e)
        data = {
            'location': '',
            'is_valid_number': False
        }

    return data
