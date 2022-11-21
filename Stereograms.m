% function shifts = calcShift(depthMap)
%     
% end

pattern = imread("pattern.png");
I = 256.*imread("Test.png");

repeat = repeatIm(pattern,6);
gram = stereogram(repeat,I,20);
%figure; imshow(repeat);
figure; imshow(gram);

function autoGram = stereogram(pattern,im,shamt)
    im = im2gray(im);
    autoGram = pattern;
    shifted = imtranslate(pattern, [shamt, 0]);
    for i = 1:size(im,1)
        for j = 1:size(im,2)
            if im(i,j) >= 250
                autoGram(i,j) = shifted(i,j);
            end
        end
    end
end

function repeated = repeatIm(pattern,repVal)
    repeated = zeros(size(pattern,1),repVal*size(pattern,2),size(pattern,3));
    for i = 1:repVal
        repeated(:,(i-1)*size(pattern,2)+1:i*size(pattern,2),:) = im2double(pattern);
    end
end