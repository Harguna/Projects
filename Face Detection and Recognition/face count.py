import numpy
import cv2

video = 'faces.mp4'
load = cv2.VideoCapture(video)

face_casc = cv2.CascadeClassifier('E:/NLP/venv/Lib/site-packages/cv2/data/haarcascade_frontalface_default.xml')
eye_casc=cv2.CascadeClassifier('E:/NLP/venv/Lib/site-packages/cv2/data/haarcascade_eye.xml')
path = 'dataset'
recognizer = cv2.face.LBPHFaceRecognizer_create()
color=(0,255,0)
thickness=1
count = 0
while(load.isOpened()):
    ret, frame = load.read()
    #if ret == True:
    #    cv2.imshow("Frame", frame)
    if cv2.waitKey(1) & 0xFF == ord('e'):
        break
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.equalizeHist(gray)
    faces = face_casc.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=6)

    img = frame  # default if face is not found
    for (x, y, w, h) in faces:
        #roi_gray = gray[y:y + h, x:x + w]
        #roi_color = frame[y:y + h, x:x + w]

        img=cv2.rectangle(frame, (x, y), (x + w, y + h), color, thickness) # box for face
        cv2.imwrite("dataset/User" + '.' + str(count) + ".jpg", gray[y:y + h, x:x + w])

        #eyes = eye_casc.detectMultiScale(roi_gray)
        #for (x_eye, y_eye, w_eye, h_eye) in eyes:
        #    center = (int(x_eye + 0.5 * w_eye), int(y_eye + 0.5 * h_eye))
        #    radius = int(0.3 * (w_eye + h_eye))
        #    img = cv2.circle(roi_color, center, radius, color, thickness)
            # img=cv2.circle(frame,center,radius,color,thickness)
        count = count + 1
    # Display the resulting image
    cv2.imshow('Face Detection Harr', img)

load.release()
cv2.destroyAllWindows()

