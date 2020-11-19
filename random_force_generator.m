function [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity,CoPapO_timeTable] = random_force_generator()
   
    F1 = randfixedsum(4,1,490,20,250);
    F2 =randfixedsum(4,1,490,20,150);
    F3 =randfixedsum(4,1,490,20,150); 
    F4 =randfixedsum(4,1,490,20,150);
    increment  = 0:1:3;
    collected_data  = [F1,F2,F3,F4];

%     collected_data = [collected_data,increment];
     collected_data =  [collected_data;increment];

%     disp(F1)
%    disp(collected_data')
   [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity,CoPapO_timeTable] = cop_calculator(collected_data');
    disp(CoPapO_timeTable)
   
end