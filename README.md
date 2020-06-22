# A Wolfenstein 3D Clone

This repo contains a pet project of mine that I've been toying with for years. I
finally sat down and wrote the original version of this in JavaScript, mainly as
a proof of concept. I was able to render simple scenes from a 2D map on to an
HTML canvas element. However, due to the complex math required to calculate the
trajectories of the rays, as well as scale the resulting scene to provide the
illusion of depth, the performance of this original version was poor.
Additionally, the calculations for scaling the surfaces by distance were
slightly off, resulting in a fish-eye effect.

![](img/Screenshot_01.png)

![](img/Screenshot_02.png)

## Rewrite using raycastlib
Using JS for a rendering library is really not a great choice, both in terms of
performance and usability, and of course I would have preferred to use a
compiled language, however, I used JS as I preparing for a Microsoft Exam on JS
at the time and needed an excuse to actually work on this pet project that I had
been mulling over since I made Pac-Man in highschool (incidentally also in JS
as that was all I knew at the time, sadly the code for the Pac-Man game has been
lost to time).

The original JS version of the raycasting I created was mainly an experiment to
learn about raycasting, ideally with the goal of going from Wolfenstein3D to
Doom like graphics. However, my interest and personal learning is now leaning
more towards C and C++, and so I'll be using [raycastlib](https://gitlab.com/drummyfish/raycastlib)
as the rendering backend, and focus primarily on creating a simple game.

