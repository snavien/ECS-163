import csv
from TwitterSearch import *


class BuzzWord:
    def __init__(self, tweet, hashtag):
        self.keyword = hashtag
        self.date = str.split(tweet['user']['created_at'])
        self.year = self.date[5]
        self.month = self.date[1]
        self.screen_name = tweet['user']['screen_name']
        self.text = tweet['text']
        self.retweet_cnt = tweet['retweet_count']
        self.fav_cnt = tweet['favorite_count']
        self.retweeted = tweet['retweeted']
        self.favorited = tweet['favorited']
    def return_row(self):
        vars = [self.keyword, self.screen_name, self.text, self.year, self.month, self.retweeted, self.retweet_cnt, self.favorited, self.fav_cnt]
        row = []
        for v in vars:
            row.append(v)
        print(row)
        return row


def search(hashtag):
    with open(hashtag + '.csv', 'w', newline='', encoding='utf-8') as csvfile:
        print(hashtag)
        writer = csv.writer(csvfile, delimiter=',', quotechar='|')
        print("Header")
        writer.writerow(['Keyword', 'Screen_Name', 'Text', 'Created_At_Year', 'Created_At_Month', 'Retweeted', 'Retweet_Count', 'Favorited', 'Favorite_Count'])

        try:
            tso = TwitterSearchOrder() # create a TwitterSearchOrder object
            tso.set_keywords([hashtag])
            tso.set_language('en') # we want to see German tweets only
            tso.set_include_entities(False) # and don't give us all those entity information

            # it's about time to create a TwitterSearch object with our secret tokens
            ts = TwitterSearch(
                consumer_key = 'jHPLEIrLHTJA7j4nXio3SarMe',
                consumer_secret = 'GCpidvpbuJOcn5qDsC8K6xkeaE0OrEZbdnXhjf9Acw0uucfntF',
                access_token = '2830558166-SpZpyVYusiMA0PI5vIrXgZ26nxMiSeAk1gkTGrL',
                access_token_secret = 'LpekPw45bmc5jwSIUQ052P3cKD5WzlpuknFDMlNDHtjhU'
             )

            # buzz_map_date = {}
            # this is where the fun actually starts :)
            for tweet in ts.search_tweets_iterable(tso):
                # print('@%s tweeted: %s at %s retweets: %s favorites: %s' % (tweet['user']['screen_name'], tweet['text'], tweet['user']['created_at'], tweet['retweet_count'],tweet['favorite_count']))
                # search_results.write(str(tweet))
                tmp = BuzzWord(tweet, hashtag)
                print(tmp.return_row())
                writer.writerow(tmp.return_row())
            #     if buzz_map_date.get((tmp.year, tmp.month)) is None:
            #         buzz_map_date[(tmp.year, tmp.month)] = list()
            #     else:
            #         buzz_map_date[(tmp.year, tmp.month)].append(tmp)
            #
            # print("%s \n" % str(buzz_map_date[('2008', 'May')][0].text))

        except TwitterSearchException as e: # take care of all those ugly errors if there are some
            print(e)


def main():
    print("starting...")
    #ILookLikeAnEngineer", "#AddWomen", "#GirlsWhoCode", "#BeAGirlWhoCodes", "StemWomen", "#StemGirls", "#LikeAGirl",
    # hashtags = ["#DistractinglySexy", "#GirlsWithToys", "#WomenInTech"]
    hashtags =["#StemWomen"]
    for hashtag in hashtags:
        search(hashtag)
    print("done")
# look for hashtags and MCS
# hash by creation date -> MCS
# maybe check if it's been retweeted
# find related

#https://dev.twitter.com/rest/reference/get/trends/place

main()
