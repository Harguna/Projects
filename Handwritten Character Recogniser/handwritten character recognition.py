import numpy as np
from keras.datasets import mnist
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense
from sklearn.preprocessing import OneHotEncoder as oh
from keras.layers import Dropout
from keras.layers import Flatten
from keras.layers.convolutional import Conv2D
from keras.layers.convolutional import MaxPooling2D
from keras import backend as K
K.set_image_dim_ordering('th')

print(mnist.load_data())
data = mnist.load_data()

(trainx, trainy), (testx, testy) = data
plt.imshow(trainx[0])   #coloured
plt.imshow(trainx[0], cmap=plt.get_cmap('gray'))    #BW

np.random.seed(1)
trainx.shape[1], trainx.shape[2]

trainx = trainx/255
testx = testx/255

onehot = oh(categorical_features = [0])
trainy = trainy.reshape(-1, 1)
trainy = onehot.fit_transform(trainy).toarray()

onehot2 = oh(categorical_features = [0])
testy = testy.reshape(-1, 1)
testy = onehot2.fit_transform(testy).toarray()

trainy.shape
trainx.shape
#trainx.reshape(60000,28,28)
model = Sequential()
model.add(Conv2D(30, (5, 5), input_shape=(1, 28, 28), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dense(50, activation='relu'))
model.add(Dense(10, activation='softmax'))
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
model.fit(trainx.reshape(60000,1,28,28), trainy, epochs=1, batch_size=1000)
model.evaluate(testx.reshape(10000,1,28,28), testy)
model.metrics_names