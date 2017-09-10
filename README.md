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

## Difficulties
One of the main difficulties while doing this project was that very little of the start code worked on my computer specifically for some reason. As a result I had to display everything a little differently, and double buffer. Other than that, one of the main flaws is that the image brightness obtained by the webcam is very noisy. I did nothing to help smooth any of this out, so it is expected, but it makes a lot of text slip through some spots, or get stuck on a seemingly bright, white wall.

## Controls
- Spacebar: Debug mode
- Up / Down arrows: Increase / decrease the threshold
- Numberpad: Select initial video option from main menu

## Installing
This code is compatible with at least Processing v3.3.6. The processing.video library is required to run this. Once processing is installed an setup, just open the file and hit play.
