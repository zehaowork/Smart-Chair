function [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity,CoPapO_timeTable] = random_force_generator()
   i = 1; %Matrice index "3-rd" dimension variable

    F1 = randfixedsum(4,1,490,20,250);
    F2 =randfixedsum(4,1,490,20,150);
    F3 =randfixedsum(4,1,490,20,150); 
    F4 =randfixedsum(4,1,490,20,150);
    increment  = 0:1:3;
    collected_data  = [F1,F2,F3,F4];
% disp(collected_data)
% disp(collected_data(1:2))
collected_data1 = rand(5,10);
disp(collected_data1);
% disp(collected_data1(2:5,1:4,1));
% disp(collected_data1(2:5,10:10,1));
% disp([collected_data1(2:5,1:4,1),collected_data1(2:5,10:10,1)])
disp(collected_data1(5,:,1))
%     collected_data = [collected_data,increment];
     collected_data =  [collected_data;increment];
    test = rand(4,1);
    disp(test)
    disp(test(4));
    
%     disp(F1)
%    disp(collected_data')
   [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity,CoPapO_timeTable] = cop_calculator(collected_data');

    
    
     
   
end