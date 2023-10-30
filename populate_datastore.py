## Assumes a CSV file where each row is <id> <tweet_text>
## id is just an int given to the tweet to use to randomly choose tweets
import csv
from google.cloud import datastore

client = datastore.Client()
entities = []
key = client.key('tweets')

# Open the CSV file for reading
with open('tweets_list.csv', 'r', encoding='shift_jis', newline='') as csvfile:
    # Create a CSV reader
    csvreader = csv.reader(csvfile)

    # Iterate through the rows
    for row in csvreader:
        id, tweet = row
        entity = datastore.Entity(key=key)
        entity['tweet'] = tweet
        entity['id'] = id
        entities.append(entity)
        print(f"ID: {id}, Tweet: {tweet}")

client.put_multi(entities)
