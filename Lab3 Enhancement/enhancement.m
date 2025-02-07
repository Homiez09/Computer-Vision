I = rgb2gray(imread('chest.jpg'));

J1 = imadjust(I, [20/255 130/255], [0.0 1.0]); %
J2 = imadjust(I,stretchlim(I),[]);

J3 = histeq(I); %

J4 = adapthisteq(I);

J5 = adapthisteq(I, "ClipLimit", 0.07); %

imshow(J5)