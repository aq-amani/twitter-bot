from google.cloud import datastore
from google.cloud import secretmanager
import logging
import random
import os
import tweepy

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('my_logger')

ds_client = datastore.Client()
sm_client = secretmanager.SecretManagerServiceClient()

#MAX tweet id
max_id = int(os.environ.get('max_id', 5))
project_id = '376979220448'

def post_tweet(tweet):
    # Authenticate
    api_key = get_secret_info('tw_api_key')
    api_key_secret = get_secret_info('tw_api_key_secret')
    access_token = get_secret_info('tw_access_token')
    access_token_secret = get_secret_info('tw_access_token_secret')

    # Authenticate using APIV2 Oauth1.0a user context (only way to post tweets?)
    twitter_client = tweepy.Client(
        consumer_key=api_key,
        consumer_secret=api_key_secret,
        access_token=access_token,
        access_token_secret=access_token_secret
    )

    return twitter_client.create_tweet(text = tweet)

def get_secret_info(secret_name):
    # Build the secret version name
    secret_path = f"projects/{project_id}/secrets/{secret_name}/versions/latest"
    # Access the secret version
    response = sm_client.access_secret_version(name=secret_path)
    # Get the secret data (base64-encoded) and decode it
    secret_data = response.payload.data.decode("UTF-8")
    return secret_data

def get_tweet_from_datastore(id):
    query = ds_client.query(kind='tweets')
    query.add_filter('id', '=', id)

    results = list(query.fetch())
    tweet = results[0]['tweet']
    return tweet

def run(payload):

    random_id = random.randint(0, max_id)
    tweet = get_tweet_from_datastore(random_id)
    logger.info(f'Retrieved tweet ID{random_id} with the following content from datastore: {tweet}')

    out = post_tweet(tweet)
    logger.info(f'post tweet response:\n{out}')

    logger.info(f'Posted the tweet!')
    return f'Tweet with datastore id {random_id} was posted. Content: {tweet}\n'
