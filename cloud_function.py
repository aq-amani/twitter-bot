from google.cloud import datastore
import logging
import random
logging.basicConfig(level=logging.DEBUG)

def run(request):
    request_json = request.get_json(silent=True)
    request_args = request.args

    if request_json and 'name' in request_json:
        name = request_json['name']
    elif request_args and 'name' in request_args:
        name = request_args['name']
    else:
        name = 'World'
    logger = logging.getLogger('my_logger')
    
    random_number = random.randint(0, 10)
    client = datastore.Client()
    query = client.query(kind='testkind')  # Replace 'YourKindName' with your entity kind
    query.add_filter('id', '=', 1)  # Replace 'propertyName' and 'propertyValue'
    results = list(query.fetch())  # Fetch the results into a list
    tweet = results[0]['test-property']
    logger.info(f'RUN NO FUNCTIONS FRAMEWORK: Hello {tweet}!, random number is {random_number}')
    return f'RUN NO FUNCTIONS FRAMEWORK: Hello {tweet}! Random number is: {random_number}'
