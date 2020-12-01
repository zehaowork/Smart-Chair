function [res1] = standingUpTime_barchart(data)
max_time = max(data);
min_time = min(data);
step = (max_time - min_time)/10;


array_height = size(data,2);

res = zeros(1,array_height);
 disp(max_time -step*2)
 disp(max_time -step*3)
 disp(max_time -step*4)
 disp(max_time -step*5)
for x=1:array_height
 
    if data(x) <= max_time && data(x)> max_time -step  %82<x<=100
        res(x)= 1;
    elseif data(x) <= max_time-step && data(x)> max_time -step*2 %64<x<=82
        res(x) =2;
    elseif data(x) <= max_time-step*2 && data(x)> max_time -step*3 %46<x<=64
        res(x) =3;
    elseif data(x) <= max_time-step*3 && data(x)> max_time -step*4 %28<x<=46
        res(x) =4;
    elseif data(x) <= max_time-step*4 && data(x)> max_time -step*5 %28<x<=46
        res(x) =5;
    elseif data(x) <= max_time-step*5 && data(x)> max_time -step*6 %28<x<=46
        res(x) =6;
    elseif data(x) <= max_time-step*6 && data(x)> max_time -step*7 %28<x<=46
        res(x) =7;
    elseif data(x) <= max_time-step*7 && data(x)> max_time -step*8 %28<x<=46
        res(x) =8;
    elseif data(x) <= max_time-step*8 && data(x)> max_time -step*9 %28<x<=46
        res(x) =9;
    else
        res(x) = 10; %10<x<=28
    end
 
  
end
res1 = res;
disp(res1);
end