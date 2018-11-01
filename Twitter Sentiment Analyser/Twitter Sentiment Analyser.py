import re
import tweepy
from tweepy import OAuthHandler
from textblob import TextBlob

class TwitterClient():
    def __init__(self):
        key = ''
        secret = ''
        token = ''
        token_secret = ''

        try:
            self.auth = OAuthHandler(key, secret)
            self.auth.set_access_token(token, token_secret)
            self.api = tweepy.API(self.auth)
        except:
            print("Error: Authentication Failed")

    def clean_tweet(self, tweet):
        return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())

    def sentiment(self, tweet):
        sent = TextBlob(self.clean_tweet(tweet))
        if sent.sentiment.polarity > 0:
            return 'positive'
        elif sent.sentiment.polarity == 0:
            return 'neutral'
        else:
            return 'negative'

    def get_tweets(self, query, count = 10):
        tweets = []
        try:
            fetch = self.api.search(q = query, count = count)

            for tweet in fetch:
                parsed_tweet = {}
                parsed_tweet['text'] = tweet.text
                parsed_tweet['sentiment'] = self.sentiment(tweet.text)

                if tweet.retweet_count > 0:
                    if parsed_tweet not in tweets:
                        tweets.append(parsed_tweet)
                else:
                    tweets.append(parsed_tweet)

            return tweets

        except tweepy.TweepError as e:
            print("Error : " + str(e))


tw = TwitterClient()
tweets = tw.get_tweets(query = 'Demonetisation', count = 50)
ptweets = [tweet for tweet in tweets if tweet['sentiment'] == 'positive']
print(len(ptweets)*100/len(tweets))

ntweets = [tweet for tweet in tweets if tweet['sentiment'] == 'negative']
print(len(ntweets)*100/len(tweets))

