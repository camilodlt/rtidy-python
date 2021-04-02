Computer Vision task that mainly use Deep Learning

### Animals on small dataset: 
**The idea is to classify photos of cats, dogs and pandas.** 
Explores the use of data augmentation to enhance classification performance. 
This techinique is used because the dataset is very small (2500 photos on training) so normally DL tends to overfit rapidly. 
With regularization, dropout and data augmentation we are able to fight the smalness of the dataset at hand. 

We got 76.13% accuracy on the test set with only 2250 examples on the training set. This shows us the power of data augmentation while training the model.  
Sadly, a new photo of my dog got classified as a panda! But honestly I can understand how the model might hesitate between dog and panda classes since my dog is black and white and the background was grass. Still a very fun project. 
