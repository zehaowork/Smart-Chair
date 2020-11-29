function res  = heat_map(data)

max_x = max(data(1,:));
min_x = min(data(1,:));
max_y = max(data(2,:));
min_y = min(data(2,:));
res = zero(10:30);

  .
  .]
step_x = (max_x-min_x)/30; % 10 rows
step_y = (max_y-min_y)/10; % 30 cols




disp(max_x);
disp(max_y);
disp(data);
end