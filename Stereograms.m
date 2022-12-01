%-------------------------------------
%{   

This only works with the images we have for each of the letters. Since we
couldn't submit all of thsoe, we left this commented out. 

word = {'B', 'R', 'U', 'H'};
s=4;
wordPattern = im2double(imread("wordPattern.jpeg"));
wordDepthMap = makeWordDepthMap(word,s);
imwrite(wordDepthMap,"wordDepthMap.jpeg")
%figure(2); imshow(wordDepthMap);
wordFullPattern = patternCast(wordDepthMap,wordPattern);
imwrite(wordFullPattern,"wordFullPattern.jpeg")
wordGram = stereogram(wordDepthMap,wordFullPattern,15,2);
%figure(1); imshow(wordGram);
animate(imgaussfilt(wordFullPattern,2),wordGram,"wordGif.gif");
%}
%-----------------------------------------
map1 = imread("https://i.postimg.cc/0jySTZ1M/squirrel.png");
custIm = imread("https://i.postimg.cc/6pXWTqTz/jaden.jpg");

newPattern = compress(map1, custIm, 10);
fullPattern = patternCast(im, newPattern);
gram = stereogram(im,fullPattern,25,2);
figure(1); imshow(gram)

%%%%%   Uncomment line below to save gif file to folder   %%%%%
%animate(imgaussfilt(fullPattern,2),gram,"picturePattern.gif"); 

%-------------------------------------------
shark = im2double(imread("https://i.postimg.cc/pdVnhqy0/shark.png"));
pattern = im2double(imread("https://i.postimg.cc/xdgTwQf5/pattern2.png"));
fullPattern2 = patternCast(shark,pattern);
sharkGram = stereogram(shark,fullPattern2,15,2);
figure(2); imshow(sharkGram)

function depthMap = makeWordDepthMap(word,s) 
    %Initialize an alphabet that will enable us to get the index of a
    %letter from 1-26 so that we can pull the right image
    alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    indexArray = contains(alphabet,word{1}); %Cell array function we googled
    ind = find(indexArray==1); %#ok<NASGU> 
    letterFilename = [word{1} '.jpeg'];
    %disp(class(letterFilename));
    depthMap = imread(letterFilename);
    for i = 2:s
        letterFilename = [word{i} '.jpeg'];
        letterIm = imread(letterFilename);
        %Here we concatenated the letter images together
        depthMap = cat(2,depthMap,letterIm);

    end
  
end

%function pattern = compress(depthMap, pattern)
function pattern = compress(depthMap, im, numRepeats)
    width = size(depthMap,2);
    im_height = size(im,1);
    im_width = size(im,2);
    pattern_width = floor(width/numRepeats);
    pattern = zeros(im_height,pattern_width,3);
    compressAmt = floor(im_width/pattern_width);
    for i = 1:pattern_width
        pattern(:,i,:) = im(:,i*compressAmt,:);
    end
    pattern = pattern/256;
end

%function fullPattern = patternCast(depthMap, pattern)
function fullPattern = patternCast(depthMap, pattern)
    height = size(depthMap,1);
    width = size(depthMap,2);
    patH = size(pattern,1);
    patW = size(pattern,2);
    %Initialize an empty array that we will fill with values from the
    %full background pattern
    fullPattern = zeros(height,width,3);
    for i=1:height
        for j=1:width
            %This mod trick is cool. We made it so that the indexes for the
            %pattern array repeat once we exceed them.
            iMod = mod(i,patH) + 1;
            jMod = mod(j,patW) + 1;
            %We had to make sure that we took all 3 color channels with
            %this indexing technique
            fullPattern(i,j,:) = pattern(iMod, jMod,:);
        end
    end

    %Might need to uncomment this in some cases for bad pictures that are
    %just made of uint8 values. This was one of the complications we ran
    %into with this method and an easy fix.
    %fullPattern = uint8(fullPattern);
end

%function autoGram = stereogram(depthMap, fullPattern)
function autoGram = stereogram(depthMap, fullPattern, shiftMult,blurAmount)
    %First we normalized the depth map so that nothing was greater than 1
    depthNorm = double(im2gray(depthMap));
    depthNorm = depthNorm ./ max(depthNorm(:));
    height = size(depthMap,1);
    width = size(depthMap,2);
    %At first the stereogram is just the background pattern
    autoGram = fullPattern;
    %This for loop shifts the specific values of the background where the
    %depth map is greater than 0 or where there is an object that we are
    %trying to hide in the stereogram.
     for i=1:height
        for j=1:width
            %This shiftMult value affects how large the difference between
            %the two images are and can actually make the 3D depth images
            %look better with a larger shift amount.
            jShift = j + floor(depthNorm(i,j) * shiftMult);
            autoGram(i,j,:) = fullPattern(i,jShift,:);
        end
     end
     %At the end we blur the result to get rid of the sharp edges that
     %would happen from just shifting pixels alone.
    autoGram = imgaussfilt(autoGram,blurAmount);
end

%function animated = animate(fullPattern, autoGram)
%This function just creates a gif using a matlab function and saves it to
%the local file system. We ended up lowering the delay time to 1 tenth of a
%second so that the stereogram would move fast enough to make the
%differences clear.
function animate(fullPattern,autoGram,filename)
    [A1,map1] = rgb2ind(fullPattern,256);
    [A2,map2] = rgb2ind(autoGram,256);
    imwrite(A1,map1,filename,"gif","LoopCount",Inf,"DelayTime",0.1);
    imwrite(A2,map2,filename,"gif","WriteMode","append","DelayTime",0.1);
end
