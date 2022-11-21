% function shifts = calcShift(depthMap)
%     
% end

I = imread("pattern.png");
repeat = repeatIm(I,6);
shifted = imtranslate(repeat, [10, 0]);
imshow(shifted)

function repeated = repeatIm(im,repVal)
    repeated = zeros(size(im,1),repVal*size(im,2),size(im,3));
    for i = 1:repVal
        repeated(:,(i-1)*size(im,2)+1:i*size(im,2),:) = im2double(im);
    end
end
