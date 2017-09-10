# Text-Rain

## Description
This was the first assignment in my Graphics and Games class in spring 2016. The goal was to recreate "Text Rain", which was an interactive program done by Camille Utterback and Romy Achituv back in 1999. This recreation uses your webcam to capture video of the user. Alphabet letters randomly rain down from the sky, and will interact with the user, as if they were an object in the program. So, the user can "catch" letters and play around with them.

## Features
- Reading webcam input
- Image processing: Mirroring the image, and converting to grayscale
- Interaction from the webcam video and text by not allowing the text to fall anything below a certain brightness threshold
- Debug mode where all pixels are either black or white, for below or above the threshold respectively
- Simulated gravity. If the text is on a sloped surface, it will slide down it slowly
- Option to load different webcam options or a test video in the beginning menu

## Controls
- Spacebar: Debug mode
- Up / Down arrows: Increase / decrease the threshold
- Numberpad: Select initial video option from main menu

## Installing
Code works using Processing v3.3.6. Needs the processing.video library installed
Then, just load the code, and hit play.
