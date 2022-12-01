im = imread("squirrel.jpeg");
pattern = imread("pattern2.jpeg");
im2 = imread("face.jpeg");

word = {'B', 'R', 'U', 'H'};
s=4;
%-------------------------------------
wordPattern = im2double(imread("wordPattern.jpeg"));
wordDepthMap = makeWordDepthMap(word,s);
%figure(2); imshow(wordDepthMap);
wordFullPattern = patternCast(wordDepthMap,wordPattern);
wordGram = stereogram(wordDepthMap,wordFullPattern,15,2);
figure(1); imshow(wordGram);
animate(imgaussfilt(wordFullPattern,2),wordGram,"wordGif.gif");


%--------------------------------------
newPattern = compress(im, im2, 10);

%figure(1); imshow(newPattern)
fullPattern = patternCast(im, newPattern);

%figure(1); imshow(fullPattern)
gram = stereogram(im,fullPattern,15,5);

figure(2); imshow(gram)
animate(imgaussfilt(fullPattern,5),gram,"picturePattern.gif");

function depthMap = makeWordDepthMap(word,s) 
    alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    indexArray = contains(alphabet,word{1});
    ind = find(indexArray==1); %#ok<NASGU> 
    letterFilename = [word{1} '.jpeg'];
    %disp(class(letterFilename));
    depthMap = imread(letterFilename);
    for i = 2:s
        letterFilename = [word{i} '.jpeg'];
        letterIm = imread(letterFilename);
        %depthMap = imfuse(depthMap,letterIm,'montage');
        %disp(size(letterIm))
        %disp(size(depthMap))
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
    fullPattern = zeros(height,width,3);
    for i=1:height
        for j=1:width
            iMod = mod(i,patH) + 1;
            jMod = mod(j,patW) + 1;
            fullPattern(i,j,:) = pattern(iMod, jMod,:);
        end
    end
    %fullPattern = imgaussfilt(fullPattern,2);

    %Might need to uncomment this in some cases for bad pictures
    %fullPattern = uint8(fullPattern);
end
%function autoGram = stereogram(depthMap, fullPattern)
function autoGram = stereogram(depthMap, fullPattern, shiftMult,blurAmount)
    depthNorm = double(im2gray(depthMap));
    depthNorm = depthNorm ./ max(depthNorm(:));
    height = size(depthMap,1);
    width = size(depthMap,2);
    autoGram = fullPattern;
     for i=1:height
        for j=1:width
            jShift = j + floor(depthNorm(i,j) * shiftMult);
            autoGram(i,j,:) = fullPattern(i,jShift,:);
        end
     end
    autoGram = imgaussfilt(autoGram,blurAmount);
end
%function animated = animate(fullPattern, autoGram)
function animate(fullPattern,autoGram,filename)
    [A1,map1] = rgb2ind(fullPattern,256);
    [A2,map2] = rgb2ind(autoGram,256);
    imwrite(A1,map1,filename,"gif","LoopCount",Inf,"DelayTime",0.1);
    imwrite(A2,map2,filename,"gif","WriteMode","append","DelayTime",0.1);

end
