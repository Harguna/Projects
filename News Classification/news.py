import json
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize as wt
import nltk
import re
from sklearn.cross_validation import train_test_split as tts
import pandas as pd
import numpy as np
from sklearn import model_selection, preprocessing, linear_model, naive_bayes, metrics, svm
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn import decomposition, ensemble
from nltk.stem import WordNetLemmatizer 

data = []
with open('E:/START/ML Projects/News_Category_Dataset.json') as f:
    for line in f:
        data.append(json.loads(line))

desc = []
head = []
cat = []
for i in range(len(data)):
    desc.append(data[i]["short_description"])
    head.append(data[i]["headline"])
    cat.append(data[i]["category"])


# checking for spelling mistakes in category
count = 0
actual = ['POLITICS', 'ENTERTAINMENT', 'HEALTHY LIVING', 'QUEER VOICES', 'BUSINESS', 'SPORTS', 'COMEDY', 'PARENTS', 'BLACK VOICES','THE WORLDPOST','WOMEN','CRIME','MEDIA','WEIRD NEWS','GREEN','IMPACT','WORLDPOST','RELIGION','STYLE','WORLD NEWS','TRAVEL','TASTE','ARTS','FIFTY','GOOD NEWS','SCIENCE','ARTS & CULTURE','TECH','COLLEGE','LATINO VOICES', 'EDUCATION']
unique = list(set(cat))    #unique catergories 

for i in range(len(unique)):    #check loop
    if unique[i] not in actual:
        print(unique[i])



desc  = []
head = []

# accumulating headlines and descriptions
for i in range(len(data)):
    desc.append(data[i]["short_description"])
    head.append(data[i]["headline"])

# extracting words
for i in range(len(desc)):
    desc[i] = re.findall(r'[a-zA-Z]+', desc[i])
    head[i] = re.findall(r'[a-zA-Z]+', head[i])

'''# changing all words to lower case
for i in range(len(desc)):
    desc[i] = [x.lower() for x in desc[i]]
    head[i] = [x.lower() for x in head[i]]'''

# removing stopwords
for i in range(len(desc)):
    desc[i] = [w.lower() for w in desc[i] if (w.lower() not in stopwords.words("english"))]
    head[i] = [w.lower() for w in head[i] if (w.lower() not in stopwords.words("english"))]

# removing left overs from words like: "they're", "we've, "I'm", etc. 
for i in range(len(desc)):
    desc[i] = [w for w in desc[i] if (w not in ['s', 're', 've', 'd', 'm'])]
    head[i] = [w for w in head[i] if (w not in ['s', 're', 've', 'd', 'm'])]


df = pd.DataFrame({'Description' : desc, 'Headline' : head, 'Category' : cat})
df.isnull().sum()

x = []
for i in range(len(desc)):
    x.append(desc[i] + head[i])
    x[i] = " ".join(x[i])


trainx, testx = tts(x, test_size = 0.2)
train_cat, test_cat = tts(cat, test_size = 0.2)

'''from sklearn import preprocessing
encode = preprocessing.LabelEncoder()
train_cat = encode.fit_transform(train_cat)
test_cat = encode.transform(test_cat)'''

from sklearn.feature_extraction.text import CountVectorizer as cv
vector = cv()
vector.fit(x)
trainx_vector = vector.transform(trainx)
testx_vector = vector.transform(testx)

from sklearn.feature_extraction.text import TfidfVectorizer as tv
tfidf = tv()
tfidf.fit(x)
trainx_tfidf = tfidf.transform(trainx)
testx_tfidf = tfidf.transform(testx)

from sklearn.feature_extraction.text import TfidfVectorizer as tv
tfidf_ng = tv(ngram_range = (2,4))
tfidf_ng.fit(x)
trainx_ngram = tfidf_ng.transform(trainx)
testx_ngram = tfidf_ng.transform(testx)

# Naive Bayes
from sklearn.naive_bayes import MultinomialNB
clf = MultinomialNB().fit(trainx_vector, train_cat)   
pred = clf.predict(testx_vector)
print(np.mean(pred == test_cat))

clf = MultinomialNB().fit(trainx_tfidf, train_cat)   
pred = clf.predict(testx_tfidf)
print(np.mean(pred == test_cat))

clf = MultinomialNB().fit(trainx_ngram, train_cat)   
pred = clf.predict(testx_ngram)
print(np.mean(pred == test_cat))


# SVM

from sklearn.linear_model import SGDClassifier
svm =   SGDClassifier().fit(trainx_vector, train_cat)
pred = svm.predict(testx_vector)
print(np.mean(pred == test_cat))

svm =   SGDClassifier().fit(trainx_tfidf, train_cat)
pred = svm.predict(testx_tfidf)
print(np.mean(pred == test_cat))

svm =   SGDClassifier().fit(trainx_ngram, train_cat)
pred = svm.predict(testx_ngram)
print(np.mean(pred == test_cat))


# Linear model
from sklearn.linear_model import LogisticRegression
lr = LogisticRegression().fit(trainx_vector, train_cat)
pred = lr.predict(testx_vector)
print(np.mean(pred == test_cat))

lr =   LogisticRegression().fit(trainx_tfidf, train_cat)
pred = lr.predict(testx_tfidf)
print(np.mean(pred == test_cat))

lr =   LogisticRegression().fit(trainx_ngram, train_cat)
pred = lr.predict(testx_ngram)
print(np.mean(pred == test_cat))
    

# Random Forest
rf = ensemble.RandomForestClassifier().fit(trainx_vector, train_cat)
pred = rf.predict(testx_vector)
print(np.mean(pred == test_cat))

rf =   ensemble.RandomForestClassifier().fit(trainx_tfidf, train_cat)
pred = rf.predict(testx_tfidf)
print(np.mean(pred == test_cat))

rf =   ensemble.RandomForestClassifier().fit(trainx_ngram, train_cat)
pred = rf.predict(testx_ngram)
print(np.mean(pred == test_cat))



#############################################################################################################


# Without any changes to input (Without stopword removal or character removal)

x = []
for i in range(len(desc)):
    x.append(data[i]["short_description"]+ " " + data[i]["headline"])

trainx, testx = tts(x, test_size = 0.2)
train_cat, test_cat = tts(cat, test_size = 0.2)

'''from sklearn import preprocessing
encode = preprocessing.LabelEncoder()
train_cat = encode.fit_transform(train_cat)
test_cat = encode.transform(test_cat)'''

from sklearn.feature_extraction.text import CountVectorizer as cv
vector = cv()
vector.fit(x)
trainx_vector = vector.transform(trainx)
testx_vector = vector.transform(testx)

from sklearn.feature_extraction.text import TfidfVectorizer as tv
tfidf = tv()
tfidf.fit(x)
trainx_tfidf = tfidf.transform(trainx)
testx_tfidf = tfidf.transform(testx)

from sklearn.feature_extraction.text import TfidfVectorizer as tv
tfidf_ng = tv(ngram_range = (2,4))
tfidf_ng.fit(x)
trainx_ngram = tfidf_ng.transform(trainx)
testx_ngram = tfidf_ng.transform(testx)

# Naive Bayes
from sklearn.naive_bayes import MultinomialNB
clf = MultinomialNB().fit(trainx_vector, train_cat)   
pred = clf.predict(testx_vector)
print(np.mean(pred == test_cat))

clf = MultinomialNB().fit(trainx_tfidf, train_cat)   
pred = clf.predict(testx_tfidf)
print(np.mean(pred == test_cat))

clf = MultinomialNB().fit(trainx_ngram, train_cat)   
pred = clf.predict(testx_ngram)
print(np.mean(pred == test_cat))


# SVM

from sklearn.linear_model import SGDClassifier
svm =   SGDClassifier().fit(trainx_vector, train_cat)
pred = svm.predict(testx_vector)
print(np.mean(pred == test_cat))

svm =   SGDClassifier().fit(trainx_tfidf, train_cat)
pred = svm.predict(testx_tfidf)
print(np.mean(pred == test_cat))

svm =   SGDClassifier().fit(trainx_ngram, train_cat)
pred = svm.predict(testx_ngram)
print(np.mean(pred == test_cat))


# Linear model
from sklearn.linear_model import LogisticRegression
lr = LogisticRegression().fit(trainx_vector, train_cat)
pred = lr.predict(testx_vector)
print(np.mean(pred == test_cat))

lr =   LogisticRegression().fit(trainx_tfidf, train_cat)
pred = lr.predict(testx_tfidf)
print(np.mean(pred == test_cat))

lr =   LogisticRegression().fit(trainx_ngram, train_cat)
pred = lr.predict(testx_ngram)
print(np.mean(pred == test_cat))
    

# Random Forest
rf = ensemble.RandomForestClassifier().fit(trainx_vector, train_cat)
pred = rf.predict(testx_vector)
print(np.mean(pred == test_cat))

rf =   ensemble.RandomForestClassifier().fit(trainx_tfidf, train_cat)
pred = rf.predict(testx_tfidf)
print(np.mean(pred == test_cat))

rf =   ensemble.RandomForestClassifier().fit(trainx_ngram, train_cat)
pred = rf.predict(testx_ngram)
print(np.mean(pred == test_cat))


############################################################################################################

# Lemmatization of the input

lem = WordNetLemmatizer()

x = []
for i in range(len(desc)):
    x.append(desc[i] + head[i])
    x[i] = " ".join(x[i])
    x[i] = lem.lemmatize(x[i])


trainx, testx = tts(x, test_size=0.2)
train_cat, test_cat = tts(cat, test_size=0.2)

'''from sklearn import preprocessing
encode = preprocessing.LabelEncoder()
train_cat = encode.fit_transform(train_cat)
test_cat = encode.transform(test_cat)'''

from sklearn.feature_extraction.text import CountVectorizer as cv
vector = cv()
vector.fit(x)
trainx_vector = vector.transform(trainx)
testx_vector = vector.transform(testx)

from sklearn.feature_extraction.text import TfidfVectorizer as tv
tfidf = tv()
tfidf.fit(x)
trainx_tfidf = tfidf.transform(trainx)
testx_tfidf = tfidf.transform(testx)

from sklearn.feature_extraction.text import TfidfVectorizer as tv
tfidf_ng = tv(ngram_range=(2,4))
tfidf_ng.fit(x)
trainx_ngram = tfidf_ng.transform(trainx)
testx_ngram = tfidf_ng.transform(testx)

# Naive Bayes
from sklearn.naive_bayes import MultinomialNB
clf = MultinomialNB().fit(trainx_vector, train_cat)
pred = clf.predict(testx_vector)
print(np.mean(pred == test_cat))

clf = MultinomialNB().fit(trainx_tfidf, train_cat)
pred = clf.predict(testx_tfidf)
print(np.mean(pred == test_cat))

clf = MultinomialNB().fit(trainx_ngram, train_cat)
pred = clf.predict(testx_ngram)
print(np.mean(pred == test_cat))


# SVM

from sklearn.linear_model import SGDClassifier
svm = SGDClassifier().fit(trainx_vector, train_cat)
pred = svm.predict(testx_vector)
print(np.mean(pred == test_cat))

svm = SGDClassifier().fit(trainx_tfidf, train_cat)
pred = svm.predict(testx_tfidf)
print(np.mean(pred == test_cat))

svm = SGDClassifier().fit(trainx_ngram, train_cat)
pred = svm.predict(testx_ngram)
print(np.mean(pred == test_cat))


# Linear model
from sklearn.linear_model import LogisticRegression
lr = LogisticRegression().fit(trainx_vector, train_cat)
pred = lr.predict(testx_vector)
print(np.mean(pred == test_cat))

lr = LogisticRegression().fit(trainx_tfidf, train_cat)
pred = lr.predict(testx_tfidf)
print(np.mean(pred == test_cat))

lr = LogisticRegression().fit(trainx_ngram, train_cat)
pred = lr.predict(testx_ngram)
print(np.mean(pred == test_cat))


# Random Forest
rf = ensemble.RandomForestClassifier().fit(trainx_vector, train_cat)
pred = rf.predict(testx_vector)
print(np.mean(pred == test_cat))

rf = ensemble.RandomForestClassifier().fit(trainx_tfidf, train_cat)
pred = rf.predict(testx_tfidf)
print(np.mean(pred == test_cat))

rf = ensemble.RandomForestClassifier().fit(trainx_ngram, train_cat)
pred = rf.predict(testx_ngram)
print(np.mean(pred == test_cat))