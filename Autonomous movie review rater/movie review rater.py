#    AUTONOMOUS MOVIE REVIEW RATER

from nltk.classify import NaiveBayesClassifier
from textblob import TextBlob
import nltk.classify.util
from nltk.corpus import movie_reviews
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize


def create_word_features(words):
    useful_words = [word for word in words if word not in stopwords.words("english")]
    my_dict = dict([(word, True) for word in useful_words])
    return my_dict

#print("Negatives")
neg = []
for fileid in movie_reviews.fileids('neg')[:20]:
    words = movie_reviews.words(fileid)
    neg.append((create_word_features(words), "negative"))

#print("Positives")
pos = []
for fileid in movie_reviews.fileids('pos')[:20]:
    words = movie_reviews.words(fileid)
    pos.append((create_word_features(words), "positive"))

#print("Training")
train_set = neg[:round(0.7*len(neg))] + pos[:round(0.7*len(pos))]
test_set = neg[round((1-0.7)*len(neg)):] + pos[round((1-0.7)*len(pos)):]

classifier = NaiveBayesClassifier.train(train_set)

accuracy = nltk.classify.util.accuracy(classifier, test_set)
print("Accuracy for the classifier is : ", round(accuracy * 100, 4))
print("")

x = "The movie was ok in the begining, but got bad later." # str(input())
a = TextBlob(x)
x = str(a.correct())
print(x)

ans = classifier.classify(create_word_features(x))
print("The comment is : ", ans)

sentiment_dictionary = {}
for line in open('/word-score.txt'):
    word, score = line.split('\t')
    sentiment_dictionary[word] = int(score)

words = word_tokenize(x.lower())
print("Rating given to the review is : ", sum(sentiment_dictionary.get(word, 0) for word in words))
print("Polarity of the comment is : ", round(a.polarity, 4))