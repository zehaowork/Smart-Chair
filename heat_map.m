function res  = heat_map(data)

x_dim = 40;
y_dim = 80;                 


res = zeros(10,30);
array_height = size(data,1);

for x =1:array_height
    data(x,1) = data(x,1) + x_dim/2; % make every value positive
     data(x,2) = data(x,2) + y_dim/2;
end
 
max_x_dim = max(data(:,1));
max_y_dim = max(data(:,2));
min_x_dim = min(data(:,1));
min_y_dim = min(data(:,2));
x_step = (max_x_dim-min_x_dim)/10;
y_step = (max_y_dim-min_y_dim)/30;

   

for i=0:9
    for j=0:29
        lower_bound_x = i*x_step;
        lower_bound_y = j*y_step;
        upper_bound_x = (i+1)*x_step;
        upper_bound_y = (j+1)*y_step;
        

        for x = 1:array_height
            x_val = data(x,1);
            y_val = data(x,2);
            
            
            if x_val >= lower_bound_x && x_val<upper_bound_x && y_val>=lower_bound_y && y_val<upper_bound_y
                res(i+1,j+1) = res(i+1,j+1)+1;
            end
        end
    end
end



end