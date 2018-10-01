vObj = VideoWriter(vfilename);
vObj.FrameRate = 3;
open(vObj);
for t = [1:5, 10, 15, 20, 25]
    for kk = 1 : size(F,2)
       frame = F(t, kk);
       writeVideo(vObj, frame);
    end
end
close(vObj);