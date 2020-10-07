%Pulizia di tutti gli elementi
clear all;
close all;
%Importo l'immagine su scala di grigi
Images = dir('*.jpg');
for file=1:length(Images)
image = Images(file).name
I = rgb2gray(imread(image));
%Ottengo le misure
[X,Y] = size(I);
%Definisco l'immagine su tutta la scala di grigi
I = imadjust(I, stretchlim(I), []);
%Creo i pattern
pattern1 = I(1:14,1:14);
pattern2 = I(2:15,2:15);
pattern3 = I(X-13:X, Y-13:Y);
pattern4 = I(X-14:X-1, Y-14:Y-1);
pattern5 = I(1:14,Y-13:Y);
pattern6 = I(2:15,Y-13:Y);
%Figure 1
%imshow(I), title("Immagine Originale");
%Faccio la cross correlazione 
c1 = normxcorr2(pattern1, I);
c2 = normxcorr2(pattern2, I);
c3 = normxcorr2(pattern3, I);
c4 = normxcorr2(pattern4, I);
c5 = normxcorr2(pattern5, I);
c6 = normxcorr2(pattern6, I);
C = (c1 + c2 + c3 + c4 + c5 + c6) / 6;
%Prendo il sottoinsieme della immagine
C = C(12:end-12, 12:end-12);
C = abs(C);
%Figure 2
%imagesc(C), title 'XCORR';
level = graythresh(C);
mask = C > (level / 2);
%imagesc(mask), colorbar;
S = stdfilt(C, ones(11));
%Figure 3
%imagesc(S), title 'STD FILT';
mask = S > (level / 2);
%Dalla maschera ottenuta dalla STD mostro una anteprima di cosa dovrei
%ottenere
se = strel('disk', 3);
mask2 = imopen(mask,se);
mask2 = imcomplement(mask2);
%imshowpair(mask,mask2,'montage'), title 'Maschera e Complementare';
I = I(5:end-6, 5:end-6);
Ix = I;
Ix(mask2) = 255;
Ic = cat(3,Ix,I,I);
%imshowpair(I,Ic,'montage');
%Ora ottengo il BLOB piu' grosso, ovvero l'errore "ideale", perche' la
%analizzazione della immagine puo' (molte volte) trovare dei falsi positivi
[labeledMask, numberOfAreas] = bwlabel(mask2);
areadata = regionprops(labeledMask,'basic');
[y,j] = max([areadata.Area]); %Elemento con area piu' grande
biggestDifect = ismember(labeledMask, j);
%imshow(biggestDifect), title 'Difetto trovato';
%E' stato trovato il difetto, ora lo usiamo nella nuova maschera
Ix = I;
Ix(biggestDifect) = 255;
Ic = cat(3,Ix,I,I);
figure,imshowpair(I,Ic,'montage');
%Programma completato!
end




