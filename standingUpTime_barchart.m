function [res1] = standingUpTime_barchart(data)
max_time = max(data);
min_time = min(data);
step = (max_time - min_time)/10;


array_height = size(data,2);
disp(array_height);
res = zeros(1,array_height);
% disp(max_time -step*2)
% disp(max_time -step*3)
% disp(max_time -step*4)
% disp(max_time -step*5)
for x=1:array_height
    disp('test');
    if data(x) <= max_time && data(x)> max_time -step
        res(x)= 1;
    elseif data(x) <= max_time-step && data(x)> max_time -step*2
        res(x) =2;
    elseif data(x) <= max_time-step*2 && data(x)> max_time -step*3
        res(x) =3;
    elseif data(x) <= max_time-step*3 && data(x)> max_time -step*4
        res(x) =4;
    else
        res(x) = 5;
    end
 
  
end
res1 = res;
disp(res1);
end