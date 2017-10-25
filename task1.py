from PIL import Image
from PIL import ImageEnhance
import os
import cv2

width = 50
height = 50

image_number = 1

# Preprocessing

for filename in os.listdir('./faces') :
    if(filename.endswith('.jpg')) :
        image_file = filename
        im = Image.open('./faces/' + image_file)
        im = im.resize((width, height), Image.ANTIALIAS)
        im = ImageEnhance.Color(im).enhance(0.0)
        im = ImageEnhance.Contrast(im).enhance(2)
        im.save('./faces_resized/image_' + str(image_number).zfill(4) + '.jpg')
        image_number += 1


face_data = "haarcascade_frontalface_alt.xml"
cascade = cv2.CascadeClassifier(face_data)

for filename in os.listdir('./faces_resized') :
    if(filename.endswith('.jpg')) :
        cur_image = cv2.imread('./faces/' + filename)

        mini_size = (cur_image.shape[1], cur_image.shape[0])
        mini_frame = cv2.resize(cur_image, mini_size)

        faces = cascade.detectMultiScale(mini_frame)

        for f in faces :
            x, y, w, h = [ v for v in f ]

            sub_face = cur_image[y:y+h, x:x+w]
            cv2.imwrite('./cropped_faces/' + filename + '_cropped' + '.jpg', sub_face)
